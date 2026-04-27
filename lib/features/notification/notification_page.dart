import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:immoplus_pro/features/notification/data/models/notification_dto.dart';
import 'package:immoplus_pro/features/notification/data/notification_repository.dart';
import 'package:immoplus_pro/features/notification/pages/notification_detail_page.dart';
import 'package:immoplus_pro/features/notification/pages/notification_tile.dart';
import 'package:immoplus_pro/features/owner_stats/presentation/widgets/stats_colors.dart';
import 'package:shimmer/shimmer.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  static const String name = 'NOTIFICATIONS';
  static String routePath() => '/notifications';

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  static const _pageSize = 20;

  final PagingController<int, NotificationDto> _pagingController =
      PagingController(firstPageKey: 1);

  // Nombre de non-lus calculé localement sur les items déjà chargés
  int get _unreadCount =>
      (_pagingController.itemList ?? []).where((n) => !n.isRead).length;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(_loadPage);
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  // ── Pagination ────────────────────────────────────────────────────────────

  Future<void> _loadPage(int page) async {
    try {
      final response = await NotificationRepository.getNotifications(
        page: page,
        pageSize: _pageSize,
      );

      if (response.hasNext) {
        _pagingController.appendPage(response.data, page + 1);
      } else {
        _pagingController.appendLastPage(response.data);
      }

      // Recalcule l'unread badge
      if (mounted) setState(() {});
    } catch (error) {
      _pagingController.error = error.toString();
    }
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> _markAsRead(NotificationDto notif) async {
    if (notif.isRead) return;
    await NotificationRepository.markAsRead(notif.id);
    _updateItem(notif.id, notif.copyWith(isRead: true));
  }

  Future<void> _markAllAsRead() async {
    await NotificationRepository.markAllAsRead();
    final updated = (_pagingController.itemList ?? [])
        .map((n) => n.copyWith(isRead: true))
        .toList();
    _pagingController.itemList = updated;
    if (mounted) setState(() {});
  }

  Future<void> _deleteNotification(String id) async {
    await NotificationRepository.deleteNotification(id);
    final updated =
        (_pagingController.itemList ?? []).where((n) => n.id != id).toList();
    _pagingController.itemList = updated;
    if (mounted) setState(() {});
  }

  void _updateItem(String id, NotificationDto updated) {
    final list = _pagingController.itemList ?? [];
    final idx = list.indexWhere((n) => n.id == id);
    if (idx != -1) {
      list[idx] = updated;
      _pagingController.itemList = list;
      if (mounted) setState(() {});
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // Pull-to-refresh
          CupertinoSliverRefreshControl(
            onRefresh: () async => _pagingController.refresh(),
          ),

          // Grouped + paginated list
          PagedSliverList<int, NotificationDto>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<NotificationDto>(
              // ── Loading first page ───────────────────────────────────────
              firstPageProgressIndicatorBuilder: (_) => _buildSkeleton(),

              // ── Empty ────────────────────────────────────────────────────
              noItemsFoundIndicatorBuilder: (_) => _buildEmpty(),

              // ── Error (first page) ───────────────────────────────────────
              firstPageErrorIndicatorBuilder: (_) =>
                  _buildError(_pagingController.error.toString()),

              // ── Error (load-more) ────────────────────────────────────────
              newPageErrorIndicatorBuilder: (_) => Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: TextButton.icon(
                    onPressed: _pagingController.retryLastFailedRequest,
                    icon: const Icon(Icons.refresh,
                        size: 18, color: StatsColors.brand),
                    label: const Text(
                      'Réessayer',
                      style: TextStyle(color: StatsColors.brand),
                    ),
                  ),
                ),
              ),

              // ── Load-more progress ───────────────────────────────────────
              newPageProgressIndicatorBuilder: (_) => const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(StatsColors.brand),
                    ),
                  ),
                ),
              ),

              // ── Item ─────────────────────────────────────────────────────
              itemBuilder: (context, notif, index) {
                final items = _pagingController.itemList ?? [];

                // Date separator
                final showHeader = index == 0 ||
                    _dateLabel(notif.createdAt) !=
                        _dateLabel(items[index - 1].createdAt);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showHeader)
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            16, index == 0 ? 12 : 20, 16, 6),
                        child: Text(
                          _dateLabel(notif.createdAt),
                          style: GoogleFonts.dmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: StatsColors.textSecondary,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    NotificationTile(
                      notification: notif,
                      onTap: () async {
                        await _markAsRead(notif);
                        if (!context.mounted) return;
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (_) =>
                                NotificationDetailPage(notification: notif),
                          ),
                        );
                      },
                      onDelete: () => _deleteNotification(notif.id),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
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
          fontWeight: FontWeight.w600,
          color: StatsColors.textPrimary,
        ),
      ),
      centerTitle: false,
      actions: [
        if (_unreadCount > 0)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: _markAllAsRead,
              child: const Center(
                child: Text(
                  'Tout lire',
                  style: TextStyle(
                    color: StatsColors.brand,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ── Empty ─────────────────────────────────────────────────────────────────

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Gap(60),
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
    );
  }

  // ── Error ─────────────────────────────────────────────────────────────────

  Widget _buildError(String message) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Gap(60),
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
            onPressed: _pagingController.refresh,
            style: ElevatedButton.styleFrom(
              backgroundColor: StatsColors.brand,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            ),
            child: const Text(
              'Réessayer',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ── Skeleton ──────────────────────────────────────────────────────────────

  Widget _buildSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.grey.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: 80,
              height: 13,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const Gap(12),
          ...List.generate(
            8,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: Container(
                height: 72,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Date label helper ─────────────────────────────────────────────────────

  String _dateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final thisWeekStart = today.subtract(Duration(days: today.weekday - 1));
    final day = DateTime(date.year, date.month, date.day);

    if (!day.isBefore(today)) return "Aujourd'hui";
    if (day == yesterday) return 'Hier';
    if (!day.isBefore(thisWeekStart)) return 'Cette semaine';
    return 'Plus ancien';
  }
}
