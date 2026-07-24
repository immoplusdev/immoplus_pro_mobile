import 'dart:async';
import 'dart:developer';

import 'package:immoplus_pro/data/models/reservations/status_reservation.dart';
import 'package:immoplus_pro/request_path.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

/// Event reçu sur le canal temps réel des réservations
/// (`reservation:status_updated`, namespace `/reservations`).
/// Payload volontairement minimaliste côté backend : uniquement
/// l'id, le nouveau statut et la date — pas de détails métier.
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
/// (namespace `/reservations`, voir docs/.MD). Le REST reste la source de
/// vérité : ce service ne fait que signaler qu'un changement a eu lieu,
/// libre à l'écran d'aller chercher les données à jour si besoin.
@lazySingleton
class ReservationSocketService {
  socket_io.Socket? _socket;
  final _controller =
      StreamController<ReservationStatusUpdatedEvent>.broadcast();

  Stream<ReservationStatusUpdatedEvent> get onStatusUpdated =>
      _controller.stream;

  /// Ouvre (ou rouvre) la connexion avec le token courant. Si un socket
  /// existe déjà, il est proprement fermé avant d'en ouvrir un nouveau —
  /// utile après un refresh de token (le handshake n'est vérifié qu'à la
  /// connexion, pas en continu côté backend).
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
    // explicite) si le token est invalide/expiré : un disconnect juste
    // après un connect est le signal à surveiller côté debug.
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
  /// connexion n'est active.
  void disconnect() {
    _socket?.dispose();
    _socket = null;
  }
}
