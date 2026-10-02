import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/utils/utils.dart';

abstract class _Constants {
  static const double cardBorderRadius = 14.0;
  static const double commentBorderRadius = 8.0;
  static const double borderWidth = 1.0;

  static const EdgeInsets cardPadding = EdgeInsets.all(14.0);
  static const EdgeInsets commentPadding =
      EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0);
  static const EdgeInsets badgePadding =
      EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0);

  static const Color cardBackgroundColor = Color(0xFFFFF7F7);
  static const Color cardBorderColor = Color(0xFFFFE2E2);
  static const Color badgeBgColor = Color(0xFFFEE2E2);
  static const Color badgeTextColor = Color(0xFFDC2626);
  static const Color commentBgColor = Color(0xFFFFFFFF);
  static const Color commentBorderColor = Color(0xFFFEE2E2);

  static const Color titleColor = Color(0xFF1E293B);
  static const Color commentColor = Color(0xFF64748B);
  static const Color dateColor = Color(0xFF94A3B8);

  static const String defaultRefusalTitle = 'Réservation refusée';

  static const TextStyle badgeTextStyle = TextStyle(
    fontSize: 11.0,
    fontWeight: FontWeight.w700,
    color: badgeTextColor,
  );

  static const TextStyle labelTextStyle = TextStyle(
    fontSize: 13.5,
    fontWeight: FontWeight.w600,
    color: titleColor,
    height: 1.35,
  );

  static const TextStyle commentTextStyle = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    color: commentColor,
    height: 1.3,
  );

  static const TextStyle dateTextStyle = TextStyle(
    fontSize: 11.5,
    fontWeight: FontWeight.w500,
    color: dateColor,
  );
}

class RefusalReasonRecapCard extends StatelessWidget {
  final String reasonLabel;
  final String? comment;
  final DateTime respondedAt;

  const RefusalReasonRecapCard({
    super.key,
    required this.reasonLabel,
    this.comment,
    required this.respondedAt,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = Utils.formatCancelDate(dateTime: respondedAt);
    final trimmedComment = comment?.trim();
    final hasComment = trimmedComment != null && trimmedComment.isNotEmpty;

    return Container(
      padding: _Constants.cardPadding,
      decoration: BoxDecoration(
        color: _Constants.cardBackgroundColor,
        borderRadius: BorderRadius.circular(_Constants.cardBorderRadius),
        border: Border.all(
          color: _Constants.cardBorderColor,
          width: _Constants.borderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: _Constants.badgePadding,
                decoration: BoxDecoration(
                  color: _Constants.badgeBgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Iconsax.close_circle,
                      size: 13,
                      color: _Constants.badgeTextColor,
                    ),
                    Gap(4),
                    Text(
                      _Constants.defaultRefusalTitle,
                      style: _Constants.badgeTextStyle,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                formattedDate,
                style: _Constants.dateTextStyle,
              ),
            ],
          ),
          const Gap(10),
          Text(
            reasonLabel.endsWith('.') ? reasonLabel : '$reasonLabel.',
            style: _Constants.labelTextStyle,
          ),
          if (hasComment) ...[
            const Gap(8),
            Container(
              width: double.infinity,
              padding: _Constants.commentPadding,
              decoration: BoxDecoration(
                color: _Constants.commentBgColor,
                borderRadius:
                    BorderRadius.circular(_Constants.commentBorderRadius),
                border: Border.all(
                  color: _Constants.commentBorderColor,
                  width: 1.0,
                ),
              ),
              child: Text(
                '« $trimmedComment »',
                style: _Constants.commentTextStyle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
