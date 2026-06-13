import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';

import '../calendar_date_utils.dart';
import '../calendar_theme.dart';
import 'calendar_ui_widgets.dart';

/// Section displaying the list of blocked dates for the current visible month.
class BlockedDateSection extends StatelessWidget {
  const BlockedDateSection({
    super.key,
    required this.entries,
    required this.visibleMonth,
    required this.onTap,
  });

  /// Sorted map entries: key = 'yyyy-MM-dd', value = residences blocked on that date.
  final List<MapEntry<String, List<ResidenceModel>>> entries;
  final DateTime visibleMonth;
  final void Function(DateTime day, List<ResidenceModel> residences) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Dates bloquées ce mois',
                style: calDmSans(
                  color: calInkColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                '${entries.length}',
                style: calDmSans(
                  color: calMutedColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Gap(10),
          if (entries.isEmpty)
            _EmptyState()
          else ...[
            ...entries.take(6).map(
              (entry) {
                final day = calParseApiDate(entry.key) ?? visibleMonth;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: CalBlockedDateTile(
                    date: day,
                    residences: entry.value,
                    onTap: () => onTap(day, entry.value),
                  ),
                );
              },
            ),
            if (entries.length > 6)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  '+ ${entries.length - 6} autres dates sur le calendrier',
                  style: calDmSans(
                    color: calMutedColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: calLineColor),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: calPrimarySoftColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Iconsax.calendar_tick, color: calPrimaryColor, size: 18),
          ),
          const Gap(10),
          Expanded(
            child: Text(
              'Aucune résidence marquée indisponible',
              style: calDmSans(
                color: const Color(0xFF64748B),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
