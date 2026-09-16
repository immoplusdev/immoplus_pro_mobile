import 'dart:async';
import 'dart:developer';

import 'package:immoplus_pro/data/models/remote/messaging/message_model.dart';
import 'package:immoplus_pro/request_path.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:injectable/injectable.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

/// Snapshot de présence renvoyé par l'ACK de `join_conversation`.
class PeerPresence {
  final String userId;
  final bool online;
  final DateTime? lastSeenAt;

  const PeerPresence({
    required this.userId,
    required this.online,
    this.lastSeenAt,
  });

  factory PeerPresence.fromJson(Map<String, dynamic> json) => PeerPresence(
        userId: json['userId']?.toString() ?? '',
        online: json['online'] == true,
        lastSeenAt: json['lastSeenAt'] != null
            ? DateTime.tryParse(json['lastSeenAt'].toString())
            : null,
      );
}

/// Événement `presence` (live update de ce que l'ACK de `join_conversation`
/// a donné comme état initial).
class PresenceEvent {
  final String conversationId;
  final String userId;
  final bool online;
  final DateTime? lastSeenAt;

  const PresenceEvent({
    required this.conversationId,
    required this.userId,
    required this.online,
    this.lastSeenAt,
  });

  factory PresenceEvent.fromJson(Map<String, dynamic> json) => PresenceEvent(
        conversationId: json['conversationId']?.toString() ?? '',
        userId: json['userId']?.toString() ?? '',
        online: json['online'] == true,
        lastSeenAt: json['lastSeenAt'] != null
            ? DateTime.tryParse(json['lastSeenAt'].toString())
            : null,
      );
}

/// Événement `typing` — jamais reçu pour son propre `emit` (le serveur
/// exclut l'émetteur).
class TypingEvent {
  final String conversationId;
  final String userId;
  final bool isTyping;

  const TypingEvent({
    required this.conversationId,
    required this.userId,
    required this.isTyping,
  });

  factory TypingEvent.fromJson(Map<String, dynamic> json) => TypingEvent(
        conversationId: json['conversationId']?.toString() ?? '',
        userId: json['userId']?.toString() ?? '',
        isTyping: json['isTyping'] == true,
      );
}

class ReadReceiptEvent {
  final String conversationId;
  final String userId;

  const ReadReceiptEvent(
      {required this.conversationId, required this.userId});

  factory ReadReceiptEvent.fromJson(Map<String, dynamic> json) =>
      ReadReceiptEvent(
        conversationId: json['conversationId']?.toString() ?? '',
        userId: json['userId']?.toString() ?? '',
      );
}

class NewMessageEvent {
  final String conversationId;
  final MessageModel message;

  const NewMessageEvent(
      {required this.conversationId, required this.message});

  factory NewMessageEvent.fromJson(Map<String, dynamic> json) =>
      NewMessageEvent(
        conversationId: json['conversationId']?.toString() ?? '',
        message: MessageModel.fromJson(
            Map<String, dynamic>.from(json['message'])),
      );
}

class MessagingNotificationEvent {
  final String conversationId;
  final String? messageId;
  final String? residenceId;

  const MessagingNotificationEvent({
    required this.conversationId,
    this.messageId,
    this.residenceId,
  });

  factory MessagingNotificationEvent.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'])
        : <String, dynamic>{};
    return MessagingNotificationEvent(
      conversationId: data['conversationId']?.toString() ?? '',
      messageId: data['messageId']?.toString(),
      residenceId: data['residenceId']?.toString(),
    );
  }
}

/// Erreur d'ACK `send_message`. `code` n'est présent que pour un rejet de
/// modération (`CONTACT_INFO_DETECTED`) ; les autres échecs (conversation
/// bloquée, message vide, accès refusé...) n'ont que `message`.
class SendMessageAckError {
  final String? code;
  final String? moderationReason;
  final String message;

  const SendMessageAckError({
    this.code,
    this.moderationReason,
    required this.message,
  });

  bool get isModeration => code == 'CONTACT_INFO_DETECTED';

  factory SendMessageAckError.fromJson(Map<String, dynamic> json) =>
      SendMessageAckError(
        code: json['code']?.toString(),
        moderationReason: json['moderationReason']?.toString(),
        message: json['message']?.toString() ??
            'Le message n\'a pas pu être envoyé.',
      );
}

class SendMessageAckResult {
  final bool ok;
  final MessageModel? message;
  final SendMessageAckError? error;
  final String? clientTempId;

  const SendMessageAckResult({
    required this.ok,
    this.message,
    this.error,
    this.clientTempId,
  });

  factory SendMessageAckResult.fromJson(Map<String, dynamic> json) {
    final ok = json['ok'] == true;
    return SendMessageAckResult(
      ok: ok,
      message: ok && json['message'] is Map
          ? MessageModel.fromJson(Map<String, dynamic>.from(json['message']))
          : null,
      error: !ok && json['error'] is Map
          ? SendMessageAckError.fromJson(
              Map<String, dynamic>.from(json['error']))
          : null,
      clientTempId: json['clientTempId']?.toString(),
    );
  }
}

/// Client Socket.io pour le canal temps réel de la messagerie.
@lazySingleton
class MessagingSocketService {
  socket_io.Socket? _socket;

  final _messageNewController = StreamController<NewMessageEvent>.broadcast();
  Stream<NewMessageEvent> get onMessageNew => _messageNewController.stream;

  final _typingController = StreamController<TypingEvent>.broadcast();
  Stream<TypingEvent> get onTyping => _typingController.stream;

