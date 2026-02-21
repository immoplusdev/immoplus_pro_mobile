import 'package:flutter/material.dart';
import 'package:immoplus_pro/data/models/furniture/furniture_model.dart';
import 'package:immoplus_pro/data/models/furniture/furniture_status.dart';
import 'package:immoplus_pro/features/furnitures/theme/furniture_theme.dart';
import 'package:immoplus_pro/features/shared_widgets/detail_action_bottom_bar.dart';

/// Barre d'actions en bas de la page détail meuble.
///
/// Délègue à [DetailActionBottomBar] (composant réutilisable meuble / résidence / bien immobilier).
class FurnitureDetailBottomBar extends StatelessWidget {
  const FurnitureDetailBottomBar({
    super.key,
    required this.furniture,
    required this.isUpdatingStatus,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleAvailability,
  });

  final FurnitureModel furniture;
  final bool isUpdatingStatus;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleAvailability;

  @override
  Widget build(BuildContext context) {
    return DetailActionBottomBar(
      isInactive: furniture.status == FurnitureStatus.inactive,
      isUpdatingStatus: isUpdatingStatus,
      onEdit: onEdit,
      onDelete: onDelete,
      onToggleAvailability: onToggleAvailability,
      config: DetailActionBottomBarConfig(
        editLabel: 'Modifier',
        primaryButtonStyle: FurnitureTheme.primaryButtonStyle.copyWith(
          minimumSize: WidgetStateProperty.all(const Size(0, 44)),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
