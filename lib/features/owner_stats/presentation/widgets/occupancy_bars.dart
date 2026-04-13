import 'package:flutter/material.dart';
import 'package:immoplus_pro/features/owner_stats/data/models/owner_stats_dto.dart';
import 'package:immoplus_pro/features/owner_stats/presentation/widgets/stats_colors.dart';

class OccupancyBars extends StatelessWidget {
  final OccupancyDto occupancy;

  const OccupancyBars({super.key, required this.occupancy});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: StatsColors.brand.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Taux d'occupation",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: StatsColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _bar(
            label: 'Ce mois',
            percent: occupancy.currentPeriod,
            color: StatsColors.brand,
          ),
          const SizedBox(height: 12),
          _bar(
            label: 'Mois dernier',
            percent: occupancy.previousPeriod,
            color: StatsColors.brandLight,
          ),
        ],
      ),
    );
  }

  Widget _bar({
    required String label,
    required double percent,
    required Color color,
  }) {
    final clamped = percent.clamp(0, 100).toDouble();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: StatsColors.textSecondary,
              ),
            ),
            Text(
              '${clamped.toStringAsFixed(0)}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: StatsColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(4),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Align(
                alignment: Alignment.centerLeft,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: constraints.maxWidth * (clamped / 100),
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
