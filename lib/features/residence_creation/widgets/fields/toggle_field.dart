import 'package:flutter/material.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/creation_style.dart';

/// Champ `switch` : libellé à gauche, interrupteur à droite.
class ToggleField extends StatelessWidget {
  const ToggleField({
    super.key,
    required this.field,
    required this.value,
    required this.onChanged,
  });

  final CreationField field;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  field.label ?? '',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.gray950),
                ),
              ),
              Switch.adaptive(
                value: value,
                activeTrackColor: AppColors.primary,
                inactiveTrackColor: AppColors.graySys5,
                inactiveThumbColor: Colors.white,
                trackOutlineColor: WidgetStatePropertyAll(
                    CreationStyle.border.withValues(alpha: 0)),
                onChanged: onChanged,
              ),
            ],
          ),
          if (field.helperText != null)
            Text(
              field.helperText!,
              style: AppTypography.caption.copyWith(color: AppColors.gray400),
            ),
        ],
      ),
    );
  }
}
