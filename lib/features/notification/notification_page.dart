import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/features/notification/data/models/notification_dto.dart';
import 'package:immoplus_pro/features/notification/logic/notification_cubit.dart';
import 'package:immoplus_pro/features/notification/logic/notification_state.dart';
import 'package:immoplus_pro/features/owner_stats/presentation/widgets/stats_colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  static const String name = 'NOTIFICATIONS';
  static String routePath() => '/notifications';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationCubit()..loadNotifications(),
      child: const _NotificationView(),
    );
  }
}

class _NotificationView extends StatelessWidget {
  const _NotificationView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        color: StatsColors.brand,
        onRefresh: () => context.read<NotificationCubit>().loadNotifications(),
        child: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) return _buildSkeleton();
            if (state is NotificationError) {
              return _buildError(context, state.message);
            }
            if (state is NotificationLoaded) {
              return _buildContent(context, state);
            }
            return _buildSkeleton();
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Center(
          child: Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFF0F0F2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              CupertinoIcons.chevron_back,
              size: 16,
              color: StatsColors.textPrimary,
            ),
          ),
        ),
      ),
      title: const Text(
        'Notifications',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: StatsColors.textPrimary,
        ),
      ),
      centerTitle: false,
      actions: [
        BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoaded && state.unreadCount > 0) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () =>
                      context.read<NotificationCubit>().markAllAsRead(),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: StatsColors.brandIce,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Tout lire',
                      style: TextStyle(
                        color: StatsColors.brand,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, NotificationLoaded state) {
    if (state.notifications.isEmpty) {
      return _buildEmpty();
    }

    final grouped = _groupByDate(state.notifications);

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final group = grouped[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index == 0) const Gap(8),
            // Section header
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Text(
                group.label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: StatsColors.textSecondary,
                ),
              ),
            ),
            // Notification cards
            ...group.notifications.map(
              (notif) => _buildNotificationTile(context, notif),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNotificationTile(
      BuildContext context, NotificationDto notification) {
    final timeAgo = timeago.format(notification.createdAt, locale: 'fr');
    final iconData = _getIcon(notification.type);
    final iconColor = _getIconColor(notification.type);
    final iconBg = _getIconBg(notification.type);

    return GestureDetector(
      onTap: () {
        if (!notification.isRead) {
          context.read<NotificationCubit>().markAsRead(notification.id);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : StatsColors.brandIce,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: notification.isRead
                ? StatsColors.brand.withValues(alpha: 0.12)
                : StatsColors.brand.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(iconData, size: 18, color: iconColor),
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: notification.isRead
                                ? FontWeight.w500
                                : FontWeight.w600,
                            color: StatsColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(left: 8),
                          decoration: const BoxDecoration(
                            color: StatsColors.brand,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: const TextStyle(
                      fontSize: 12,
                      color: StatsColors.textSecondary,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      fontSize: 11,
                      color: StatsColors.textSecondary.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: StatsColors.brandIce,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.bell_slash,
                size: 32,
                color: StatsColors.brand,
              ),
            ),
            const Gap(20),
            const Text(
              'Aucune notification',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: StatsColors.textPrimary,
              ),
            ),
            const Gap(8),
            const Text(
              'Vous recevrez ici les alertes de réservations,\nvisites, paiements et plus encore.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: StatsColors.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: StatsColors.brandIce,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.exclamationmark_triangle,
                size: 28,
                color: StatsColors.brand,
              ),
            ),
            const Gap(20),
            const Text(
              'Erreur de chargement',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: StatsColors.textPrimary,
              ),
            ),
            const Gap(8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: StatsColors.textSecondary,
              ),
            ),
            const Gap(24),
            ElevatedButton(
              onPressed: () =>
                  context.read<NotificationCubit>().loadNotifications(),
              style: ElevatedButton.styleFrom(
                backgroundColor: StatsColors.brand,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              ),
              child: const Text(
                'Réessayer',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade100,
        highlightColor: Colors.grey.shade50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(20),
            // Section label skeleton
            Container(
              width: 80,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const Gap(12),
            // Card skeletons
            ...List.generate(
              6,
              (_) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ──

  List<_NotificationGroup> _groupByDate(List<NotificationDto> notifications) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final thisWeek = today.subtract(Duration(days: today.weekday - 1));

    final Map<String, List<NotificationDto>> groups = {};

    for (final notif in notifications) {
      final date = DateTime(
          notif.createdAt.year, notif.createdAt.month, notif.createdAt.day);
      String key;

      if (date == today || date.isAfter(today)) {
        key = "Aujourd'hui";
      } else if (date == yesterday ||
          (date.isAfter(yesterday) && date.isBefore(today))) {
        key = 'Hier';
      } else if (date.isAfter(thisWeek) || date == thisWeek) {
        key = 'Cette semaine';
      } else {
        key = 'Plus ancien';
      }

      groups.putIfAbsent(key, () => []);
      groups[key]!.add(notif);
    }

    final order = ["Aujourd'hui", 'Hier', 'Cette semaine', 'Plus ancien'];
    return order
        .where((k) => groups.containsKey(k))
        .map((k) => _NotificationGroup(label: k, notifications: groups[k]!))
        .toList();
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'reservation':
        return CupertinoIcons.calendar;
      case 'demande_visite':
        return CupertinoIcons.eye;
      case 'payment':
        return CupertinoIcons.money_dollar_circle;
      case 'wallet':
        return CupertinoIcons.creditcard;
      case 'bien_immobilier':
        return CupertinoIcons.house;
      case 'residence':
        return CupertinoIcons.building_2_fill;
      case 'new_reservation_waiting':
        return CupertinoIcons.clock;
      case 'auth':
        return CupertinoIcons.shield;
      default:
        return CupertinoIcons.bell;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'reservation':
      case 'new_reservation_waiting':
        return StatsColors.brand;
      case 'demande_visite':
        return StatsColors.kpiVuesAccent;
      case 'payment':
      case 'wallet':
        return StatsColors.success;
      case 'bien_immobilier':
      case 'residence':
        return StatsColors.kpiBiensAccent;
      case 'auth':
        return StatsColors.warning;
      default:
        return StatsColors.brand;
    }
  }

  Color _getIconBg(String type) {
    switch (type) {
      case 'reservation':
      case 'new_reservation_waiting':
        return StatsColors.kpiRevenueBg;
      case 'demande_visite':
        return StatsColors.kpiVuesBg;
      case 'payment':
      case 'wallet':
        return StatsColors.kpiBiensBg;
      case 'bien_immobilier':
      case 'residence':
        return StatsColors.successBg;
      case 'auth':
        return StatsColors.warningBg;
      default:
        return StatsColors.brandIce;
    }
  }
}

class _NotificationGroup {
  final String label;
  final List<NotificationDto> notifications;

  _NotificationGroup({required this.label, required this.notifications});
}
