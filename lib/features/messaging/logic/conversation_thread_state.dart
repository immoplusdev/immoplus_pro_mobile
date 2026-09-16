import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus_pro/data/models/remote/messaging/conversation_model.dart';
import 'package:immoplus_pro/data/models/remote/messaging/message_model.dart';
import 'package:immoplus_pro/services/messaging_socket_service.dart';

part 'conversation_thread_state.freezed.dart';

@freezed
class ConversationThreadState with _$ConversationThreadState {
  const factory ConversationThreadState.loading() = ConversationThreadLoading;

  /// [messages] est toujours chronologique (plus ancien en premier).
  const factory ConversationThreadState.loaded({
    required ConversationModel conversation,
    required List<MessageModel> messages,
    PeerPresence? peerPresence,
    @Default(false) bool peerTyping,
    DateTime? peerLastReadAt,
    String? moderationBannerMessage,
  }) = ConversationThreadLoaded;

  const factory ConversationThreadState.error(String message) =
      ConversationThreadError;
}
