import 'package:flutter/material.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/creation_style.dart';

enum PillButtonVariant { primary, secondary }

/// Bouton plein et arrondi des écrans de création.
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = PillButtonVariant.primary,
    this.isLoading = false,
  });

  static const double height = 48;

  final String label;
  final VoidCallback? onPressed;
  final PillButtonVariant variant;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isPrimary = variant == PillButtonVariant.primary;
    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: isPrimary ? AppColors.primary : AppColors.graySys5,
          disabledBackgroundColor: isPrimary
              ? AppColors.primary.withValues(alpha: 0.6)
              : AppColors.graySys5,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CreationStyle.pillRadius),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(label,
                style: AppTypography.button.copyWith(color: Colors.white)),
      ),
    );
  }
}
