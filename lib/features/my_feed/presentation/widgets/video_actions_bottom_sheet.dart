import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/features/my_feed/data/models/feed_video_dto.dart';
import 'package:immoplus_pro/features/my_feed/logic/my_feed_cubit.dart';
import 'package:immoplus_pro/features/owner_stats/presentation/widgets/stats_colors.dart';
import 'package:immoplus_pro/core/services/share_service.dart';
import 'package:timeago/timeago.dart' as timeago;

class VideoActionsBottomSheet extends StatelessWidget {
  final FeedVideoDto video;

  const VideoActionsBottomSheet({super.key, required this.video});

  static const _brandIce = Color(0xFFEEF1FC);
  static const _dangerBg = Color(0xFFFCEBEB);
  static const _danger = Color(0xFFA32D2D);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 14),
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header context
            _buildHeader(context),

            const SizedBox(height: 8),

            // Actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _actionTile(
                    context,
                    icon: CupertinoIcons.eye,
                    iconBg: _brandIce,
                    iconColor: StatsColors.brand,
                    title: 'Aperçu',
                    subtitle: 'Regarder comme un visiteur',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to /feed/${video.shortCode}
                    },
                  ),
                  _actionTile(
                    context,
                    icon: CupertinoIcons.pencil_outline,
                    iconBg: _brandIce,
                    iconColor: StatsColors.brand,
                    title: 'Modifier le titre',
                    subtitle: 'Titre et description',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to /owner/feed/${video.id}/edit
                    },
                  ),
                  _actionTile(
                    context,
                    icon: CupertinoIcons.house,
                    iconBg: _brandIce,
                    iconColor: StatsColors.brand,
                    title: 'Changer le bien lié',
                    subtitle: video.relatedTo?.entity ?? 'Non lié',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to /owner/feed/${video.id}/change-property
                    },
                  ),
                  _actionTile(
                    context,
                    icon: CupertinoIcons.share,
                    iconBg: _brandIce,
                    iconColor: StatsColors.brand,
                    title: 'Partager',
                    subtitle: 'WhatsApp, lien, réseaux...',
                    onTap: () {
                      Navigator.pop(context);
                      ShareService.shareUrl(
                        url: 'https://immoplus.ci/feed/${video.shortCode}',
                        title: video.content.title,
                        context: context,
                      );
                    },
                  ),
                  _actionTile(
                    context,
                    icon: CupertinoIcons.chart_bar,
                    iconBg: _brandIce,
                    iconColor: StatsColors.brand,
                    title: 'Statistiques',
                    subtitle: 'Vues, likes, portée',
                    onTap: () {
                      Navigator.pop(context);
                      // TODO: Navigate to /owner/feed/${video.id}/stats
                    },
                  ),

                  // Separator
                  Container(
                    height: 0.5,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    color: Colors.grey.shade200,
                  ),

                  // Delete action
                  _actionTile(
                    context,
                    icon: CupertinoIcons.trash,
                    iconBg: _dangerBg,
                    iconColor: _danger,
                    title: 'Supprimer la vidéo',
                    titleColor: _danger,
                    subtitle: 'Cette action est définitive',
                    showChevron: false,
                    onTap: () => _confirmDelete(context),
                  ),
                ],
              ),
            ),

            // Close button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Fermer',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: StatsColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final timeAgo = video.createdAt != null
        ? timeago.format(video.createdAt!, locale: 'fr')
        : '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Mini thumbnail
          Container(
            width: 48,
            height: 62,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: LinearGradient(
                colors: [
                  StatsColors.brand,
                  StatsColors.brandLight,
                ],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: video.thumbnailUrl != null
                  ? CachedNetworkImage(
                      imageUrl: video.thumbnailUrl!,
                      fit: BoxFit.cover,
                    )
                  : const Center(
                      child: Icon(
                        CupertinoIcons.play_fill,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  video.content.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: StatsColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  'Lié à \u00B7 ${video.content.location}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: StatsColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _miniStat(CupertinoIcons.eye, '${video.stats.views}'),
                    const SizedBox(width: 10),
                    _miniStat(CupertinoIcons.heart, '${video.stats.likes}'),
                    const SizedBox(width: 10),
                    Text(
                      timeAgo,
                      style: const TextStyle(
                        fontSize: 10,
                        color: StatsColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 10, color: StatsColors.textSecondary),
        const SizedBox(width: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 10,
            color: StatsColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _actionTile(
    BuildContext context, {
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? titleColor,
    bool showChevron = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 0),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: titleColor ?? StatsColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: StatsColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (showChevron)
              const Icon(
                CupertinoIcons.chevron_right,
                size: 14,
                color: StatsColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Supprimer cette vidéo ?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Cette action est irréversible. La vidéo sera supprimée définitivement.',
          style: TextStyle(fontSize: 13, color: StatsColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext); // close dialog
              Navigator.pop(context); // close bottom sheet
              context.read<MyFeedCubit>().deleteVideo(video.id);
            },
            child: const Text(
              'Supprimer',
              style: TextStyle(color: _danger),
            ),
          ),
        ],
      ),
    );
  }
}
