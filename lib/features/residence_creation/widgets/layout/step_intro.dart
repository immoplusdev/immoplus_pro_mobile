import 'package:flutter/material.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';

/// Pastille « Étape 05 · Réservations », titre et sous-titre d'une étape.
class StepIntro extends StatelessWidget {
  const StepIntro({
    super.key,
    required this.stepNumber,
    required this.stepLabel,
    required this.title,
    this.subtitle,
  });

  final int stepNumber;
  final String stepLabel;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.blue40,
            borderRadius: BorderRadius.circular(AppRadii.rFull),
          ),
          child: Text(
            'Étape ${stepNumber.toString().padLeft(2, '0')} · $stepLabel',
            style: AppTypography.captionSemiBold
                .copyWith(color: AppColors.primary),
          ),
        ),
        AppSpacing.gap12,
        Text(title, style: AppTypography.h2.copyWith(color: AppColors.gray950)),
        if (subtitle != null) ...[
          AppSpacing.gap8,
          Text(
            subtitle!,
            style: AppTypography.bodyLarge.copyWith(color: AppColors.gray400),
          ),
        ],
      ],
    );
  }
}
