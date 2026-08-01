import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus_pro/features/my_feed/data/models/feed_video_dto.dart';
import 'package:immoplus_pro/features/owner_stats/presentation/widgets/stats_colors.dart';

class FeedVideoCard extends StatelessWidget {
  final FeedVideoDto video;
  final VoidCallback onMenuTap;
  final VoidCallback onTap;

  const FeedVideoCard({
    super.key,
    required this.video,
    required this.onMenuTap,
    required this.onTap,
  });

  static const _gradients = [
    [Color(0xFF667eea), Color(0xFF764ba2)],
    [Color(0xFF11998e), Color(0xFF38ef7d)],
    [Color(0xFFfc5c7d), Color(0xFF6a82fb)],
    [Color(0xFFf857a6), Color(0xFFff5858)],
    [Color(0xFF4facfe), Color(0xFF00f2fe)],
  ];

  List<Color> get _gradient {
    final idx = video.id.hashCode.abs() % _gradients.length;
    return _gradients[idx];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: StatsColors.brand.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              Expanded(child: _buildThumbnail()),
              // Footer
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Image or gradient
        if (video.thumbnailUrl != null)
          CachedNetworkImage(
            imageUrl: video.thumbnailUrl!,
            fit: BoxFit.cover,
          )
        else
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

        // Overlay for processing/failed
        if (video.isProcessing || video.isFailed)
          Container(
            color: Colors.black.withValues(alpha: 0.4),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    video.isProcessing
                        ? CupertinoIcons.clock_fill
                        : CupertinoIcons.exclamationmark_circle_fill,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    video.isProcessing ? 'Encodage...' : 'Échec',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Play button for ready videos
        if (video.isReady)
          Center(
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.play_fill,
                color: StatsColors.brand,
                size: 14,
              ),
            ),
          ),

        // Status badge top-left
        Positioned(
          top: 8,
          left: 8,
          child: _buildStatusBadge(),
        ),

        // Menu button top-right
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onMenuTap,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.more_vert,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ),

        // Stats overlay bottom for ready videos
        if (video.isReady)
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statChip(CupertinoIcons.eye_fill, '${video.stats.views}'),
                _statChip(CupertinoIcons.heart_fill, '${video.stats.likes}'),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    Color bgColor;
    String label;
    bool showDot;

    if (video.isReady) {
      bgColor = const Color(0xFF0F6E56);
      label = 'Prête';
      showDot = true;
    } else if (video.isProcessing) {
      bgColor = const Color(0xFF854F0B);
      label = 'En cours';
      showDot = true;
    } else {
      bgColor = const Color(0xFFA32D2D);
      label = 'Réessayer';
      showDot = false;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 10),
        const SizedBox(width: 3),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    IconData entityIcon;
    switch (video.relatedTo?.entity) {
      case 'residence':
        entityIcon = FontAwesomeIcons.building.data;
        break;
      case 'furniture':
        entityIcon = FontAwesomeIcons.couch.data;
        break;
      default:
        entityIcon = FontAwesomeIcons.house.data;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            video.content.title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: StatsColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Row(
            children: [
              Icon(entityIcon, size: 10, color: StatsColors.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  video.content.price,
                  style: const TextStyle(
                    fontSize: 10,
                    color: StatsColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
