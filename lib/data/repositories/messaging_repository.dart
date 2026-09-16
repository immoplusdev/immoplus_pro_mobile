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
  }) async {
    try {
      return await _provider.getMessages(conversationId, limit: limit);
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
        {'content': content, 'clientTempId': clientTempId},
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

  /// Somme du non-lu sur les 3 types — alimente le badge de l'onglet
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
}
