import 'package:flutter/material.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/creation_style.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/counter_stepper.dart';

/// Une ligne de compteur : libellé à gauche, stepper à droite.
class CounterRowData {
  const CounterRowData({
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max,
  });

  final String label;
  final int value;
  final int min;
  final int? max;
  final ValueChanged<int> onChanged;
}

/// Carte blanche regroupant plusieurs compteurs séparés par des filets.
class CounterGroupCard extends StatelessWidget {
  const CounterGroupCard({super.key, required this.rows});

  final List<CounterRowData> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(CreationStyle.tileRadius),
        border: Border.all(color: CreationStyle.border),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(height: 1, color: CreationStyle.border),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: Text(rows[i].label,
                        style: AppTypography.bodyMedium
                            .copyWith(color: AppColors.gray950)),
                  ),
                  CounterStepper(
                    value: rows[i].value,
                    min: rows[i].min,
                    max: rows[i].max,
                    onChanged: rows[i].onChanged,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
