import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/furniture/furniture_model.dart';
import 'package:immoplus_pro/data/repositories/furniture_repository.dart';
import 'package:immoplus_pro/features/create_furniture/create_furniture_page.dart';
import 'package:immoplus_pro/features/create_furniture/utils/furniture_creation_manager.dart';
import 'package:immoplus_pro/features/furniture_detail/furniture_detail_page.dart';
import 'package:immoplus_pro/features/furnitures/theme/furniture_theme.dart';
import 'package:immoplus_pro/features/home_page/home_page.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';

class FurnituresPage extends StatefulWidget {
  const FurnituresPage({super.key});

  static String name = 'furnitures_page';
  static String routePath() => '/furnitures';

  @override
  State<FurnituresPage> createState() => _FurnituresPageState();
}

class _FurnituresPageState extends State<FurnituresPage> {
  final PagingController<int, FurnitureModel> _pagingController =
      PagingController(firstPageKey: 1);

  bool _hasItems = false;

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      _loadPage(pageKey);
    });

    _pagingController.addListener(() {
      final hasItems = _pagingController.itemList?.isNotEmpty == true;
      if (_hasItems != hasItems) {
        setState(() {
          _hasItems = hasItems;
        });
      }
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  /// Charge une page de meubles depuis l'API.
  Future<void> _loadPage(int page) async {
    try {
      final response = await FurnitureRepository.getFurnitures(
        page: page,
        perPage: 10,
      );
      if (response.hasNext == true) {
        _pagingController.appendPage(
          response.data ?? [],
          (response.currentPage ?? page) + 1,
        );
      } else {
        _pagingController.appendLastPage(response.data ?? []);
      }
    } catch (error) {
      _pagingController.error = error.toString();
    }
  }

  /// Ouvre la page de création de meuble et rafraîchit la liste au retour.
  Future<void> _tapCreateFurniture() async {
    FurnitureCreationManager().reset();
    final result = await context.pushNamed(CreateFurniturePage.name);
    if (result == true && mounted) {
      _pagingController.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      appBar: AppBar(
        backgroundColor: AppColors.whiteBackground,
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.chevronLeft),
          onPressed: () {
            context.goNamed(HomePage.name);
          },
        ),
        title: const Text('Mes meubles'),
        titleTextStyle: Theme.of(context).textTheme.titleSmall,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // ── Pull-to-refresh ──
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              _pagingController.refresh();
            },
          ),

          const SliverGap(10),

          // ── Liste paginée ──
          PagedSliverList<int, FurnitureModel>(
            addAutomaticKeepAlives: false,
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<FurnitureModel>(
              // ── Skeleton de chargement ──
              firstPageProgressIndicatorBuilder: (context) => Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: List.generate(
                    6,
                    (index) => const _FurnitureLoadingCard(),
                  ),
                ),
              ),

              // ── État vide ──
              noItemsFoundIndicatorBuilder: (context) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Gap(100),
                    SvgPicture.asset(
                      'assets/svgs/undraw/house.svg',
                      width: 200,
                    ),
                    const Gap(30),
                    Text(
                      'Aucun meuble trouvé',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Gap(16),
                    const Text(
                      "Vous n'avez pas encore ajouté de meubles sur ImmoPlus. "
                      'Commencez dès maintenant en publiant votre premier meuble.',
                      textAlign: TextAlign.center,
                    ),
                    const Gap(24),
                    ElevatedButton(
                      style: FurnitureTheme.primaryButtonStyle.copyWith(
                        minimumSize:
                            WidgetStateProperty.all(const Size(250, 48)),
                      ),
                      onPressed: _tapCreateFurniture,
                      child: const Text('Ajouter un meuble'),
                    ),
                  ],
                ),
              ),

              // ── Card de meuble ──
              itemBuilder: (context, item, index) => _FurnitureListCard(
                furniture: item,
                onTap: () async {
                  await context.pushNamed(
                    FurnitureDetailPage.name,
                    pathParameters: {'id': item.id},
                  );
                  _pagingController.refresh();
                },
              ),
            ),
          ),
        ],
      ),

      // ── FAB Ajouter ──
      floatingActionButton: _hasItems
          ? FloatingActionButton.extended(
              onPressed: _tapCreateFurniture,
              backgroundColor: AppColors.primary,
              icon: const Icon(
                FontAwesomeIcons.plus,
                color: Colors.white,
              ),
              label: const Text(
                'Ajouter Des Meubles',
                style: TextStyle(color: Colors.white),
              ),
            )
          : null,
    );
  }
}

/// Card d'un meuble dans la liste.

class _FurnitureListCard extends StatelessWidget {
  const _FurnitureListCard({
    required this.furniture,
    required this.onTap,
  });

  final FurnitureModel furniture;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,

          // box shadow here retrive it from the theme
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12).copyWith(bottom: 12),
        child: Row(
          children: [
            // ── Image gauche ──
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: SizedBox(
                width: 100,
                height: 130,
                child: _buildImage(),
              ),
            ),

            // ── Détails droite ──
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Titre
                    Text(
                      furniture.titre,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),

                    // Adresse
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const Gap(2),
                        Flexible(
                          child: Text(
                            furniture.adresse,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.grey.shade600),
                          ),
                        ),
                      ],
                    ),

                    // Prix
                    Text(
                      '${Utils.formatCurrency(furniture.prix)} FCFA',
                      style: FurnitureTheme.priceText,
                    ),

                    // Statut + vues
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FurnitureTheme.statusBadge(furniture.status.name),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              FontAwesomeIcons.eye,
                              size: 12,
                              color: Colors.grey.shade400,
                            ),
                            const Gap(4),
                            Text(
                              '${furniture.viewsCount}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── Chevron ──
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Icon(
                CupertinoIcons.chevron_right,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Affiche l'image du meuble ou un placeholder gris.
  Widget _buildImage() {
    final hasImage = furniture.images != null && furniture.images!.isNotEmpty;

    if (!hasImage) {
      return Container(
        color: Colors.grey.shade200,
        child: Center(
          child: Icon(
            FontAwesomeIcons.couch,
            color: Colors.grey.shade400,
            size: 28,
          ),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: Utils.getImagePath(id: furniture.images!.first),
      fit: BoxFit.cover,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        period: const Duration(milliseconds: 500),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey.shade200,
        child: const Icon(Icons.error_outline, color: Colors.grey),
      ),
    );
  }
}

/// Skeleton de chargement imitant la forme d'une [_FurnitureListCard].
class _FurnitureLoadingCard extends StatelessWidget {
  const _FurnitureLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12).copyWith(bottom: 12),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Row(
          children: [
            // Image placeholder
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Container(
                width: 100,
                height: 130,
                color: Colors.white,
              ),
            ),

            // Text placeholders
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 140,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      width: 90,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
