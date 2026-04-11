import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/data/models/furniture/furniture_model.dart';
import 'package:immoplus_pro/data/repositories/furniture_repository.dart';
import 'package:immoplus_pro/features/create_furniture_v2/create_furniture_page_v2.dart';
import 'package:immoplus_pro/features/home_page/home_page.dart';
import 'package:immoplus_pro/features/furnitures/widgets/furniture_grid_card.dart';
import 'package:immoplus_pro/features/furniture_detail/furniture_detail_page_v2.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:immoplus_pro/common/widgets/empty_state_v2.dart';
import 'package:immoplus_pro/core/models/query_filter.dart';
import 'package:iconsax/iconsax.dart';

enum FurnitureFilter { all, salon, literie, cuisine, bureau, decoration }

class FurnituresPageV2 extends StatefulWidget {
  const FurnituresPageV2({super.key});

  static const name = 'FURNITURES_PAGE_V2';
  static const routePath = '/furnitures_v2';

  @override
  State<FurnituresPageV2> createState() => _FurnituresPageV2State();
}

class _FurnituresPageV2State extends State<FurnituresPageV2> {
  final PagingController<int, FurnitureModel> _pagingController =
      PagingController(firstPageKey: 1);
  FurnitureFilter _activeFilter = FurnitureFilter.all;
  int _totalCount = 0;
  final sessionManager = getIt<SessionManager>();
  // final GlobalKey _shareButtonKey = GlobalKey();

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
      if (_activeFilter != FurnitureFilter.all) {
        filters.add(QueryFilter(
          field: 'category',
          operator: FilterOperator.eq,
          value: _activeFilter.name,
        ));
      }

      final result = await FurnitureRepository.getFurnitures(
        page: pageKey,
        perPage: 10,
        orderBy: 'createdAt',
        orderDir: 'desc',
        where: QueryBuilder.build(filters: filters),
      );

      setState(() {
        _totalCount = (_pagingController.itemList?.length ?? 0) +
            (result.data?.length ?? 0);
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

  void _updateFilter(FurnitureFilter filter) {
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
          // IconButton(
          //   onPressed: () async {
          //     final String shareUrl =
          //         'https://app.immoplus.ci/user_furnitures/${sessionManager.currentUser?.userId}';

          //     final origin =
          //         ShareService.getSharePositionFromKey(_shareButtonKey);
          //     await ShareService.shareText(
          //         text: 'Découvrez mes meubles sur ImmoPlus\n$shareUrl',
          //         subject: 'Partager mon catalogue de meubles',
          //         sharePositionOrigin: origin);
          //   },
          //   icon: Icon(
          //     key: _shareButtonKey,
          //     Iconsax.send_2,
          //   ),
          // ),
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
                  "Mes meubles",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    letterSpacing: -0.5,
                  ),
                ),
                const Gap(4),
                Text(
                  "$_totalCount meubles répertoriés",
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
                        _buildFilterChip("Tous", FurnitureFilter.all),
                        const Gap(12),
                        _buildFilterChip("Salon", FurnitureFilter.salon),
                        const Gap(12),
                        _buildFilterChip("Literie", FurnitureFilter.literie),
                        const Gap(12),
                        _buildFilterChip("Cuisine", FurnitureFilter.cuisine),
                        const Gap(12),
                        _buildFilterChip("Bureau", FurnitureFilter.bureau),
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
                child: PagedGridView<int, FurnitureModel>(
                  pagingController: _pagingController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 0.85,
                  ),
                  builderDelegate: PagedChildBuilderDelegate<FurnitureModel>(
                    itemBuilder: (context, item, index) => FurnitureGridCard(
                      furniture: item,
                      onTap: () async {
                        await context.pushNamed(FurnitureDetailPageV2.name,
                            pathParameters: {'id': item.id});
                        _pagingController.refresh();
                      },
                    ),
                    firstPageProgressIndicatorBuilder: (_) => const Center(
                      child: CupertinoActivityIndicator(),
                    ),
                    noItemsFoundIndicatorBuilder: (_) => const EmptyStateV2(
                      title: "Aucun meuble",
                      description:
                          "Aucun meuble trouvé avec les filtres actuels",
                      icon: Iconsax.box,
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
          final result = await context.pushNamed(CreateFurniturePageV2.name);
          if (result == true) _pagingController.refresh();
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterChip(String label, FurnitureFilter filter) {
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
