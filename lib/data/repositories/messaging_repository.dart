import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/data/models/remote/messaging/conversation_model.dart';
import 'package:immoplus_pro/data/models/remote/messaging/conversation_type_count.dart';
import 'package:immoplus_pro/data/models/remote/messaging/create_conversation_response.dart';
import 'package:immoplus_pro/data/models/remote/messaging/message_model.dart';
import 'package:immoplus_pro/data/providers/messaging_provider.dart';

class MessagingRepository {
  static MessagingProvider get _provider =>
      MessagingProvider(DioClient().dio);

  /// `POST /conversations/support` — get-or-create automatique.
  static Future<CreateConversationResponse> createSupportConversation({
    required String message,
  }) async {
    try {
      return await _provider.createSupportConversation({'message': message});
    } on DioException catch (e) {
      // Rethrown (pas wrappé) : l'appelant a besoin du statusCode/body bruts
      // pour distinguer CONTACT_INFO_DETECTED des autres erreurs.
      log('DioError createSupportConversation: ${e.message}');
      rethrow;
    } catch (e) {
      log('Error createSupportConversation: $e');
      throw Exception('Failed to create support conversation: $e');
    }
  }

  static Future<List<ConversationModel>> getConversations({
    ConversationType? type,
  }) async {
    try {
      return await _provider.getConversations(type: type?.value);
    } on DioException catch (e) {
      log('DioError getConversations: ${e.message}');
      throw Exception('Erreur chargement conversations: ${e.message}');
    } catch (e) {
      log('Error getConversations: $e');
      throw Exception('Erreur chargement conversations: $e');
    }
  }

  /// Un calcul serveur par type, pas de ligne "toutes" (à sommer côté front
  /// pour le badge de l'onglet Messages).
  static Future<List<ConversationTypeCount>> getConversationCounts() async {
    try {
      return await _provider.getConversationCounts();
    } on DioException catch (e) {
      log('DioError getConversationCounts: ${e.message}');
      throw Exception('Erreur chargement compteurs: ${e.message}');
    } catch (e) {
      log('Error getConversationCounts: $e');
      throw Exception('Erreur chargement compteurs: $e');
    }
  }

  static Future<ConversationModel> getConversation(
      String conversationId) async {
    try {
      return await _provider.getConversation(conversationId);
    } on DioException catch (e) {
      log('DioError getConversation: ${e.message}');
      rethrow;
    } catch (e) {
      log('Error getConversation: $e');
      throw Exception('Erreur chargement conversation: $e');
    }
  }

