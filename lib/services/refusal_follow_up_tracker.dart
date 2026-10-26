import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:immoplus_pro/services/analytics_service.dart';

/// Mesure si le pro corrige la cause d'un refus de réservation.
///
/// - `calendar_updated_after_refusal` : dates bloquées dans les 5 minutes.
/// - `refusal_no_corrective_action` : ni calendrier ni tarif modifié dans
///   les 10 minutes.
///
/// Le suivi est en mémoire : il est perdu si l'application est fermée avant
/// la fin de la fenêtre.
@lazySingleton
class RefusalFollowUpTracker {
  RefusalFollowUpTracker(this._analytics);

  static const Duration calendarWindow = Duration(minutes: 5);
  static const Duration correctiveActionWindow = Duration(minutes: 10);

  final AnalyticsService _analytics;
  final Map<String, _PendingRefusal> _pending = {};

  /// À appeler une fois qu'une réservation a été refusée.
  void onBookingRefused(String reservationId) {
    _pending.remove(reservationId)?.timer.cancel();
    _pending[reservationId] = _PendingRefusal(
      refusedAt: DateTime.now(),
      timer:
          Timer(correctiveActionWindow, () => _onWindowElapsed(reservationId)),
    );
  }

  /// À appeler quand le pro bloque ou modifie des dates de son calendrier.
  void onCalendarUpdated() {
    final now = DateTime.now();
    for (final entry in _pending.entries) {
      final elapsed = now.difference(entry.value.refusedAt);
      if (elapsed <= calendarWindow) {
        _analytics.logCalendarUpdatedAfterRefusal(
          idReservation: entry.key,
          minutesSinceRefusal: elapsed.inMinutes,
        );
      }
    }
    _resolveAll();
  }

  /// À appeler quand le pro modifie le tarif d'une résidence.
  void onPriceUpdated() => _resolveAll();

  void _onWindowElapsed(String reservationId) {
    if (_pending.remove(reservationId) != null) {
      _analytics.logRefusalNoCorrectiveAction(idReservation: reservationId);
    }
  }

  void _resolveAll() {
    for (final refusal in _pending.values) {
      refusal.timer.cancel();
    }
    _pending.clear();
  }
}

class _PendingRefusal {
  const _PendingRefusal({required this.refusedAt, required this.timer});

  final DateTime refusedAt;
  final Timer timer;
}
