import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:immoplus_pro/features/owner_stats/data/models/owner_stats_dto.dart';
import 'package:immoplus_pro/features/owner_stats/presentation/widgets/stats_colors.dart';

class ReservationsDonutChart extends StatelessWidget {
  final ReservationsDto reservations;

  const ReservationsDonutChart({super.key, required this.reservations});

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
            'Réservations',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: StatsColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Donut chart
              SizedBox(
                width: 88,
                height: 88,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        centerSpaceRadius: 32,
                        sectionsSpace: 2,
                        startDegreeOffset: -90,
                        sections: [
                          PieChartSectionData(
                            value: reservations.confirmed.toDouble(),
                            color: StatsColors.brand,
                            showTitle: false,
                            radius: 14,
                          ),
                          PieChartSectionData(
                            value: reservations.pending.toDouble(),
                            color: StatsColors.brandLight,
                            showTitle: false,
                            radius: 14,
                          ),
                          PieChartSectionData(
                            value: reservations.cancelled.toDouble(),
                            color: StatsColors.brandPale,
                            showTitle: false,
                            radius: 14,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${reservations.total}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: StatsColors.textPrimary,
                          ),
                        ),
                        const Text(
                          'total',
                          style: TextStyle(
                            fontSize: 8,
                            color: StatsColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // Legend
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legendRow(
                      StatsColors.brand,
                      'Confirmées',
                      reservations.confirmed,
                    ),
                    const SizedBox(height: 10),
                    _legendRow(
                      StatsColors.brandLight,
                      'En attente',
                      reservations.pending,
                    ),
                    const SizedBox(height: 10),
                    _legendRow(
                      StatsColors.brandPale,
                      'Annulées',
                      reservations.cancelled,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendRow(Color color, String label, int value) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: StatsColors.textSecondary,
            ),
          ),
        ),
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: StatsColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
