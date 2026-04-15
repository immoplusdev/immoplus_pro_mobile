import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/common/order_dir.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/features/payments/logic/wallet_cubit.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/features/home_v2/widgets/booking_card_v2.dart';
import 'package:immoplus_pro/features/home_page/widgets/booking_loading_card.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:immoplus_pro/core/models/query_filter.dart';
import 'package:immoplus_pro/common/widgets/v2/immo_empty_display.dart';
import 'package:immoplus_pro/data/models/reservations/status_reservation.dart';
import 'package:immoplus_pro/data/models/reservations/reservations_collection.dart';
import 'package:immoplus_pro/features/reservations/pending/pending_reservations_cubit.dart';
import 'package:immoplus_pro/features/home_v2/widgets/pending_reservation_card_v2.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/features/booking/booking_history_page.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/reservations/reservations_collection.dart';
import 'package:immoplus_pro/features/reservations/pending/pending_reservations_cubit.dart';
import 'package:immoplus_pro/features/home_v2/widgets/pending_reservation_card_v2.dart';
import 'package:immoplus_pro/app_states/request_state.dart';

enum BookingFilterV2 { all, pending, paid, attentePro, attentePaiement }

class BookingPageV2 extends StatefulWidget {
  final ValueNotifier<BookingFilterV2> filterNotifier;
  final ValueChanged<int>? onCountChanged;
  const BookingPageV2({super.key, required this.filterNotifier, this.onCountChanged});

  @override
  State<BookingPageV2> createState() => _BookingPageV2State();
}

class _BookingPageV2State extends State<BookingPageV2> {
  final PagingController<int, ReservationModel> _pagingController =
      PagingController(firstPageKey: 1);
  final PendingReservationsCubit _pendingCubit = PendingReservationsCubit();

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    widget.filterNotifier.addListener(_onFilterChanged);
  }

  void _onFilterChanged() {
    _pagingController.refresh();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final ownerId = SessionManager().currentUser!.userId.toString();
      ReservationsCollection result;

      if (widget.filterNotifier.value == BookingFilterV2.attentePro) {
        result = await LogmentRepository.getReservationsEnAttenteReponse(
          ownerId: ownerId,
          page: pageKey,
          perPage: 10,
          orderBy: OrderByField.createdAt.value,
          orderDir: OrderDir.desc.value,
        );
      } else if (widget.filterNotifier.value ==
          BookingFilterV2.attentePaiement) {
        result = await LogmentRepository.getReservationsOwner(
          id: ownerId,
          page: pageKey,
          perPage: 10,
          orderBy: OrderByField.createdAt.value,
          orderDir: OrderDir.desc.value,
          where: {
            '_where': [
              '{"_field": "statusFacture", "_op": "eq", "_val": "non_paye"}',
              '{"_field": "statusReservation", "_op": "eq", "_val": "${StatusReservation.enAttentePaiementClient.backendValue}"}',
            ],
          },
        );
      } else {
        final List<QueryFilter> filters = [];
        if (widget.filterNotifier.value == BookingFilterV2.pending) {
          filters.add(QueryFilter(
            field: 'statusFacture',
            operator: FilterOperator.eq,
            value: 'attente',
          ));
        } else if (widget.filterNotifier.value == BookingFilterV2.paid) {
          filters.add(QueryFilter(
            field: 'statusFacture',
            operator: FilterOperator.eq,
            value: 'paye',
          ));
        }

        result = await LogmentRepository.getReservationsOwner(
          id: ownerId,
          page: pageKey,
          perPage: 10,
          orderBy: OrderByField.createdAt.value,
          orderDir: OrderDir.desc.value,
          where: QueryBuilder.build(filters: filters),
        );
      }

      if (pageKey == 1) {
        widget.onCountChanged?.call(result.totalCount);
        
        final data = result.data ?? [];
        if (data.length > 3) {
          _pagingController.appendLastPage(data.take(3).toList());
        } else {
          _pagingController.appendLastPage(data);
        }
        return;
      }

      final isLastPage = result.hasNext == false;
      if (isLastPage) {
        _pagingController.appendLastPage(result.data);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(result.data, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    widget.filterNotifier.removeListener(_onFilterChanged);
    _pagingController.dispose();
    _pendingCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider.value(
        value: _pendingCubit,
        child: BlocListener<PendingReservationsCubit, RequestState>(
          listener: (context, state) {
            if (state is REQUEST_SUCCESS) {
              _pagingController.refresh();
            }
          },
          child: RefreshIndicator(
            onRefresh: () async {
              _pagingController.refresh();
              context.read<WalletCubit>().onGetWallet();
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                PagedSliverList<int, ReservationModel>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate(
                    firstPageProgressIndicatorBuilder: (context) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: List.generate(
                          5,
                          (index) => const BookingLoadingCard(),
                        ),
                      ),
                    ),
                    noItemsFoundIndicatorBuilder: (context) =>
                        const ImmoEmptyDisplay(
                      text:
                          "Vous n'avez aucune réservation pour le moment. Toutes les réservations en cours s'afficheront ici.",
                    ),
                    noMoreItemsIndicatorBuilder: (context) {
                      if (_pagingController.itemList == null || _pagingController.itemList!.isEmpty) {
                        return const SizedBox();
                      }
                      return Transform.translate(
                        offset: const Offset(0, -15),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                context.pushNamed(BookingHistoryPage.name); 
                              },
                              child: Text(
                                "Tout afficher",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemBuilder: (context, item, index) {
                      if (widget.filterNotifier.value ==
                          BookingFilterV2.attentePro) {
                        return PendingReservationCardV2(reservationModel: item);
                      }
                      return BookingCardV2(
                        reservationModel: item,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
