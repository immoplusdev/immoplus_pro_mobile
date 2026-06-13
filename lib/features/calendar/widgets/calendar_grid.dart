import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:showcaseview/showcaseview.dart';

import '../calendar_date_utils.dart';
import '../calendar_theme.dart';

/// Calendar grid with gesture detection (tap + pan range selection).
///
/// The parent is responsible for computing [visibleDays], [selectedRange],
/// and [blockedResidencesFor].
class CalendarGrid extends StatelessWidget {
  const CalendarGrid({
    super.key,
    required this.visibleDays,
    required this.visibleMonth,
    required this.selectedRange,
    required this.today,
    required this.firstValidDay,
    required this.tutorialKey1,
    required this.tutorialKey2,
    required this.blockedResidencesFor,
    required this.onDayTap,
    required this.onPanStart,
    required this.onPanUpdate,
    required this.onPanEnd,
  });

  final List<DateTime> visibleDays;
  final DateTime visibleMonth;
  final List<DateTime> selectedRange;
  final DateTime today;
  final DateTime firstValidDay;
  final GlobalKey tutorialKey1;
  final GlobalKey tutorialKey2;
  final List<ResidenceModel> Function(DateTime) blockedResidencesFor;
  final void Function(DateTime) onDayTap;
  final void Function(DateTime) onPanStart;
  final void Function(DateTime) onPanUpdate;
  final VoidCallback onPanEnd;

  // ── Helpers ───────────────────────────────────────────────────────────────

  bool _isSelected(DateTime day) {
    final key = calFormatApiDate(day);
    return selectedRange.map(calFormatApiDate).contains(key);
  }

  bool _isRangeStart(DateTime day) {
    if (selectedRange.isEmpty) return false;
    return calIsSameDay(selectedRange.first, day);
  }

  bool _isRangeEnd(DateTime day) {
    if (selectedRange.isEmpty) return false;
    return calIsSameDay(selectedRange.last, day);
  }

