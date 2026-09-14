import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

import '../models/remote/messaging/conversation_model.dart';
import '../models/remote/messaging/conversation_type_count.dart';
import '../models/remote/messaging/create_conversation_response.dart';
import '../models/remote/messaging/message_model.dart';

part 'messaging_provider.g.dart';

@RestApi()
abstract class MessagingProvider {
  factory MessagingProvider(Dio dio, {String baseUrl}) = _MessagingProvider;

  /// Get-or-create automatique (un seul fil support actif par compte).
  /// Seul endpoint de création accessible côté Pro : il ne peut jamais
  /// initier un fil `reservation`/`visite`.
  @POST('/conversations/support')
  Future<CreateConversationResponse> createSupportConversation(
    @Body() Map<String, dynamic> body,
  );

  @GET('/conversations')
  Future<List<ConversationModel>> getConversations({
    @Query('type') String? type,
  });

  /// Pas de ligne "toutes" — à sommer côté front.
  @GET('/conversations/counts')
  Future<List<ConversationTypeCount>> getConversationCounts();

  @GET('/conversations/{conversationId}')
  Future<ConversationModel> getConversation(
    @Path('conversationId') String conversationId,
  );

  /// Toujours les `limit` derniers messages (plus récent en premier) : le
  /// backend n'a pas de paramètre de curseur.
  @GET('/conversations/{conversationId}/messages')
  Future<List<MessageModel>> getMessages(
    @Path('conversationId') String conversationId, {
    @Query('limit') int limit = 30,
  });

  /// Fallback HTTP d'envoi (le chemin nominal est le socket `send_message`).
  @POST('/conversations/{conversationId}/messages')
  Future<MessageModel> sendMessage(
    @Path('conversationId') String conversationId,
    @Body() Map<String, dynamic> body,
  );

  @PATCH('/conversations/{conversationId}/read')
  Future<HttpResponse> markRead(
    @Path('conversationId') String conversationId,
  );

  @PATCH('/conversations/{conversationId}/block')
  Future<HttpResponse> blockConversation(
    @Path('conversationId') String conversationId,
  );

  @POST('/conversations/{conversationId}/report')
  Future<HttpResponse> reportConversation(
    @Path('conversationId') String conversationId,
    @Body() Map<String, dynamic> body,
  );
}
