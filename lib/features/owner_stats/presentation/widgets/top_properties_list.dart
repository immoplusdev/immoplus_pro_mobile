import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus_pro/features/owner_stats/data/models/owner_stats_dto.dart';
import 'package:immoplus_pro/features/owner_stats/presentation/widgets/stats_colors.dart';

class TopPropertiesList extends StatelessWidget {
  final List<TopPropertyDto> properties;

  const TopPropertiesList({super.key, required this.properties});

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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top biens',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: StatsColors.textPrimary,
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     // TODO: Navigate to /owner/properties/top
              //   },
              //   child: const Text(
              //     'Voir tout ›',
              //     style: TextStyle(
              //       fontSize: 12,
              //       fontWeight: FontWeight.w500,
              //       color: StatsColors.brand,
              //     ),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 14),
          ...List.generate(properties.length, (index) {
            final prop = properties[index];
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < properties.length - 1 ? 12 : 0,
              ),
              child: Row(
                children: [
                  // Property icon
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: StatsColors.brandIce,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      CupertinoIcons.house_fill,
                      color: StatsColors.brand,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Name + stats
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prop.nom,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: StatsColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '\u{1F441} ${prop.views} \u00B7 \u2764 ${prop.likes}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: StatsColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Rank
                  Text(
                    '#${index + 1}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: StatsColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
