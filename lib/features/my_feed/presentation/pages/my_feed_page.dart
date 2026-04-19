import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/my_feed/data/models/feed_video_dto.dart';
import 'package:immoplus_pro/features/my_feed/logic/my_feed_cubit.dart';
import 'package:immoplus_pro/features/my_feed/logic/my_feed_state.dart';
import 'package:immoplus_pro/features/my_feed/presentation/widgets/feed_video_card.dart';
import 'package:immoplus_pro/features/my_feed/presentation/widgets/video_actions_bottom_sheet.dart';
import 'package:immoplus_pro/features/owner_stats/presentation/widgets/stats_colors.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class MyFeedPage extends StatelessWidget {
  const MyFeedPage({super.key});

  static const String name = 'MY_FEED';
  static String routePath() => '/my_feed';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyFeedCubit()..loadFeed(),
      child: const _MyFeedView(),
    );
  }
}

class _MyFeedView extends StatelessWidget {
  const _MyFeedView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        color: StatsColors.brand,
        onRefresh: () => context.read<MyFeedCubit>().loadFeed(),
        child: BlocBuilder<MyFeedCubit, MyFeedState>(
          builder: (context, state) {
            if (state is MyFeedLoading) return _buildSkeleton();
            if (state is MyFeedError) return _buildError(context, state.message);
            if (state is MyFeedLoaded) {
              if (state.videos.isEmpty) return _buildEmpty();
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
        'Mon feed',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: StatsColors.textPrimary,
        ),
      ),
      centerTitle: false,
      actions: [
        BlocBuilder<MyFeedCubit, MyFeedState>(
          builder: (context, state) {
            final hasVideos =
                state is MyFeedLoaded && state.videos.isNotEmpty;
            if (!hasVideos) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () {
                  // TODO: Navigate to /owner/feed/new
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 4),
                  // decoration: BoxDecoration(
                  //   color: StatsColors.brand,
                  //   borderRadius: BorderRadius.circular(20),
                  // ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Iconsax.add,
                          size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        'Poster',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, MyFeedLoaded state) {
    final numberFormat = NumberFormat('#,###', 'fr_FR');

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(8),

          // KPI summary
          _buildKpiBar(state.summary, numberFormat),
          const Gap(18),

          // "Mes vidéos" header
          const Text(
            'Mes vidéos',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: StatsColors.textPrimary,
            ),
          ),
          const Gap(12),

          // Video grid
          _buildGrid(context, state.videos),
          const Gap(30),
        ],
      ),
    );
  }

  Widget _buildKpiBar(FeedSummaryDto summary, NumberFormat numberFormat) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: StatsColors.brand.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _kpiColumn(
            icon: CupertinoIcons.videocam_fill,
            value: '${summary.totalVideos}',
            label: 'Vidéos',
            iconColor: StatsColors.brand,
          ),
          Container(width: 0.5, height: 28, color: Colors.grey.shade200),
          _kpiColumn(
            icon: CupertinoIcons.eye_fill,
            value: numberFormat.format(summary.totalViews),
            label: 'Vues',
            iconColor: StatsColors.textPrimary,
          ),
          Container(width: 0.5, height: 28, color: Colors.grey.shade200),
          _kpiColumn(
            icon: CupertinoIcons.heart_fill,
            value: numberFormat.format(summary.totalLikes),
            label: 'Likes',
            iconColor: StatsColors.textPrimary,
          ),
        ],
      ),
    );
  }

  Widget _kpiColumn({
    required IconData icon,
    required String value,
    required String label,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: iconColor),
            const SizedBox(width: 5),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: StatsColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: StatsColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(BuildContext context, List<FeedVideoDto> videos) {
    // Videos + "new video" tile at the end
    final itemCount = videos.length + 1;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.58,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index == videos.length) {
          return _buildNewVideoTile();
        }
        final video = videos[index];
        return FeedVideoCard(
          video: video,
          onMenuTap: () => _showActions(context, video),
          onTap: () => _onVideoTap(context, video),
        );
      },
    );
  }

  Widget _buildNewVideoTile() {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(12),
      color: StatsColors.brand.withValues(alpha: 0.3),
      strokeWidth: 1,
      dashPattern: const [6, 4],
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF1FC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  CupertinoIcons.plus,
                  size: 18,
                  color: StatsColors.brand,
                ),
              ),
              const Gap(8),
              const Text(
                'Nouvelle vidéo',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: StatsColors.brand,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showActions(BuildContext context, FeedVideoDto video) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (_) => BlocProvider.value(
        value: context.read<MyFeedCubit>(),
        child: VideoActionsBottomSheet(video: video),
      ),
    );
  }

  void _onVideoTap(BuildContext context, FeedVideoDto video) {
    if (video.isReady) {
      // TODO: Navigate to /feed/${video.shortCode}
    } else if (video.isProcessing) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vidéo en cours d'encodage, veuillez patienter"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else if (video.isFailed) {
      // TODO: Show retry dialog → POST /feed/videos/:id/retry
    }
  }

  Widget _buildEmpty() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const Gap(40),
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0xFFEEF1FC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              CupertinoIcons.videocam,
              size: 32,
              color: StatsColors.brand,
            ),
          ),
          const Gap(20),
          const Text(
            'Aucune vidéo pour le moment',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: StatsColors.textPrimary,
            ),
          ),
          const Gap(8),
          const Text(
            'Publiez votre première vidéo pour présenter\nvos biens et attirer plus de visiteurs.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: StatsColors.textSecondary,
              height: 1.4,
            ),
          ),
          const Gap(24),
          // Score de confiance requis
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: StatsColors.warningBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: StatsColors.warning.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: StatsColors.kpiScoreBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    CupertinoIcons.star_fill,
                    size: 16,
                    color: StatsColors.kpiScoreAccent,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Score de confiance requis',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: StatsColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Vous devez atteindre un score de confiance de 3.5 pour poster une vidéo sur le feed.',
                        style: TextStyle(
                          fontSize: 12,
                          color: StatsColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
                color: Color(0xFFEEF1FC),
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
              onPressed: () => context.read<MyFeedCubit>().loadFeed(),
              style: ElevatedButton.styleFrom(
                backgroundColor: StatsColors.brand,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
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
            const Gap(8),
            // KPI skeleton
            Container(
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const Gap(18),
            // Title skeleton
            Container(
              width: 100,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const Gap(12),
            // Grid skeleton
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.58,
              children: List.generate(
                4,
                (_) => Container(
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
}
