import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/data/models/banners/banner_model.dart';
import 'package:immoplus_pro/features/home_v2/widgets/banner_button.dart';

enum BannerAction {
  unknown('');

  final String url;
  const BannerAction(this.url);

  static BannerAction fromUrl(String? url) {
    if (url == null) return BannerAction.unknown;
    return BannerAction.values.firstWhere(
      (e) => e.url == url,
      orElse: () => BannerAction.unknown,
    );
  }
}

class BannerItem extends StatelessWidget {
  final BannerModel banner;
  final VoidCallback? onCloseTap;

  const BannerItem({super.key, required this.banner, this.onCloseTap});

  void _handleAction(BuildContext context, String? url) {
    if (url == null) return;

    final action = BannerAction.fromUrl(url);
    final metadata = banner.metadata ?? {};

    switch (action) {
      // case BannerAction.retrait:
      //   context.pushNamed(WithdrawFormScreenV2.name);
      //   break;
      // case BannerAction.demandesValidation:
      //   context.pushNamed(PendingReservationsPage.name);
      //   break;
      default:
        log('BannerItem: Cannot navigate to $action  ');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = _parseHexColor(banner.textColor, Colors.white);
    final Color iconColor = _parseHexColor(banner.iconColor, textColor);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (banner.icon != null) ...[
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Icon(
              _getIconData(banner.icon!),
              color: iconColor,
              size: 24,
            ),
          ),
          const Gap(10),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: banner.ctaLabel != null
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      banner.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: textColor,
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                            letterSpacing: 0,
                          ),
                    ),
                  ),
                  const Gap(5),
                  GestureDetector(
                    onTap: onCloseTap,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Icon(Icons.close, color: textColor, size: 16),
                    ),
                  ),
                ],
              ),
              const Gap(2),
              Text(
                banner.subtitle ?? '',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textColor.withValues(alpha: 0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      height: 1.0,
                      letterSpacing: 0,
                    ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (banner.ctaLabel != null) ...[
                const Spacer(),
                Row(
                  children: [
                    BannerButton(
                      label: banner.ctaLabel!,
                      onPressed: () => _handleAction(context, banner.ctaUrl),
                      isPrimary: true,
                      color: textColor,
                    ),
                    if (banner.cta2Label != null) ...[
                      const Gap(16),
                      BannerButton(
                        label: banner.cta2Label!,
                        onPressed: () => _handleAction(context, banner.cta2Url),
                        isPrimary: false,
                        color: textColor,
                      ),
                    ],
                  ],
                ),
              ],
            ],
          ),
        )
      ],
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'wallet':
        return Iconsax.wallet;
      case 'clock':
        return Iconsax.clock;
      case 'calendar':
        return Iconsax.calendar;
      case 'calendar-check':
        return Iconsax.calendar_tick;
      case 'bell':
      case 'notification':
        return Iconsax.notification;
      case 'search':
        return Iconsax.search_normal;
      default:
        return Iconsax.notification;
    }
  }

  Color _parseHexColor(String? hex, Color fallback) {
    if (hex == null || hex.isEmpty) return fallback;
    try {
      return Color(int.parse(hex.replaceAll('#', '0xFF')));
    } catch (_) {
      return fallback;
    }
  }
}
