import 'package:flutter/material.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/residence_creation/models/catalog.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/catalog_icon_view.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/selectable_surface.dart';

/// Tuile carrée « icône au-dessus du libellé », utilisée pour les types de
/// logement et les équipements.
class CatalogIconTile extends StatelessWidget {
  const CatalogIconTile({
    super.key,
    required this.item,
    required this.selected,
    required this.onTap,
    this.mutedWhenUnselected = false,
  });

  final CatalogItem item;
  final bool selected;
  final VoidCallback onTap;

  /// Grise l'icône tant que la tuile n'est pas sélectionnée (types de
  /// logement). Sinon elle garde ses couleurs (équipements).
  final bool mutedWhenUnselected;

  @override
  Widget build(BuildContext context) {
    final muted = mutedWhenUnselected && !selected;
    return SelectableSurface(
      selected: selected,
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.xs),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CatalogIconView(
            item: item,
            tone: muted ? CatalogIconTone.muted : CatalogIconTone.brand,
          ),
          AppSpacing.gap8,
          Text(
            item.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.captionSemiBold.copyWith(
              color: selected ? AppColors.primary : AppColors.gray950,
            ),
          ),
        ],
      ),
    );
  }
}
