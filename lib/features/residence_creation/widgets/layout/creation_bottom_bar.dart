import 'package:flutter/material.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/pill_button.dart';

/// Barre d'actions : « Précédent » + « Continuer », ou le seul bouton de
/// création sur la dernière étape.
class CreationBottomBar extends StatelessWidget {
  const CreationBottomBar({
    super.key,
    required this.isFirstStep,
    required this.isLastStep,
    required this.isSubmitting,
    required this.onPrevious,
    required this.onNext,
    this.lastStepLabel = 'Créer ma résidence',
  });

  final bool isFirstStep;
  final bool isLastStep;
  final bool isSubmitting;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final String lastStepLabel;

  @override
  Widget build(BuildContext context) {
    final showPrevious = !isFirstStep && !isLastStep;

    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.md),
          child: Row(
            children: [
              if (showPrevious) ...[
                Expanded(
                  child: PillButton(
                    label: 'Précédent',
                    variant: PillButtonVariant.secondary,
                    onPressed: onPrevious,
                  ),
                ),
                AppSpacing.gap12,
              ],
              Expanded(
                flex: showPrevious ? 2 : 1,
                child: PillButton(
                  label: isLastStep ? lastStepLabel : 'Continuer',
                  isLoading: isSubmitting,
                  onPressed: onNext,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
