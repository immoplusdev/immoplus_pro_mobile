import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:immoplus_pro/features/owner_stats/data/models/owner_stats_dto.dart';
import 'package:immoplus_pro/features/owner_stats/presentation/widgets/stats_colors.dart';
import 'package:intl/intl.dart';

class RevenueLineChart extends StatelessWidget {
  final List<RevenueChartDto> data;

  const RevenueLineChart({super.key, required this.data});

  List<String> get _monthLabels {
    return data.map((e) {
      try {
        final date = DateTime.parse('${e.month}-01');
        return DateFormat('MMM', 'fr_FR').format(date);
      } catch (_) {
        return e.month;
      }
    }).toList();
  }

  double get _maxY {
    double max = 0;
    for (final d in data) {
      if (d.reservations > max) max = d.reservations.toDouble();
      if (d.visits > max) max = d.visits.toDouble();
    }
    if (max == 0) return 100;
    return max * 1.15;
  }

  @override
  Widget build(BuildContext context) {
    final labels = _monthLabels;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Évolution des revenus',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: StatsColors.textPrimary,
                ),
              ),
              Text(
                '${data.length} mois',
                style: const TextStyle(
                  fontSize: 11,
                  color: StatsColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 110,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: _maxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: _maxY / 4,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: StatsColors.borderLight.withValues(alpha: 0.3),
                    strokeWidth: 0.5,
                    dashArray: [2, 3],
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= labels.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            labels[idx],
                            style: const TextStyle(
                              fontSize: 9,
                              color: StatsColors.textSecondary,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final format = NumberFormat('#,###', 'fr_FR');
                        return LineTooltipItem(
                          '${format.format(spot.y.toInt())} XAF',
                          TextStyle(
                            color: spot.bar.color ?? Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  // Reservations line
                  LineChartBarData(
                    spots: List.generate(
                      data.length,
                      (i) => FlSpot(i.toDouble(), data[i].reservations.toDouble()),
                    ),
                    color: StatsColors.brand,
                    barWidth: 2.2,
                    isCurved: false,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, bar, index) =>
                          FlDotCirclePainter(
                        radius: 2.5,
                        color: StatsColors.brand,
                        strokeWidth: 0,
                      ),
                    ),
                    belowBarData: BarAreaData(show: false),
                  ),
                  // Visits line (dashed)
                  LineChartBarData(
                    spots: List.generate(
                      data.length,
                      (i) => FlSpot(i.toDouble(), data[i].visits.toDouble()),
                    ),
                    color: StatsColors.brandLight,
                    barWidth: 2,
                    isCurved: false,
                    dashArray: [4, 3],
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 300),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _legendItem(StatsColors.brand, 'Réservations'),
              const SizedBox(width: 16),
              _legendItem(StatsColors.brandLight, 'Visites'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: StatsColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
