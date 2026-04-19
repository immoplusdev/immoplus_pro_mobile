import 'package:flutter/material.dart';
import 'package:immoplus_pro/features/owner_stats/presentation/widgets/stats_colors.dart';

class KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final Color? subtitleColor;
  final IconData icon;
  final Color accentColor;
  final Color bgTint;

  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    required this.subtitle,
    this.subtitleColor,
    required this.icon,
    required this.accentColor,
    required this.bgTint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: StatsColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: bgTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: accentColor),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: StatsColors.textPrimary,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: subtitleColor ?? StatsColors.textSecondary,
              fontWeight:
                  subtitleColor != null ? FontWeight.w600 : FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
