import 'package:flutter/material.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/creation_style.dart';

/// Bouton blanc à bordure fine et texte bleu, pour les actions secondaires
/// d'un champ (« Voir tous les types », « Ajouter une vidéo », ...).
class OutlinedActionButton extends StatelessWidget {
  const OutlinedActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? leadingIcon;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: CreationStyle.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CreationStyle.fieldRadius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, size: 18),
              AppSpacing.gap8,
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodySmallMedium
                    .copyWith(color: AppColors.primary),
              ),
            ),
            if (trailingIcon != null) ...[
              AppSpacing.gap8,
              Icon(trailingIcon, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}
