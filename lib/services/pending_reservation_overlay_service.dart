import 'package:flutter/material.dart';
import 'package:immoplus_pro/app_router.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/features/reservations/pending/pending_reservations_page.dart';
import 'package:immoplus_pro/services/pending_reservation_overlay_widget.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PendingReservationOverlayService {
  PendingReservationOverlayService();

  OverlayEntry? _overlayEntry;

  Future<ReservationModel?> _fetchLatest() async {
    try {
      final ownerId = SessionManager().currentUser?.userId;
      if (ownerId == null) return null;
      final result = await LogmentRepository.getReservationsEnAttenteReponse(
        ownerId: ownerId,
        perPage: 1,
        page: 1,
      );
      if (result.data.isNotEmpty) return result.data.first;
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> checkAndShowOverlay(BuildContext context) async {
    final reservation = await _fetchLatest();
    dismissOverlay();
    if (reservation == null) return;

    _overlayEntry = OverlayEntry(
      builder: (_) => PendingReservationOverlayWidget(
        reservation: reservation,
        onDismiss: dismissOverlay,
        onNavigate: () {
          dismissOverlay();
          AppRouter.router.push(PendingReservationsPage.route());
        },
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void dismissOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
