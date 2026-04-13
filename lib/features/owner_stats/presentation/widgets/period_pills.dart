import 'package:flutter/material.dart';
import 'package:immoplus_pro/features/owner_stats/presentation/widgets/stats_colors.dart';

class PeriodPills extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;

  const PeriodPills({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const _periods = [
    {'key': 'month', 'label': 'Mois'},
    {'key': 'quarter', 'label': 'Trimestre'},
    {'key': 'year', 'label': 'Année'},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _periods.map((p) {
        final isActive = selected == p['key'];
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => onChanged(p['key']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
              decoration: BoxDecoration(
                color: isActive ? StatsColors.brand : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive
                      ? StatsColors.brand
                      : StatsColors.brand.withValues(alpha: 0.25),
                  width: 1,
                ),
              ),
              child: Text(
                p['label']!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : StatsColors.brand,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
