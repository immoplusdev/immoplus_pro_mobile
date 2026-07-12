import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/utils/utils.dart';

import '../calendar_date_utils.dart';
import '../calendar_theme.dart';

// ── Residence avatar ─────────────────────────────────────────────────────────

class CalResidenceAvatar extends StatelessWidget {
  const CalResidenceAvatar({
    super.key,
    this.imageId,
    this.selected = false,
    this.size = 28,
  });

  final String? imageId;
  final bool selected;
  final double size;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageId != null && imageId!.trim().isNotEmpty;
    return ClipRRect(
      borderRadius: BorderRadius.circular(size <= 28 ? 14 : 8),
      child: Container(
        width: size,
        height: size,
        color: const Color(0xFFF1F5F9),
        child: hasImage
            ? Image(
                image: CachedNetworkImageProvider(
                  Utils.getImagePath(id: imageId!),
                ),
                fit: BoxFit.cover,
              )
            : Image.asset(
                'assets/img/residence_default.png',
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

// ── Residence selector tile ──────────────────────────────────────────────────

class CalResidenceSelectorTile extends StatelessWidget {
  const CalResidenceSelectorTile({
    super.key,
    required this.residence,
    required this.selected,
    required this.onTap,
    this.locked = false,
    this.danger = false,
  });

  final ResidenceModel residence;
  final bool selected;
  final VoidCallback onTap;
  final bool locked;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final accent = danger ? calDangerColor : calPrimaryColor;
    final soft   = danger ? calDangerSoftColor : calPrimarySoftColor;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: locked ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? soft : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? accent : calLineColor),
        ),
        child: Row(
          children: [
            CalResidenceAvatar(imageId: residence.miniature, selected: selected, size: 36),
            const Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    residence.nom.isEmpty ? 'Résidence' : residence.nom,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: calDmSans(color: calInkColor, fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const Gap(2),
                  Text(
                    residence.commune.isEmpty ? residence.ville : residence.commune,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: calDmSans(color: calMutedColor, fontSize: 11, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const Gap(10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: selected ? accent : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: selected ? accent : calLineColor),
              ),
              child: selected
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Blocked date tile ────────────────────────────────────────────────────────

class CalBlockedDateTile extends StatelessWidget {
  const CalBlockedDateTile({
    super.key,
    required this.date,
    required this.residences,
    required this.onTap,
  });

  final DateTime date;
  final List<ResidenceModel> residences;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: calLineColor),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: calDangerSoftColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Iconsax.lock, color: calDangerColor, size: 18),
            ),
            const Gap(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    calFormatDateLong(date),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: calDmSans(color: calInkColor, fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                  const Gap(2),
                  Text(
                    calCompactNames(residences.map((r) => r.nom).toList()),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: calDmSans(color: const Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const Icon(Iconsax.arrow_right_3, color: calMutedColor, size: 17),
          ],
        ),
      ),
    );
  }
}

// ── Sheet frame ──────────────────────────────────────────────────────────────

class CalSheetFrame extends StatelessWidget {
  const CalSheetFrame({super.key, required this.child, this.topStripeColor});

  final Widget child;
  final Color? topStripeColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (topStripeColor != null)
            Container(width: double.infinity, height: 4, color: topStripeColor),
          child,
        ],
      ),
    );
  }
}

// ── Sheet handle ─────────────────────────────────────────────────────────────

class CalSheetHandle extends StatelessWidget {
  const CalSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 6),
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: calLineColor,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

// ── Sheet header ─────────────────────────────────────────────────────────────

class CalSheetHeader extends StatelessWidget {
  const CalSheetHeader({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onClose,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: calLineColor)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: iconColor),
          const Gap(8),
          Expanded(
            child: Text(
              title,
              style: calDmSans(color: calInkColor, fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: onClose,
            icon: const Icon(Icons.close, color: calMutedColor, size: 20),
          ),
        ],
      ),
    );
  }
}

// ── Sheet label ──────────────────────────────────────────────────────────────

class CalSheetLabel extends StatelessWidget {
  const CalSheetLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: calDmSans(color: calMutedColor, fontSize: 11, fontWeight: FontWeight.w800),
    );
  }
}

// ── Info pill ────────────────────────────────────────────────────────────────

class CalInfoPill extends StatelessWidget {
  const CalInfoPill({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
    required this.backgroundColor,
  });

  final IconData icon;
  final String text;
  final Color color;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const Gap(6),
          Flexible(
            child: Text(
              text,
              style: calDmSans(color: color, fontSize: 13, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Detail line ──────────────────────────────────────────────────────────────

class CalDetailLine extends StatelessWidget {
  const CalDetailLine({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: calMutedColor, size: 18),
          const Gap(10),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: calDmSans(color: const Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: calDmSans(color: calInkColor, fontSize: 13, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sheet button ─────────────────────────────────────────────────────────────

class CalSheetButton extends StatelessWidget {
  const CalSheetButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.filled = false,
    this.danger = false,
    this.height = 48,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool filled;
  final bool danger;
  final double height;

  @override
  Widget build(BuildContext context) {
    final accent = danger ? calDangerColor : calPrimaryColor;

    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: filled ? accent : Colors.white,
          disabledBackgroundColor: filled ? accent.withValues(alpha: 0.4) : Colors.white,
          foregroundColor: filled ? Colors.white : const Color(0xFF64748B),
          disabledForegroundColor:
              filled ? Colors.white.withValues(alpha: 0.9) : const Color(0xFFCBD5E1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: filled ? Colors.transparent : calLineColor),
          ),
          textStyle: calDmSans(fontSize: 14, fontWeight: FontWeight.w800),
        ),
        child: Text(label),
      ),
    );
  }
}

// ── Skeleton box ─────────────────────────────────────────────────────────────

class CalSkeletonBox extends StatelessWidget {
  const CalSkeletonBox({super.key, required this.height, required this.radius});

  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ── Calendar skeleton ────────────────────────────────────────────────────────

class CalendarSkeleton extends StatelessWidget {
  const CalendarSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      children: [
        Row(
          children: List.generate(
            3,
            (i) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i == 2 ? 0 : 8),
                child: const CalSkeletonBox(height: 38, radius: 22),
              ),
            ),
          ),
        ),
        const Gap(16),
        Container(
          padding: const EdgeInsets.all(14),
          color: Colors.white,
          child: Column(
            children: [
              Row(
                children: List.generate(
                  7,
                  (_) => const Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: CalSkeletonBox(height: 12, radius: 6),
                    ),
                  ),
                ),
              ),
              const Gap(12),
              AspectRatio(
                aspectRatio: 7 / 6,
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 42,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  itemBuilder: (_, __) => const CalSkeletonBox(height: 40, radius: 8),
                ),
              ),
            ],
          ),
        ),
        const Gap(22),
        const CalSkeletonBox(height: 62, radius: 12),
        const Gap(10),
        const CalSkeletonBox(height: 62, radius: 12),
      ],
    );
  }
}

// ── Calendar message state ───────────────────────────────────────────────────

class CalendarMessageState extends StatelessWidget {
  const CalendarMessageState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: const BoxDecoration(
                color: calPrimarySoftColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: calPrimaryColor, size: 28),
            ),
            const Gap(14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: calDmSans(color: calInkColor, fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const Gap(6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: calDmSans(
                color: const Color(0xFF64748B),
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.35,
              ),
            ),
            const Gap(18),
            SizedBox(
              height: 44,
              child: ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: calPrimaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: calDmSans(fontSize: 13, fontWeight: FontWeight.w800),
                ),
                child: Text(actionLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
