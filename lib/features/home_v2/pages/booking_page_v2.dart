import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/common/order_dir.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/features/payments/logic/wallet_cubit.dart';
import 'package:immoplus_pro/services/reservation_socket_service.dart';
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
import 'package:immoplus_pro/features/reservations/invitations/owner_invitations_cubit.dart';
import 'package:immoplus_pro/features/reservations/invitations/owner_invitations_state.dart';

enum BookingFilterV2 { all, pending, paid, nouvelle }

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
  final OwnerInvitationsCubit _invitationsCubit = OwnerInvitationsCubit();
  StreamSubscription<ReservationStatusUpdatedEvent>? _socketSubscription;
  int _reservationsTotal = 0;
  int _invitationsTotal = 0;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    widget.filterNotifier.addListener(_onFilterChanged);
    _socketSubscription = getIt<ReservationSocketService>()
        .onStatusUpdated
        .listen(_onReservationStatusUpdated);
    if (widget.filterNotifier.value == BookingFilterV2.nouvelle) {
      _invitationsCubit.load();
    }
  }

  /// Réagit au canal temps réel des réservations (voir ReservationSocketService).
  void _onReservationStatusUpdated(ReservationStatusUpdatedEvent event) {
    switch (event.status) {
      case StatusReservation.enAttenteReponseProprietaire:
        _insertIfCurrentFilter(BookingFilterV2.nouvelle, event.reservationId);
        break;
      case StatusReservation.clientAnnuleReservation:
        _removeIfCurrentFilter(
          const {BookingFilterV2.nouvelle},
          event.reservationId,
        );
        break;
      case StatusReservation.valide:
        _removeIfCurrentFilter(
          const {BookingFilterV2.nouvelle},
          event.reservationId,
        );
        _insertIfCurrentFilter(BookingFilterV2.paid, event.reservationId);
        break;
      default:
        break;
    }
  }

  void _removeIfCurrentFilter(Set<BookingFilterV2> filters, String reservationId) {
    if (!filters.contains(widget.filterNotifier.value)) return;
    final current = _pagingController.itemList;
    if (current == null) return;
    _pagingController.itemList =
        current.where((r) => r.id != reservationId).toList();
  }

  Future<void> _insertIfCurrentFilter(
      BookingFilterV2 filter, String reservationId) async {
    if (widget.filterNotifier.value != filter) return;
    final current = _pagingController.itemList;
    if (current == null) return;
    if (current.any((r) => r.id == reservationId)) return;
    try {
      final response = await LogmentRepository.getReservation(id: reservationId);
      if (!mounted || widget.filterNotifier.value != filter) return;
      _pagingController.itemList = [response.data, ...?_pagingController.itemList];
    } catch (_) {
      // Pas grave : le prochain refresh/switch d'onglet récupérera l'item.
    }
  }

  void _onFilterChanged() {
    _pagingController.refresh();
    if (widget.filterNotifier.value == BookingFilterV2.nouvelle) {
      _invitationsCubit.load();
    }
    // Rebuild pour que la section invitations (visible seulement sur le
    // filtre "nouvelle") apparaisse/disparaisse avec le reste de la liste.
    if (mounted) setState(() {});
  }

  void _reportTotalCount() {
    final invitations = widget.filterNotifier.value == BookingFilterV2.nouvelle
        ? _invitationsTotal
        : 0;
    widget.onCountChanged?.call(_reservationsTotal + invitations);
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final ownerId = SessionManager().currentUser!.userId.toString();
      ReservationsCollection result;

      if (widget.filterNotifier.value == BookingFilterV2.nouvelle) {
        // "Nouvelle réservation" fusionne les statuts "en attente de
        // réponse propriétaire" et "en attente de paiement client" en une
        // seule liste, via le endpoint générique avec un opérateur `in`.
        result = await LogmentRepository.getAllReservationsOwner(
          page: pageKey,
          perPage: 10,
          orderBy: OrderByField.createdAt.value,
          orderDir: OrderDir.desc.value,
          where: {
            '_where': [
              jsonEncode({
                '_field': 'statusReservation',
                '_op': 'in',
                '_val': [
                  StatusReservation.enAttenteReponseProprietaire.backendValue,
                  StatusReservation.enAttentePaiementClient.backendValue,
                ],
              }),
            ],
          },
        );
      } else if (widget.filterNotifier.value == BookingFilterV2.all) {
        result = await LogmentRepository.getAllReservationsOwner(
          page: pageKey,
          perPage: 10,
          orderBy: OrderByField.createdAt.value,
          orderDir: OrderDir.desc.value,
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
        _reservationsTotal = result.totalCount;
        _reportTotalCount();
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
    _socketSubscription?.cancel();
    _pagingController.dispose();
    _pendingCubit.close();
    _invitationsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _pendingCubit),
          BlocProvider.value(value: _invitationsCubit),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<PendingReservationsCubit, RequestState>(
              listener: (context, state) {
                if (state is REQUEST_SUCCESS) {
                  _pagingController.refresh();
                }
              },
            ),
            BlocListener<OwnerInvitationsCubit, OwnerInvitationsState>(
              listener: (context, state) {
                if (state is OwnerInvitationsLoaded) {
                  _invitationsTotal = state.items.length;
                  _reportTotalCount();
                }
              },
            ),
          ],
          child: RefreshIndicator(
            onRefresh: () async {
              _pagingController.refresh();
              context.read<WalletCubit>().onGetWallet();
              if (widget.filterNotifier.value == BookingFilterV2.nouvelle) {
                _invitationsCubit.load();
              }
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
                if (widget.filterNotifier.value == BookingFilterV2.nouvelle)
                  SliverToBoxAdapter(
                    child: BlocBuilder<OwnerInvitationsCubit,
                        OwnerInvitationsState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            if (state is OwnerInvitationsLoaded)
                              ...state.items.map((item) =>
                                  PendingReservationCardV2(invitation: item)),
                          ],
                        );
                      },
                    ),
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
                    itemBuilder: (context, item, index) {
                      final needsOwnerResponse = item.statusEnum ==
                          StatusReservation.enAttenteReponseProprietaire;
                      final showsActionCard = needsOwnerResponse &&
                          (widget.filterNotifier.value ==
                                  BookingFilterV2.nouvelle ||
                              widget.filterNotifier.value ==
                                  BookingFilterV2.all);
                      if (showsActionCard) {
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
