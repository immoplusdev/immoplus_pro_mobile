import 'package:flutter/material.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';

class CreationStepperV2 extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const CreationStepperV2({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalSteps * 2 - 1,
        (index) {
          final isDot = index % 2 == 0;
          final stepIndex = index ~/ 2;

          if (isDot) {
            final isCompleted = stepIndex <= currentStep;
            return Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted ? AppColors.primary : Colors.white,
                border: Border.all(
                  color: isCompleted ? AppColors.primary : Colors.grey.shade400,
                  width: 1.5,
                ),
              ),
            );
          } else {
            final isCompleted = stepIndex < currentStep;
            return Container(
              width: 30, // longueur de la ligne
              height: 1.5,
              color: isCompleted ? AppColors.primary : Colors.grey.shade300,
            );
          }
        },
      ),
    );
  }
}
