import 'package:freezed_annotation/freezed_annotation.dart';

import 'conversation_model.dart';
import 'message_model.dart';

part 'create_conversation_response.freezed.dart';
part 'create_conversation_response.g.dart';

/// Réponse de `POST /conversations/support` (`201` nouveau fil ou `200` fil
/// repris).
// This is an API response DTO. Its nested models retain non-serialized local
// metadata, so this response is intentionally deserialized only.
@Freezed(toJson: false)
class CreateConversationResponse with _$CreateConversationResponse {
  const factory CreateConversationResponse({
    required ConversationModel conversation,
    required MessageModel message,
  }) = _CreateConversationResponse;

  factory CreateConversationResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateConversationResponseFromJson(json);
}
