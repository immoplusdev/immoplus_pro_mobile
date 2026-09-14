// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_type_count.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationTypeCountImpl _$$ConversationTypeCountImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationTypeCountImpl(
      type: json['type'] as String,
      total: (json['total'] as num?)?.toInt() ?? 0,
      unread: (json['unread'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$ConversationTypeCountImplToJson(
        _$ConversationTypeCountImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'total': instance.total,
      'unread': instance.unread,
    };
