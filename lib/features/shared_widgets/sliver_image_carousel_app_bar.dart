import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:shimmer/shimmer.dart';

/// SliverAppBar réutilisable avec carousel d'images (liste d'URLs).
///
/// Utilisable sur toute page de détail (meuble, bien, etc.).
class SliverImageCarouselAppBar extends StatelessWidget {
  const SliverImageCarouselAppBar({
    super.key,
    required this.imageUrls,
    this.onBack,
    this.backIconColor,
    this.backgroundColor = Colors.white,
    this.expandedHeight = 300,
    this.carouselHeight = 500,
    this.emptyPlaceholder,
  });

  /// Liste des URL d'images à afficher dans le carousel.
  final List<String> imageUrls;

  /// Callback au clic sur le bouton retour (défaut: context.pop()).
  final VoidCallback? onBack;

  /// Couleur de l'icône retour.
  final Color? backIconColor;

  /// Couleur de fond de l'AppBar.
  final Color backgroundColor;

  /// Hauteur développée du SliverAppBar.
  final double expandedHeight;

  /// Hauteur du carousel en arrière-plan.
  final double carouselHeight;

  /// Widget affiché quand [imageUrls] est vide.
  final Widget? emptyPlaceholder;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      snap: false,
      floating: false,
      expandedHeight: expandedHeight,
      backgroundColor: backgroundColor,
      leading: Padding(
        padding: const EdgeInsets.all(10),
        child: IconButton(
          padding: EdgeInsets.zero,
          iconSize: 20,
          onPressed: onBack ?? () => context.pop(),
          style: IconButton.styleFrom(
            fixedSize: const Size(18, 18),
            padding: EdgeInsets.zero,
          ),
          icon: Container(
            width: 30,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Center(
              child: Icon(
                CupertinoIcons.chevron_back,
                color: backIconColor ?? AppColors.primary,
              ),
            ),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: imageUrls.isNotEmpty
            ? FlutterCarousel(
                items: imageUrls
                    .map<Widget>(
                      (url) => Container(
                        foregroundDecoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.grey.shade700,
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0, 0.4],
                          ),
                        ),
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: url,
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
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    )
                    .toList(),
                options: FlutterCarouselOptions(
                  height: carouselHeight,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: imageUrls.length > 1,
                  autoPlay: false,
                  showIndicator: imageUrls.length > 1,
                  indicatorMargin: 20,
                  slideIndicator: CircularSlideIndicator(),
                  floatingIndicator: true,
                ),
              )
            : (emptyPlaceholder ??
                Container(
                  color: Colors.grey.shade200,
                  child: Center(
                    child: Icon(
                      FontAwesomeIcons.image,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                  ),
                )),
      ),
    );
  }
}
