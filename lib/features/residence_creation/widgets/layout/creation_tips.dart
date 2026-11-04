import 'package:flutter/material.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';

/// Conseils « Immo Plus » d'une étape : un encart informatif par conseil, dans
/// l'ordre de l'API. N'affiche rien s'il n'y en a pas.
class CreationTips extends StatelessWidget {
  const CreationTips({super.key, required this.tips});

  final List<CreationTip> tips;

  @override
  Widget build(BuildContext context) {
    if (tips.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final tip in tips) ...[
          _TipCard(tip: tip),
          AppSpacing.gap12,
        ],
        AppSpacing.gap12,
      ],
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({required this.tip});

  final CreationTip tip;

  /// Couleur d'accent (titre) et fond teinté de la même couleur.
  Color get _accent => switch (tip.variant) {
        TipVariant.info => AppColors.primary,
        TipVariant.success => AppColors.green500,
        TipVariant.warning => AppColors.amber800,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: _accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadii.r20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (tip.title.isNotEmpty)
            Text(tip.title,
                style:
                    AppTypography.bodyLargeSemiBold.copyWith(color: _accent)),
          if (tip.title.isNotEmpty && tip.text.isNotEmpty) AppSpacing.gap8,
          if (tip.text.isNotEmpty)
            Text(tip.text,
                style: AppTypography.bodyMedium
                    .copyWith(color: AppColors.gray400)),
        ],
      ),
    );
  }
}
