import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';

import '../calendar_theme.dart';
import 'calendar_ui_widgets.dart';

/// Horizontal scrollable list of residence filter chips.
class ResidenceStrip extends StatelessWidget {
  const ResidenceStrip({
    super.key,
    required this.residences,
    required this.activeResidence,
    required this.onSelect,
  });

  final List<ResidenceModel> residences;
  final ResidenceModel? activeResidence;
  final ValueChanged<ResidenceModel?> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: residences.length + 1,
        separatorBuilder: (_, __) => const Gap(8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _ResidenceFilterChip(
              label: 'Toutes',
              selected: activeResidence == null,
              onTap: () => onSelect(null),
            );
          }
          final residence = residences[index - 1];
          return _ResidenceFilterChip(
            label: residence.nom.isEmpty ? 'Résidence' : residence.nom,
            selected: activeResidence?.id == residence.id,
            imageId: residence.miniature,
            onTap: () => onSelect(residence),
          );
        },
      ),
    );
  }
}

class _ResidenceFilterChip extends StatelessWidget {
  const _ResidenceFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.imageId,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? imageId;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        constraints: const BoxConstraints(maxWidth: 210),
        padding: const EdgeInsets.fromLTRB(8, 6, 12, 6),
        decoration: BoxDecoration(
          color: selected ? calPrimaryColor : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? calPrimaryColor : calLineColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CalResidenceAvatar(imageId: imageId, selected: selected),
            const Gap(7),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: calDmSans(
                  color: selected ? Colors.white : const Color(0xFF475569),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
