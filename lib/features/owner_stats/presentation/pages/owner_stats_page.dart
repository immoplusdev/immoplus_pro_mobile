import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/features/notification/notification_page.dart';
import 'package:immoplus_pro/features/owner_stats/data/models/owner_stats_dto.dart';
import 'package:immoplus_pro/features/owner_stats/logic/owner_stats_cubit.dart';
import 'package:immoplus_pro/features/owner_stats/logic/owner_stats_state.dart';
import 'package:immoplus_pro/features/owner_stats/presentation/widgets/kpi_card.dart';
import 'package:immoplus_pro/features/owner_stats/presentation/widgets/occupancy_bars.dart';
import 'package:immoplus_pro/features/owner_stats/presentation/widgets/period_pills.dart';
import 'package:immoplus_pro/features/owner_stats/presentation/widgets/recent_transactions_list.dart';
import 'package:immoplus_pro/features/owner_stats/presentation/widgets/reservations_donut_chart.dart';
import 'package:immoplus_pro/features/owner_stats/presentation/widgets/revenue_line_chart.dart';
import 'package:immoplus_pro/features/owner_stats/presentation/widgets/stats_colors.dart';
import 'package:immoplus_pro/features/owner_stats/presentation/widgets/top_properties_list.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class OwnerStatsPage extends StatelessWidget {
  const OwnerStatsPage({super.key});

  static String name = 'OWNER_STATS';
  static String routePath() => '/owner_stats';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OwnerStatsCubit()..loadStats(),
      child: const _OwnerStatsView(),
    );
  }
}

class _OwnerStatsView extends StatelessWidget {
  const _OwnerStatsView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OwnerStatsCubit>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        leading: const SizedBox.shrink(),
        leadingWidth: 0,
        title: const Text(
          'Statistiques',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: StatsColors.textPrimary,
          ),
        ),
        centerTitle: false,
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 16),
        //     child: GestureDetector(
        //       onTap: () => context.push(NotificationPage.routePath()),
        //       child: Container(
        //         width: 40,
        //         height: 40,
        //         decoration: const BoxDecoration(
        //           color: StatsColors.brandIce,
        //           shape: BoxShape.circle,
        //         ),
        //         child: const Icon(
        //           CupertinoIcons.bell,
        //           size: 18,
        //           color: StatsColors.brand,
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: RefreshIndicator(
        color: StatsColors.brand,
        onRefresh: () => cubit.refresh(),
        child: BlocBuilder<OwnerStatsCubit, OwnerStatsState>(
          builder: (context, state) {
            if (state is OwnerStatsLoading) {
              return _buildSkeleton();
            }
            if (state is OwnerStatsError) {
              return _buildError(context, state.message);
            }
            if (state is OwnerStatsLoaded) {
              return _buildContent(context, state.stats);
            }
            return _buildSkeleton();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, OwnerStatsDto stats) {
    final cubit = context.read<OwnerStatsCubit>();
    final numberFormat = NumberFormat('#,###', 'fr_FR');
    final percentFormat = NumberFormat('+#,##0.0;-#,##0.0', 'fr_FR');
    final scoreFormat = NumberFormat('#,##0.0', 'fr_FR');

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          // Period pills
          PeriodPills(
            selected: cubit.currentPeriod,
            onChanged: (period) => cubit.loadStats(period: period),
          ),
          const SizedBox(height: 18),

          // KPI Grid 2x2
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.45,
            children: [
              KpiCard(
                label: 'Revenu du mois',
                value: numberFormat.format(stats.revenue.currentPeriod),
                subtitle:
                    '\u2197 ${percentFormat.format(stats.revenue.percentChange)}%',
                subtitleColor: stats.revenue.percentChange >= 0
                    ? StatsColors.success
                    : Colors.red,
                icon: CupertinoIcons.money_dollar_circle_fill,
                accentColor: StatsColors.kpiRevenueAccent,
                bgTint: StatsColors.kpiRevenueBg,
              ),
              KpiCard(
                label: 'Biens actifs',
                value: '${stats.properties.totalActive}',
                subtitle:
                    '${stats.properties.biens} biens \u00B7 ${stats.properties.residences} rés \u00B7 ${stats.properties.furniture} meub',
                icon: CupertinoIcons.house_fill,
                accentColor: StatsColors.kpiBiensAccent,
                bgTint: StatsColors.kpiBiensBg,
              ),
              KpiCard(
                label: 'Vues totales',
                value: numberFormat.format(stats.engagement.totalViews),
                subtitle: '${stats.engagement.totalLikes} likes',
                icon: CupertinoIcons.eye_fill,
                accentColor: StatsColors.kpiVuesAccent,
                bgTint: StatsColors.kpiVuesBg,
              ),
              KpiCard(
                label: 'Score Confiance',
                value:
                    '${scoreFormat.format(stats.engagement.averageScore)} / 5',
                subtitle: _buildStars(stats.engagement.averageScore),
                subtitleColor: StatsColors.kpiScoreAccent,
                icon: CupertinoIcons.star_fill,
                accentColor: StatsColors.kpiScoreAccent,
                bgTint: StatsColors.kpiScoreBg,
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Revenue line chart
          RevenueLineChart(data: stats.revenueChart),
          const SizedBox(height: 18),

          // Reservations donut
          ReservationsDonutChart(reservations: stats.reservations),
          const SizedBox(height: 18),

          // Occupancy bars
          OccupancyBars(occupancy: stats.occupancy),
          const SizedBox(height: 18),

          // Top properties
          TopPropertiesList(properties: stats.topProperties),
          const SizedBox(height: 18),

          // Recent transactions
          RecentTransactionsList(transactions: stats.recentTransactions),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  String _buildStars(double score) {
    final full = score.floor();
    final half = (score - full) >= 0.5 ? 1 : 0;
    final empty = 5 - full - half;
    return '${'★' * full}${'★' * half}${'☆' * empty}';
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
              decoration: BoxDecoration(
                color: StatsColors.brandIce,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.exclamationmark_triangle,
                size: 28,
                color: StatsColors.brand,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Erreur de chargement',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: StatsColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: StatsColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.read<OwnerStatsCubit>().refresh(),
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
            const SizedBox(height: 4),
            // Pills skeleton
            Row(
              children: List.generate(
                3,
                (_) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    width: 80,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            // KPI grid skeleton
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.45,
              children: List.generate(
                4,
                (_) => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            // Chart skeleton
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 18),
            // Donut skeleton
            Container(
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 18),
            // Bars skeleton
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 18),
            // List skeleton
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
