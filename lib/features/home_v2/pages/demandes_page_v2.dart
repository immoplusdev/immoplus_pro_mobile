import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:immoplus_pro/common/widgets/v2/immo_empty_display.dart';
import 'package:immoplus_pro/cubits/demandes/demandes_cubit.dart';
import 'package:immoplus_pro/cubits/demandes/demandes_state.dart';
import 'package:immoplus_pro/data/enums/alert_enums.dart';
import 'package:immoplus_pro/data/models/demandes/alert_marketplace_model.dart';
import 'package:immoplus_pro/features/home_page/widgets/booking_loading_card.dart';
import 'package:immoplus_pro/features/home_v2/widgets/demande_card_v2.dart';

class DemandesPageV2 extends StatefulWidget {
  final ValueNotifier<AlertViewFilter> filterNotifier;
  final ValueChanged<int>? onCountChanged;

  const DemandesPageV2({
    super.key,
    required this.filterNotifier,
    this.onCountChanged,
  });

  @override
  State<DemandesPageV2> createState() => _DemandesPageV2State();
}

class _DemandesPageV2State extends State<DemandesPageV2> {
  late final DemandesCubit _demandesCubit;

  @override
  void initState() {
    super.initState();
    _demandesCubit = DemandesCubit();
    widget.filterNotifier.addListener(_onFilterChanged);
  }

  void _onFilterChanged() {
    _demandesCubit.setFilter(widget.filterNotifier.value);
  }

  @override
  void dispose() {
    widget.filterNotifier.removeListener(_onFilterChanged);
    _demandesCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _demandesCubit,
      child: BlocListener<DemandesCubit, DemandesState>(
        listener: (context, state) {
          if (state is DemandesLoaded) {
            widget.onCountChanged?.call(state.totalCount);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: RefreshIndicator(
            onRefresh: () async {
              _demandesCubit.refresh();
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
                PagedSliverList<int, AlertMarketplaceItem>(
                  pagingController: _demandesCubit.pagingController,
                  builderDelegate:
                      PagedChildBuilderDelegate<AlertMarketplaceItem>(
                    firstPageProgressIndicatorBuilder: (context) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: List.generate(
                          4,
                          (index) => const BookingLoadingCard(),
                        ),
                      ),
                    ),
                    noItemsFoundIndicatorBuilder: (context) =>
                        const ImmoEmptyDisplay(
                      text:
                          "Vous n'avez aucune demande pour le moment. Toutes les demandes de clients correspondantes s'afficheront ici.",
                    ),
                    itemBuilder: (context, item, index) => DemandeCardV2(
                      item: item,
                      onRefresh: () => _demandesCubit.refresh(),
                    ),
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