  static Future<List<MessageModel>> getMessages(
    String conversationId, {
    int limit = 30,
    String? before,
  }) async {
    try {
      final queryParams = <String, dynamic>{'limit': limit};
      if (before != null && before.isNotEmpty) {
        queryParams['before'] = before;
      }
      final res = await DioClient().dio.get(
        '/conversations/$conversationId/messages',
        queryParameters: queryParams,
      );
      final data = res.data;
      if (data is List) {
        return data
            .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException catch (e) {
      log('DioError getMessages: ${e.message}');
      throw Exception('Erreur chargement messages: ${e.message}');
    } catch (e) {
      log('Error getMessages: $e');
      throw Exception('Erreur chargement messages: $e');
    }
  }

  /// Fallback HTTP d'envoi (utilisé quand le socket est indisponible).
  static Future<MessageModel> sendMessageHttp(
    String conversationId, {
    required String content,
    required String clientTempId,
  }) async {
    try {
      return await _provider.sendMessage(
        conversationId,
        {
          'type': 'text',
          'content': content,
          'clientTempId': clientTempId,
        },
      );
    } on DioException catch (e) {
      // Rethrown : l'appelant distingue CONTACT_INFO_DETECTED des autres
      // échecs via e.response?.data['code'].
      log('DioError sendMessageHttp: ${e.message}');
      rethrow;
    } catch (e) {
      log('Error sendMessageHttp: $e');
      throw Exception('Erreur envoi message: $e');
    }
  }

  /// Envoi d'un message spécifique avec payload personnalisé (stay_proposal, choice_answer, etc.).
  static Future<MessageModel> sendCustomMessage(
    String conversationId,
    Map<String, dynamic> body,
  ) async {
    try {
      return await _provider.sendMessage(conversationId, body);
    } catch (e) {
      log('Error sendCustomMessage: $e');
      rethrow;
    }
  }

  /// `PATCH /conversations/:id/read` → `{ id, unreadCount }`.
  static Future<int> markRead(String conversationId) async {
    try {
      final response = await _provider.markRead(conversationId);
      final data = response.response.data;
      if (data is Map) {
        return (data['unreadCount'] as num?)?.toInt() ?? 0;
      }
      return 0;
    } on DioException catch (e) {
      log('DioError markRead: ${e.message}');
      throw Exception('Erreur marquage lu: ${e.message}');
    } catch (e) {
      log('Error markRead: $e');
      throw Exception('Erreur marquage lu: $e');
    }
  }

  static Future<void> blockConversation(String conversationId) async {
    try {
      await _provider.blockConversation(conversationId);
    } on DioException catch (e) {
      log('DioError blockConversation: ${e.message}');
      throw Exception('Erreur blocage conversation: ${e.message}');
    } catch (e) {
      log('Error blockConversation: $e');
      throw Exception('Erreur blocage conversation: $e');
    }
  }

  static Future<void> reportConversation(
    String conversationId, {
    required String reason,
    String? details,
  }) async {
    try {
      await _provider.reportConversation(
        conversationId,
        {
          'reason': reason,
          if (details != null && details.isNotEmpty) 'details': details,
        },
      );
    } on DioException catch (e) {
      log('DioError reportConversation: ${e.message}');
      throw Exception('Erreur signalement conversation: ${e.message}');
    } catch (e) {
      log('Error reportConversation: $e');
      throw Exception('Erreur signalement conversation: $e');
    }
  }

  /// Somme du non-lu sur les 4 types — alimente le badge de l'onglet
  /// Messages (`GET /conversations/counts` n'a pas de ligne "toutes").
  static Future<int> getTotalUnreadCount() async {
    try {
      final counts = await getConversationCounts();
      return counts.fold<int>(0, (total, c) => total + c.unread);
    } catch (e) {
      log('Error getTotalUnreadCount: $e');
      return 0;
    }
  }

  /// `POST /conversations/support/open` -> Ouvrir ou reprendre le parcours support guidé
  static Future<CreateConversationResponse> openSupportGuided() async {
    try {
      final res = await DioClient().dio.post('/conversations/support/open');
      return CreateConversationResponse.fromJson(res.data);
    } catch (e) {
      log('Error openSupportGuided: $e');
      rethrow;
    }
  }

  /// `GET /messaging/pro-guidance` — catalogue de suggestions métier côté pro.
  static Future<List<Map<String, dynamic>>> getProGuidance() async {
    try {
      final response = await DioClient().dio.get('/messaging/pro-guidance');
      final data = response.data;
      final rules = data is Map ? data['rules'] : null;
      if (rules is! List) return [];
      return rules
          .whereType<Map>()
          .map((rule) => Map<String, dynamic>.from(rule))
          .toList();
    } catch (e) {
      log('Error getProGuidance: $e');
      return [];
    }
  }

  /// `POST /reservations/action/accepter/:id`
  static Future<void> acceptReservation(String reservationId) async {
    try {
      await DioClient().dio.post('/reservations/action/accepter/$reservationId', data: {});
    } catch (e) {
      log('Error acceptReservation: $e');
      rethrow;
    }
  }

  /// `POST /reservations/action/refuser/:id`
  static Future<void> rejectReservation(String reservationId, {required String reasonCode, String? notes}) async {
    try {
      await DioClient().dio.post('/reservations/action/refuser/$reservationId', data: {
        'reasonCode': reasonCode,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      });
    } catch (e) {
      log('Error rejectReservation: $e');
      rethrow;
    }
  }

  /// `POST /reservations/action/valider-presence`
  static Future<Map<String, dynamic>> validatePresenceQr(String qrToken) async {
    try {
      final res = await DioClient().dio.post('/reservations/action/valider-presence', data: {
        'qrToken': qrToken,
      });
      final data = res.data;
      if (data is Map && data['data'] != null) {
        return Map<String, dynamic>.from(data['data']);
      }
      return Map<String, dynamic>.from(data ?? {});
    } catch (e) {
      log('Error validatePresenceQr: $e');
      rethrow;
    }
  }

  /// `PUT /residences/:residenceId/arrival-info`
  static Future<void> updateArrivalInfo(String residenceId, {String? accessInstructions, String? accessCode}) async {
    try {
      await DioClient().dio.put('/residences/$residenceId/arrival-info', data: {
        'accessInstructions': accessInstructions,
        'accessCode': accessCode,
      });
    } catch (e) {
      log('Error updateArrivalInfo: $e');
      rethrow;
    }
  }

  /// `POST /ratings/host`
  static Future<void> rateGuest({
    required String reservationId,
    required int clientRating,
    required String guestBehavior,
    required String propertyCondition,
    required bool wouldRecommend,
    String? clientFeedback,
    String? anyIssues,
  }) async {
    try {
      await DioClient().dio.post('/ratings/host', data: {
        'reservationId': reservationId,
        'clientRating': clientRating,
        'guestBehavior': guestBehavior,
        'propertyCondition': propertyCondition,
        'wouldRecommend': wouldRecommend,
        if (clientFeedback != null && clientFeedback.isNotEmpty) 'clientFeedback': clientFeedback,
        if (anyIssues != null && anyIssues.isNotEmpty) 'anyIssues': anyIssues,
      });
    } catch (e) {
      log('Error rateGuest: $e');
      rethrow;
    }
  }

  /// `POST /payments/action/create-demande-retrait-reservation`
  static Future<void> requestWithdrawal({
    required String reservationId,
    required String paymentMethod,
    required String paymentAddress,
  }) async {
    try {
      await DioClient().dio.post('/payments/action/create-demande-retrait-reservation', data: {
        'reservationId': reservationId,
        'paymentMethod': paymentMethod,
        'paymentAddress': paymentAddress,
      });
    } catch (e) {
      log('Error requestWithdrawal: $e');
      rethrow;
    }
  }

  /// `GET /messaging/settings`
  static Future<Map<String, dynamic>> getMessagingSettings() async {
    try {
      final res = await DioClient().dio.get('/messaging/settings');
      return Map<String, dynamic>.from(res.data);
    } catch (e) {
      log('Error getMessagingSettings: $e');
      return {'autoAvailabilityReply': false};
    }
  }

  /// `PUT /messaging/settings`
  static Future<void> updateMessagingSettings({bool? autoAvailabilityReply, String? absenceUntil}) async {
    try {
      await DioClient().dio.put('/messaging/settings', data: {
        if (autoAvailabilityReply != null) 'autoAvailabilityReply': autoAvailabilityReply,
        if (absenceUntil != null) 'absenceUntil': absenceUntil,
      });
    } catch (e) {
      log('Error updateMessagingSettings: $e');
      rethrow;
    }
  }

  /// `GET /messaging/quick-replies`
  static Future<List<String>> getQuickReplies() async {
    try {
      final res = await DioClient().dio.get('/messaging/quick-replies');
      final data = res.data;
      if (data is Map && data['labels'] is List) {
        return List<String>.from(data['labels']);
      } else if (data is List) {
        return List<String>.from(data);
      }
      return [
        'Bonjour, je vérifie ce point et je reviens vers vous.',
        'Merci pour votre message.',
      ];
    } catch (e) {
      log('Error getQuickReplies: $e');
      return [
        'Bonjour, je vérifie ce point et je reviens vers vous.',
        'Merci pour votre message.',
      ];
    }
  }

  /// `PUT /messaging/quick-replies`
  static Future<void> updateQuickReplies(List<String> labels) async {
    try {
      await DioClient().dio.put('/messaging/quick-replies', data: {'labels': labels});
    } catch (e) {
      log('Error updateQuickReplies: $e');
      rethrow;
    }
  }
}
