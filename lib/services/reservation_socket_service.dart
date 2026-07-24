import 'dart:async';
import 'dart:developer';

import 'package:immoplus_pro/data/models/reservations/status_reservation.dart';
import 'package:immoplus_pro/request_path.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

/// Event reçu sur le canal temps réel des réservations
class ReservationStatusUpdatedEvent {
  final String reservationId;
  final StatusReservation? status;
  final String rawStatus;
  final DateTime? updatedAt;

  ReservationStatusUpdatedEvent({
    required this.reservationId,
    required this.status,
    required this.rawStatus,
    required this.updatedAt,
  });

  factory ReservationStatusUpdatedEvent.fromJson(Map<String, dynamic> json) {
    final rawStatus = json['newStatus'] as String? ?? '';
    return ReservationStatusUpdatedEvent(
      reservationId: json['reservationId'] as String? ?? '',
      status: StatusReservation.fromString(rawStatus),
      rawStatus: rawStatus,
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? ''),
    );
  }
}

/// Client Socket.io pour le canal temps réel des réservations
@lazySingleton
class ReservationSocketService {
  socket_io.Socket? _socket;
  final _controller =
      StreamController<ReservationStatusUpdatedEvent>.broadcast();

  Stream<ReservationStatusUpdatedEvent> get onStatusUpdated =>
      _controller.stream;

  /// Ouvre (ou rouvre) la connexion avec le token courant. Si un socket
  void connect() {
    final token = SessionManager().currentUser?.accessToken;
    if (token == null || token.isEmpty) {
      log('Pas de token, connexion annulée', name: 'RESERVATION_SOCKET');
      return;
    }

    disconnect();

    final socket = socket_io.io(
      '${RequestPath.baseUrl}/reservations',
      socket_io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .enableReconnection()
          .build(),
    );

    socket.onConnect((_) => log('Connecté', name: 'RESERVATION_SOCKET'));
    // Le backend ferme la connexion immédiatement (sans event d'erreur
    socket.onDisconnect(
        (reason) => log('Déconnecté: $reason', name: 'RESERVATION_SOCKET'));
    socket.onConnectError(
        (err) => log('Erreur de connexion: $err', name: 'RESERVATION_SOCKET'));

    socket.on('reservation:status_updated', (data) {
      try {
        if (data is Map) {
          _controller.add(
            ReservationStatusUpdatedEvent.fromJson(
                Map<String, dynamic>.from(data)),
          );
        }
      } catch (e) {
        log('Erreur de parsing event: $e', name: 'RESERVATION_SOCKET');
      }
    });

    socket.connect();
    _socket = socket;
  }

  /// Ferme la connexion et nettoie les listeners. Sans effet si aucune
  void disconnect() {
    _socket?.dispose();
    _socket = null;
  }
}
