import 'dart:async';

import 'package:flutter/material.dart';
import 'package:immoplus_pro/app_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/features/reservations/pending/pending_reservations_page.dart';
import 'package:immoplus_pro/services/pending_reservation_overlay_service.dart';

class PendingReservationBanner extends StatefulWidget {
  const PendingReservationBanner({super.key});

  @override
  State<PendingReservationBanner> createState() =>
      _PendingReservationBannerState();
}

class _PendingReservationBannerState extends State<PendingReservationBanner> {
  final _service = getIt<PendingReservationOverlayService>();

  ReservationModel? _reservation;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchReservation();
    _service.refreshNotifier.addListener(_onRefresh);
  }

  void _onRefresh() {
    _fetchReservation();
  }

  Future<void> _fetchReservation() async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    final reservation = await _service.fetchLatestPendingReservation();

    if (!mounted) return;

    setState(() {
      _reservation = reservation;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _service.refreshNotifier.removeListener(_onRefresh);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _reservation == null) {
      return const SizedBox.shrink();
    }

    final reservation = _reservation!;

    return GestureDetector(
      onTap: () {
        AppRouter.router.push(PendingReservationsPage.route());
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.18),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary.withOpacity(0.12),
              child: Icon(
                Icons.notifications_active_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nouvelle réservation en attente',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    reservation.residence?.nom != null
                        ? '${reservation.residence!.nom} attend votre réponse'
                        : 'Une réservation attend votre réponse',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Voir',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
