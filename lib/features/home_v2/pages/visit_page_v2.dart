import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/common/order_dir.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/demande_visite_model.dart';
import 'package:immoplus_pro/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus_pro/features/payments/logic/wallet_cubit.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/features/home_page/widgets/booking_loading_card.dart';
import 'package:immoplus_pro/features/home_v2/widgets/visit_card_v2.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:immoplus_pro/core/models/query_filter.dart';
import 'package:immoplus_pro/common/widgets/v2/immo_empty_display.dart';

enum VisitFilterV2 { all, express, normal }

class VisitPageV2 extends StatefulWidget {
  final ValueNotifier<VisitFilterV2> filterNotifier;
  const VisitPageV2({super.key, required this.filterNotifier});

  @override
  State<VisitPageV2> createState() => _VisitPageV2State();
}

class _VisitPageV2State extends State<VisitPageV2> {
  final PagingController<int, DemandeVisiteModel> _pagingController =
      PagingController(firstPageKey: 1);

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
      final List<QueryFilter> filters = [];

      if (widget.filterNotifier.value == VisitFilterV2.express) {
        filters.add(QueryFilter(
          field: 'typeDemandeVisite',
          operator: FilterOperator.eq,
          value: 'express',
        ));
      } else if (widget.filterNotifier.value == VisitFilterV2.normal) {
        filters.add(QueryFilter(
          field: 'typeDemandeVisite',
          operator: FilterOperator.eq,
          value: 'normal',
        ));
      }

      final result = await BienImmobilierRepository.getVisitesOwner(
        id: SessionManager().currentUser!.userId.toString(),
        page: pageKey,
        perPage: 10,
        orderBy: OrderByField.createdAt.value,
        orderDir: OrderDir.desc.value,
        where: QueryBuilder.build(filters: filters),
      );

      final isLastPage = result.hasNext == false;
      if (isLastPage) {
        _pagingController.appendLastPage(result.data ?? []);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(result.data ?? [], nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    widget.filterNotifier.removeListener(_onFilterChanged);
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
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
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            PagedSliverList<int, DemandeVisiteModel>(
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
                      "Vous n'avez aucune visite pour le moment. Toutes les visites en cours s'afficheront ici.",
                ),
                itemBuilder: (context, item, index) => VisitCardV2(
                  demandeVisiteModel: item,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
