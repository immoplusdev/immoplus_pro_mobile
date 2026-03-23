import 'package:flutter/material.dart';
import 'package:immoplus_pro/common/order_dir.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PendingReservationOverlayService {
  PendingReservationOverlayService();

  /// utilisé pour refresh la card
  final ValueNotifier<int> refreshNotifier = ValueNotifier<int>(0);

  void refreshPendingReservation() {
    refreshNotifier.value++;
  }

  Future<ReservationModel?> fetchLatestPendingReservation() async {
    try {
      final ownerId = SessionManager().currentUser?.userId;
      if (ownerId == null) return null;

      final result = await LogmentRepository.getReservationsEnAttenteReponse(
        ownerId: ownerId,
        perPage: 1,
        page: 1,
        orderBy: OrderByField.createdAt.value,
        orderDir: OrderDir.desc.value,
      );

      if (result.data.isNotEmpty) return result.data.first;
      return null;
    } catch (_) {
      return null;
    }
  }
}
