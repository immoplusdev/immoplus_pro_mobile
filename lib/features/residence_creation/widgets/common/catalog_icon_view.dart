import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/residence_creation/models/catalog.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/catalog_icons.dart';

/// Rendu de l'icône d'un élément de catalogue.
enum CatalogIconTone {
  /// Couleurs d'origine du SVG (bleu de la marque).
  brand,

  /// Version grisée, pour un élément non sélectionné.
  muted,
}

class CatalogIconView extends StatelessWidget {
  const CatalogIconView({
    super.key,
    required this.item,
    this.tone = CatalogIconTone.brand,
    this.size = 32,
  });

  final CatalogItem item;
  final CatalogIconTone tone;
  final double size;

  /// Désature le SVG en gardant ses deux tons, sans l'aplatir en une couleur.
  static const ColorFilter _grayscale = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0, //
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0, 0, 0, 1, 0,
  ]);

  @override
  Widget build(BuildContext context) {
    final asset = CatalogIcons.svgAsset(item.code);
    final isMuted = tone == CatalogIconTone.muted;

    if (asset == null) {
      return Icon(
        CatalogIcons.fallback(item.icon),
        size: size,
        color: isMuted ? AppColors.gray950 : AppColors.primary,
      );
    }

    // Les SVG sans couleur propre sont teintés ; les autres gardent leurs tons.
    final tint = isMuted ? AppColors.gray950 : AppColors.primary;
    return SvgPicture.asset(
      asset,
      height: size,
      width: size,
      fit: BoxFit.contain,
      colorFilter: CatalogIcons.needsTint(item.code)
          ? ColorFilter.mode(tint, BlendMode.srcIn)
          : (isMuted ? _grayscale : null),
    );
  }
}
