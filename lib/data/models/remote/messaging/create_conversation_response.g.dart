// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_conversation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreateConversationResponseImpl _$$CreateConversationResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateConversationResponseImpl(
      conversation: ConversationModel.fromJson(
          json['conversation'] as Map<String, dynamic>),
      message: MessageModel.fromJson(json['message'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CreateConversationResponseImplToJson(
        _$CreateConversationResponseImpl instance) =>
    <String, dynamic>{
      'conversation': instance.conversation,
      'message': instance.message,
    };