  DateTime? _dayFromPosition(Offset position, Size size) {
    if (position.dx < 0 ||
        position.dy < 0 ||
        position.dx > size.width ||
        position.dy > size.height) return null;

    final colW = size.width / 7;
    final rowH = size.height / 6;
    final col  = (position.dx / colW).floor().clamp(0, 6);
    final row  = (position.dy / rowH).floor().clamp(0, 5);
    return visibleDays[row * 7 + col];
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: calLineColor, width: 1)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        children: [
          // Day-of-week labels
          Row(
            children: calDayLabels
                .map(
                  (label) => Expanded(
                    child: Center(
                      child: Text(
                        label,
                        style: calDmSans(
                          color: calMutedColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const Gap(8),
          // Grid
          AspectRatio(
            aspectRatio: 7 / 6,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = Size(constraints.maxWidth, constraints.maxHeight);
                return Stack(
                  children: [
                    _buildGrid(size),
                    _buildTutorialOverlay(size),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(Size size) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (d) {
        final day = _dayFromPosition(d.localPosition, size);
        if (day != null && !calIsBeforeToday(day)) onPanStart(day);
      },
      onPanUpdate: (d) {
        final day = _dayFromPosition(d.localPosition, size);
        if (day != null && !calIsBeforeToday(day)) onPanUpdate(day);
      },
      onPanEnd: (_) => onPanEnd(),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: visibleDays.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemBuilder: (context, index) {
          final day = visibleDays[index];
          return _CalendarDayCell(
            day: day,
            today: today,
            visibleMonth: visibleMonth,
            selectedRange: selectedRange,
            isSelected: _isSelected(day),
            isRangeStart: _isRangeStart(day),
            isRangeEnd: _isRangeEnd(day),
            blockedResidences: blockedResidencesFor(day),
            isFirstValidDay: calIsSameDay(day, firstValidDay),
            tutorialKey1: tutorialKey1,
            onTap: () => onDayTap(day),
          );
        },
      ),
    );
  }

  Widget _buildTutorialOverlay(Size size) {
    const crossAxisCount = 7;
    const crossAxisSpacing = 4.0;
    const mainAxisSpacing = 4.0;

    final rowCount = (visibleDays.length / crossAxisCount).ceil();
    final cellWidth = (size.width - (crossAxisCount - 1) * crossAxisSpacing) / crossAxisCount;
    final cellHeight = (size.height - (rowCount - 1) * mainAxisSpacing) / rowCount;

    int rangeStart = visibleDays.indexWhere(
      (d) => !calIsBeforeToday(d) && blockedResidencesFor(d).isEmpty,
    );
    if (rangeStart == -1) rangeStart = 0;
    rangeStart += 1;
    if (rangeStart % crossAxisCount > 4) {
      rangeStart += crossAxisCount - (rangeStart % crossAxisCount);
    }
    if (rangeStart + 2 >= visibleDays.length) {
      rangeStart = visibleDays.length - 3;
      if (rangeStart < 0) rangeStart = 0;
    }

    final r     = rangeStart ~/ crossAxisCount;
    final c     = rangeStart % crossAxisCount;
    final top   = r * (cellHeight + mainAxisSpacing);
    final left  = c * (cellWidth + crossAxisSpacing);
    final width = cellWidth * 3 + crossAxisSpacing * 2;

    return Positioned(
      top: top,
      left: left,
      width: width,
      height: cellHeight,
      child: Showcase(
        key: tutorialKey2,
        description: 'Maintenez et glissez votre doigt sur plusieurs dates pour sélectionner une période.',
        tooltipBackgroundColor: Colors.white,
        textColor: calInkColor,
        descTextStyle: calDmSans(color: calInkColor, fontWeight: FontWeight.w600),
        targetBorderRadius: BorderRadius.circular(8),
        child: const SizedBox.expand(),
      ),
    );
  }
}

// ── Day cell ──────────────────────────────────────────────────────────────────

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.day,
    required this.today,
    required this.visibleMonth,
    required this.selectedRange,
    required this.isSelected,
    required this.isRangeStart,
    required this.isRangeEnd,
    required this.blockedResidences,
    required this.isFirstValidDay,
    required this.tutorialKey1,
    required this.onTap,
  });

  final DateTime day;
  final DateTime today;
  final DateTime visibleMonth;
  final List<DateTime> selectedRange;
  final bool isSelected;
  final bool isRangeStart;
  final bool isRangeEnd;
  final List<ResidenceModel> blockedResidences;
  final bool isFirstValidDay;
  final GlobalKey tutorialKey1;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isOutMonth = !calIsSameMonth(day, visibleMonth);
    final isToday = calIsSameDay(day, today);
    final isPast  = calIsBeforeToday(day);
    final isBlocked = blockedResidences.isNotEmpty;
    final isSingleSelection = selectedRange.length == 1 && isSelected;
    final isRangeMiddle = isSelected && !isSingleSelection && !isRangeStart && !isRangeEnd;

    Color background   = Colors.transparent;
    Color textColor    = isOutMonth ? const Color(0xFFCBD5E1) : calInkColor;
    FontWeight weight  = FontWeight.w600;
    BorderRadius radius = BorderRadius.circular(8);

    if (isBlocked && !isSelected) {
      background = calDangerSoftColor;
      textColor  = calDangerColor;
    }
    if (isRangeMiddle) {
      background = calPrimarySoftColor;
      textColor  = const Color(0xFF1A30A8);
      radius     = BorderRadius.zero;
    }
    if (isRangeStart && !isSingleSelection) {
      background = calPrimaryColor;
      textColor  = Colors.white;
      radius     = const BorderRadius.horizontal(left: Radius.circular(8));
    }
    if (isRangeEnd && !isSingleSelection) {
      background = calPrimaryColor;
      textColor  = Colors.white;
      radius     = const BorderRadius.horizontal(right: Radius.circular(8));
    }
    if (isSingleSelection) {
      background = calPrimarySoftColor;
      textColor  = calPrimaryColor;
      radius     = BorderRadius.circular(8);
    }
    if (isToday && !isSelected && !isBlocked) {
      textColor = calPrimaryColor;
      weight    = FontWeight.w800;
    }
    if (isPast && !isBlocked && !isSelected) {
      textColor = const Color(0xFFCBD5E1);
      weight    = FontWeight.w500;
    }

    final cell = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(color: background, borderRadius: radius),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: calDmSans(color: textColor, fontSize: 13, fontWeight: weight),
            ),
            const Gap(4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width:  (isBlocked || (isToday && !isSelected)) ? 5 : 0,
              height: (isBlocked || (isToday && !isSelected)) ? 5 : 0,
              decoration: BoxDecoration(
                color: isBlocked ? calDangerColor : calPrimaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );

    if (isFirstValidDay) {
      return Showcase(
        key: tutorialKey1,
        description: '💡 Astuce : Touchez une date pour la bloquer.',
        tooltipBackgroundColor: Colors.white,
        textColor: calInkColor,
        descTextStyle: calDmSans(color: calInkColor, fontWeight: FontWeight.w600),
        targetBorderRadius: BorderRadius.circular(8),
        child: cell,
      );
    }
    return cell;
  }
}
