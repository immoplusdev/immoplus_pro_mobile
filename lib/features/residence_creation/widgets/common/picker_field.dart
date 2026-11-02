import 'package:flutter/material.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/creation_style.dart';

/// Champ qui ouvre un sélecteur (ville, commune, carte) : icône, valeur ou
/// texte d'invite, chevron.
class PickerField extends StatelessWidget {
  const PickerField({
    super.key,
    required this.icon,
    required this.placeholder,
    required this.onTap,
    this.value,
    this.hasError = false,
  });

  final IconData icon;
  final String placeholder;
  final String? value;
  final VoidCallback onTap;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(CreationStyle.fieldRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: CreationStyle.inputFill,
          borderRadius: BorderRadius.circular(CreationStyle.fieldRadius),
          border: Border.all(
            color: hasError ? AppColors.red500 : CreationStyle.border,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            AppSpacing.gap12,
            Expanded(
              child: Text(
                value ?? placeholder,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodyMedium.copyWith(
                  color: value == null ? AppColors.gray400 : AppColors.gray950,
                ),
              ),
            ),
            Icon(Icons.chevron_right, size: 20, color: AppColors.gray400),
          ],
        ),
      ),
    );
  }
}
