import 'package:flutter/material.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';

/// Barre de progression en segments : un segment par étape, remplis jusqu'à
/// l'étape courante incluse.
class SegmentedProgressBar extends StatelessWidget {
  const SegmentedProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  static const double _height = 4;

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < totalSteps; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: _height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadii.rFull),
                color:
                    i <= currentStep ? AppColors.primary : AppColors.graySys5,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
