import 'package:flutter/material.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/layout/segmented_progress_bar.dart';

/// En-tête du formulaire : retour, titre, compteur d'étapes et progression.
class CreationHeader extends StatelessWidget {
  const CreationHeader({
    super.key,
    required this.title,
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
  });

  final String title;
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 48,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.chevron_left, size: 28),
                ),
              ),
              Text(title, style: AppTypography.h4),
              Align(
                alignment: Alignment.centerRight,
                child:
                    _StepCounter(current: currentStep + 1, total: totalSteps),
              ),
            ],
          ),
        ),
        AppSpacing.gap12,
        SegmentedProgressBar(currentStep: currentStep, totalSteps: totalSteps),
      ],
    );
  }
}

class _StepCounter extends StatelessWidget {
  const _StepCounter({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.blue40,
        borderRadius: BorderRadius.circular(AppRadii.rFull),
      ),
      child: Text(
        '$current/$total',
        style: AppTypography.captionSemiBold.copyWith(color: AppColors.primary),
      ),
    );
  }
}
