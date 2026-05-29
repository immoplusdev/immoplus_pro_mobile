import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/common/order_dir.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/core/services/share_service.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus_pro/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus_pro/features/create_estate_v2/create_estate_page_v2.dart';
import 'package:immoplus_pro/features/estates/widgets/estate_grid_card.dart';
import 'package:immoplus_pro/features/estate_detail/estate_details_page_v2.dart';
import 'package:immoplus_pro/features/home_v2/home_page_v2.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:immoplus_pro/core/models/query_filter.dart';
import 'package:immoplus_pro/common/widgets/empty_state_v2.dart';
import 'package:iconsax/iconsax.dart';

enum EstateFilter {
  all,
  enAttentedeValidation,
  rejete,
  valide;

  String get label {
    switch (this) {
      case EstateFilter.all:
        return "Tous";
      case EstateFilter.enAttentedeValidation:
        return "En attente de validation";
      case EstateFilter.rejete:
        return "Rejeté";
      case EstateFilter.valide:
        return "Validé";
    }
  }

  String get value {
    switch (this) {
      case EstateFilter.all:
        return "all";
      case EstateFilter.enAttentedeValidation:
        return "en_attente_validation";
      case EstateFilter.rejete:
        return "rejete";
      case EstateFilter.valide:
        return "valide";
    }
  }
}

class EstatesPageV2 extends StatefulWidget {
  const EstatesPageV2({super.key});

  static const name = 'ESTATES_PAGE_V2';
  static const routePath = '/estate_page_v2';

  static String route() {
    return '/estate_page';
  }

  @override
  State<EstatesPageV2> createState() => _EstatesPageV2State();
}

class _EstatesPageV2State extends State<EstatesPageV2> {
  final PagingController<int, BienImmobilierModel> _pagingController =
      PagingController(firstPageKey: 1);
  EstateFilter _activeFilter = EstateFilter.all;
  int _totalCount = 0;
  final sessionManager = getIt<SessionManager>();
  final GlobalKey _shareButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final List<QueryFilter> filters = [];
      if (_activeFilter == EstateFilter.enAttentedeValidation) {
        filters.add(QueryFilter(
          field: 'statusValidation',
          operator: FilterOperator.eq,
          value: EstateFilter.enAttentedeValidation.value,
        ));
      } else if (_activeFilter == EstateFilter.rejete) {
        filters.add(QueryFilter(
          field: 'statusValidation',
          operator: FilterOperator.eq,
          value: EstateFilter.rejete.value,
        ));
      } else if (_activeFilter == EstateFilter.valide) {
        filters.add(QueryFilter(
          field: 'statusValidation',
          operator: FilterOperator.eq,
          value: EstateFilter.valide.value,
        ));
      }

      final result = await BienImmobilierRepository.getBiensImmobiliers(
        page: pageKey,
        perPage: 10,
        orderBy: OrderByField.createdAt.value,
        orderDir: OrderDir.desc.value,
        where: QueryBuilder.build(filters: filters),
      );

      setState(() {
        _totalCount = result.totalCount ?? 0;
      });

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

  void _updateFilter(EstateFilter filter) {
    if (_activeFilter == filter) return;
    setState(() {
      _activeFilter = filter;
      _pagingController.refresh();
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => context.goNamed(HomePageV2.name),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final String shareUrl =
                  'https://app.immoplus.ci/user_estates/${sessionManager.currentUser?.userId}  ';

              final origin =
                  ShareService.getSharePositionFromKey(_shareButtonKey);
              await ShareService.shareText(
                  text:
                      'Découvrez mes biens immobiliers sur ImmoPlus\n$shareUrl',
                  subject: 'Partager mes biens immobiliers',
                  sharePositionOrigin: origin);
            },
            icon: Icon(
              key: _shareButtonKey,
              Iconsax.send_2,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Mes biens immobilier",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    letterSpacing: -0.5,
                  ),
                ),
                const Gap(4),
                Text(
                  "$_totalCount bien immobilier répertoriées",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),

            const Gap(25),

            // FILTERS
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(EstateFilter.all),
                        const Gap(12),
                        _buildFilterChip(EstateFilter.valide),
                        const Gap(12),
                        _buildFilterChip(EstateFilter.enAttentedeValidation),
                        const Gap(12),
                        _buildFilterChip(EstateFilter.rejete),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const Gap(25),

            // GRID
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => Future.sync(() => _pagingController.refresh()),
                child: PagedGridView<int, BienImmobilierModel>(
                  pagingController: _pagingController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 9,
                    crossAxisSpacing: 13,
                    childAspectRatio: 1.15,
                  ),
                  builderDelegate:
                      PagedChildBuilderDelegate<BienImmobilierModel>(
                    itemBuilder: (context, item, index) => EstateGridCard(
                      estate: item,
                      onTap: () async {
                        await context.pushNamed(EstateDetailsPageV2.name,
                            pathParameters: {'id': item.id});
                        _pagingController.refresh();
                      },
                    ),
                    firstPageProgressIndicatorBuilder: (_) => const Center(
                      child: CupertinoActivityIndicator(),
                    ),
                    noItemsFoundIndicatorBuilder: (_) => const EmptyStateV2(
                      title: "Aucun bien",
                      description:
                          "Aucun bien immobilier trouvé avec les filtres actuels",
                      icon: Iconsax.house_2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.pushNamed(CreateEstatePageV2.name);
          if (result == true) _pagingController.refresh();
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterChip(EstateFilter filter) {
    final bool isSelected = _activeFilter == filter;
    return InkWell(
      onTap: () => _updateFilter(filter),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
          ),
        ),
        child: Text(
          filter.label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
