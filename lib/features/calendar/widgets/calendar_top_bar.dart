import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';

import '../calendar_theme.dart';
import '../calendar_date_utils.dart';

/// Top bar of the calendar page: month title + previous/next navigation.
class CalendarTopBar extends StatelessWidget {
  const CalendarTopBar({
    super.key,
    required this.visibleMonth,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime visibleMonth;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: calLineColor, width: 1)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _NavButton(icon: Iconsax.arrow_left_2, onTap: onPrevious),
          const Gap(10),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SizeTransition(
                sizeFactor: animation,
                axis: Axis.horizontal,
                child: child,
              ),
            ),
            child: Text(
              calMonthTitle(visibleMonth),
              key: ValueKey(visibleMonth.toIso8601String()),
              style: calDmSans(
                color: calInkColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Gap(10),
          _NavButton(icon: Iconsax.arrow_right_3, onTap: onNext),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: SizedBox(
        width: 34,
        height: 30,
        child: Icon(icon, color: calInkColor, size: 18),
      ),
    );
  }
}