  final _presenceController = StreamController<PresenceEvent>.broadcast();
  Stream<PresenceEvent> get onPresence => _presenceController.stream;

  final _readReceiptController =
      StreamController<ReadReceiptEvent>.broadcast();
  Stream<ReadReceiptEvent> get onReadReceipt => _readReceiptController.stream;

  final _notificationController =
      StreamController<MessagingNotificationEvent>.broadcast();
  Stream<MessagingNotificationEvent> get onNotificationNew =>
      _notificationController.stream;

  /// Émis à chaque connexion établie, y compris les reconnexions — pas
  /// seulement la toute première. Une room Socket.IO est attachée au
  /// `socket.id` de la connexion : une reconnexion (perte réseau, retour
  /// d'arrière-plan) en crée un nouveau et sort donc silencieusement le
  /// client de toute room `conversation:*` rejointe avant. Les écrans avec
  /// un fil ouvert écoutent ce flux pour ré-émettre `join_conversation`.
  final _connectedController = StreamController<void>.broadcast();
  Stream<void> get onConnected => _connectedController.stream;

  bool get isConnected => _socket?.connected ?? false;

  /// Ouvre (ou rouvre) la connexion avec le token courant.
  void connect() {
    final token = SessionManager().currentUser?.accessToken;
    if (token == null || token.isEmpty) {
      log('Pas de token, connexion annulée', name: 'MESSAGING_SOCKET');
      return;
    }

    disconnect();

    final socket = socket_io.io(
      '${RequestPath.baseUrl}/messages',
      socket_io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .enableReconnection()
          .build(),
    );

    socket.onConnect((_) {
      log('Connecté', name: 'MESSAGING_SOCKET');
      _connectedController.add(null);
    });
    socket.onDisconnect(
        (reason) => log('Déconnecté: $reason', name: 'MESSAGING_SOCKET'));
    socket.onConnectError(
        (err) => log('Erreur de connexion: $err', name: 'MESSAGING_SOCKET'));

    socket.on('message_new', (data) {
      if (data is Map) {
        try {
          _messageNewController.add(
              NewMessageEvent.fromJson(Map<String, dynamic>.from(data)));
        } catch (e) {
          log('Erreur parsing message_new: $e', name: 'MESSAGING_SOCKET');
        }
      }
    });

    socket.on('typing', (data) {
      if (data is Map) {
        try {
          _typingController
              .add(TypingEvent.fromJson(Map<String, dynamic>.from(data)));
        } catch (e) {
          log('Erreur parsing typing: $e', name: 'MESSAGING_SOCKET');
        }
      }
    });

    socket.on('presence', (data) {
      if (data is Map) {
        try {
          _presenceController
              .add(PresenceEvent.fromJson(Map<String, dynamic>.from(data)));
        } catch (e) {
          log('Erreur parsing presence: $e', name: 'MESSAGING_SOCKET');
        }
      }
    });

    socket.on('read_receipt', (data) {
      if (data is Map) {
        try {
          _readReceiptController.add(
              ReadReceiptEvent.fromJson(Map<String, dynamic>.from(data)));
        } catch (e) {
          log('Erreur parsing read_receipt: $e', name: 'MESSAGING_SOCKET');
        }
      }
    });

    socket.on('notification_new', (data) {
      if (data is Map) {
        try {
          _notificationController.add(MessagingNotificationEvent.fromJson(
              Map<String, dynamic>.from(data)));
        } catch (e) {
          log('Erreur parsing notification_new: $e',
              name: 'MESSAGING_SOCKET');
        }
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

  /// Rejoint la room du fil ; l'ACK donne le snapshot initial de présence du
  /// client. À appeler au montage de l'écran de fil, avant toute écoute
  /// `presence` (qui ne donne que les mises à jour live ensuite).
  Future<PeerPresence?> joinConversation(String conversationId) async {
    final socket = _socket;
    if (socket == null || !socket.connected) return null;
    try {
      final ack = await socket
          .emitWithAckAsync(
              'join_conversation', {'conversationId': conversationId})
          .timeout(const Duration(seconds: 8));
      if (ack is Map && ack['ok'] == true && ack['peer'] is Map) {
        return PeerPresence.fromJson(Map<String, dynamic>.from(ack['peer']));
      }
      return null;
    } catch (e) {
      log('join_conversation échoué: $e', name: 'MESSAGING_SOCKET');
      return null;
    }
  }

  /// Pas requis par le serveur, mais évite de rester membre de la room
  /// au-delà de la durée d'affichage réelle du fil — hygiène uniquement.
  void leaveConversation(String conversationId) {
    final socket = _socket;
    if (socket == null || !socket.connected) return;
    socket.emit('leave_conversation', {'conversationId': conversationId});
  }

  void emitTyping(String conversationId, bool isTyping) {
    final socket = _socket;
    if (socket == null || !socket.connected) return;
    socket.emit(
        'typing', {'conversationId': conversationId, 'isTyping': isTyping});
  }

  /// Envoi optimiste via socket. Lève une exception si aucun ACK n'arrive —
  /// l'appelant doit alors basculer sur le fallback HTTP.
  Future<SendMessageAckResult> sendMessage({
    required String conversationId,
    required String content,
    required String clientTempId,
  }) async {
    final socket = _socket;
    if (socket == null || !socket.connected) {
      throw StateError('Socket non connecté');
    }
    final ack = await socket.emitWithAckAsync('send_message', {
      'conversationId': conversationId,
      'content': content,
      'clientTempId': clientTempId,
    }).timeout(const Duration(seconds: 8));
    return SendMessageAckResult.fromJson(
        Map<String, dynamic>.from(ack as Map));
  }
}
