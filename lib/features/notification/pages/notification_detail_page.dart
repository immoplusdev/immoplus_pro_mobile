import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/features/notification/data/models/notification_dto.dart';
import 'package:immoplus_pro/features/owner_stats/presentation/widgets/stats_colors.dart';
import 'package:intl/intl.dart';

class NotificationDetailPage extends StatelessWidget {
  final NotificationDto notification;

  const NotificationDetailPage({super.key, required this.notification});

  static const String name = 'NOTIFICATION_DETAIL';

  @override
  Widget build(BuildContext context) {
    final type = notification.typeEnum;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
        title: Text(
          'Détails',
          style: GoogleFonts.dmSans(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: StatsColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ───────────────────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: type.backgroundColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(type.icon, color: type.color, size: 24),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.subject ?? notification.message,
                        style: GoogleFonts.dmSans(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: StatsColors.textPrimary,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        DateFormat('d MMMM yyyy, HH:mm', 'fr_FR')
                            .format(notification.createdAt),
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(28),

            // ── Section label ────────────────────────────────────────────
            Text(
              'Message',
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: StatsColors.textSecondary,
                letterSpacing: 0.3,
              ),
            ),
            const Gap(10),

            // ── Message card ─────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: StatsColors.brand.withValues(alpha: 0.08),
                ),
              ),
              child: Text(
                notification.message.isNotEmpty
                    ? notification.message
                    : 'Aucun contenu.',
                style: GoogleFonts.dmSans(
                  fontSize: 15,
                  color: StatsColors.textPrimary,
                  height: 1.6,
                ),
              ),
            ),
            const Gap(40),
          ],
        ),
      ),
    );
  }
}
