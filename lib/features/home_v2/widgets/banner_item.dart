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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (banner.icon != null) ...[
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Icon(
              _getIconData(banner.icon!),
              color: Colors.white,
              size: 24,
            ),
          ),
          const Gap(10),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      banner.title ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const Gap(5),
                  GestureDetector(
                    onTap: onCloseTap,
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.close, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
              Text(
                banner.subtitle ?? '',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 11,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Spacer(),
              if (banner.ctaLabel != null) ...[
                Row(
                  children: [
                    BannerButton(
                      label: banner.ctaLabel!,
                      onPressed: () => _handleAction(context, banner.ctaUrl),
                      isPrimary: true,
                    ),
                    if (banner.cta2Label != null) ...[
                      const Gap(16),
                      BannerButton(
                        label: banner.cta2Label!,
                        onPressed: () => _handleAction(context, banner.cta2Url),
                        isPrimary: false,
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
      case 'calendar-check':
        return Iconsax.calendar_tick;
      case 'notification':
        return Iconsax.notification;
      default:
        return Iconsax.notification;
    }
  }
}
