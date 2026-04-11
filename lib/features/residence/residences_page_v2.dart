import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/common/order_dir.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/core/services/share_service.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/features/create_residence_v2/create_lodgment_page_v2.dart';
import 'package:immoplus_pro/features/home_page/home_page.dart';
import 'package:immoplus_pro/features/residence/widgets/residence_grid_card.dart';
import 'package:immoplus_pro/features/residence_detail/residence_details_page_v2.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:immoplus_pro/core/models/query_filter.dart';
import 'package:immoplus_pro/common/widgets/empty_state_v2.dart';
import 'package:iconsax/iconsax.dart';

enum ResidenceFilter { all, available, occupied }

class ResidencesPageV2 extends StatefulWidget {
  const ResidencesPageV2({super.key});

  static const name = 'RESIDENCES_PAGE_V2';
  static const routePath = '/residences_v2';

  @override
  State<ResidencesPageV2> createState() => _ResidencesPageV2State();
}

class _ResidencesPageV2State extends State<ResidencesPageV2> {
  final PagingController<int, ResidenceModel> _pagingController =
      PagingController(firstPageKey: 1);
  ResidenceFilter _activeFilter = ResidenceFilter.all;
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
      if (_activeFilter == ResidenceFilter.available) {
        filters.add(QueryFilter(
          field: 'residenceDisponible',
          operator: FilterOperator.eq,
          value: true,
        ));
      } else if (_activeFilter == ResidenceFilter.occupied) {
        filters.add(QueryFilter(
          field: 'residenceDisponible',
          operator: FilterOperator.eq,
          value: false,
        ));
      }

      final result = await LogmentRepository.getResidences(
        page: pageKey,
        orderBy: 'createdAt',
        orderDir: OrderDir.desc.value,
        where: QueryBuilder.build(filters: filters),
      );

      setState(() {
        _totalCount = _pagingController.itemList?.length ?? 0;
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

  void _updateFilter(ResidenceFilter filter) {
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
          onPressed: () => context.goNamed(HomePage.name),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              // Code for the placeholder:
              final String shareUrl =
                  'https://app.immoplus.ci/user_residences/${sessionManager.currentUser?.userId}  ';

              final origin =
                  ShareService.getSharePositionFromKey(_shareButtonKey);
              await ShareService.shareText(
                  text: 'Découvrez mes résidences sur ImmoPlus\n$shareUrl',
                  subject: 'Partager mes résidences ImmoPlus',
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
                  "Mes résidences",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    letterSpacing: -0.5,
                  ),
                ),
                const Gap(4),
                Text(
                  "$_totalCount résidences répertoriées",
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
                        _buildFilterChip("Tous", ResidenceFilter.all),
                        const Gap(12),
                        _buildFilterChip(
                            "Disponible", ResidenceFilter.available),
                        const Gap(12),
                        _buildFilterChip("Occupé", ResidenceFilter.occupied),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.tune, color: Colors.black54),
                  onPressed: () {
                    // TODO: Filter modal
                  },
                ),
              ],
            ),

            const Gap(25),

            // GRID
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => Future.sync(() => _pagingController.refresh()),
                child: PagedGridView<int, ResidenceModel>(
                  pagingController: _pagingController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 9,
                    crossAxisSpacing: 13,
                    childAspectRatio: 1.15,
                  ),
                  builderDelegate: PagedChildBuilderDelegate<ResidenceModel>(
                    itemBuilder: (context, item, index) => ResidenceGridCard(
                      residence: item,
                      onTap: () async {
                        await context.pushNamed(ResidenceDetailsPageV2.name,
                            pathParameters: {'id': item.id});
                        _pagingController.refresh();
                      },
                    ),
                    firstPageProgressIndicatorBuilder: (_) => const Center(
                      child: CupertinoActivityIndicator(),
                    ),
                    noItemsFoundIndicatorBuilder: (_) => const EmptyStateV2(
                      title: "Aucune résidence",
                      description:
                          "Aucune résidence trouvée avec les filtres actuels",
                      icon: Iconsax.home_2,
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
          final result = await context.pushNamed(CreateLodgmentPageV2.name);
          if (result == true) _pagingController.refresh();
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterChip(String label, ResidenceFilter filter) {
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
          label,
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
