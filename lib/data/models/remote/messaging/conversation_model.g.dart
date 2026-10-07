// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConversationModelImpl _$$ConversationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ConversationModelImpl(
      id: json['id'] as String,
      type: json['type'] as String? ?? 'reservation',
      residenceId: json['residenceId'] as String?,
      visiteId: json['visiteId'] as String?,
      proId: json['proId'] as String?,
      clientId: json['clientId'] as String,
      status: json['status'] as String? ?? 'active',
      unreadCountClient: (json['unreadCountClient'] as num?)?.toInt() ?? 0,
      unreadCountPro: (json['unreadCountPro'] as num?)?.toInt() ?? 0,
      lastMessagePreview: json['lastMessagePreview'] as String?,
      lastMessageAt: json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      stage: json['stage'] as String?,
      pendingActionFor:
          _readPendingActionFor(json, 'pendingActionFor') as String?,
      relaisId: _readRelaisId(json, 'relaisId') as String?,
      reservationId: _readReservationId(json, 'reservationId') as String?,
      actions: (json['actions'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      readOnly: _readReadOnly(json, 'readOnly') as bool? ?? false,
    );

Map<String, dynamic> _$$ConversationModelImplToJson(
        _$ConversationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'residenceId': instance.residenceId,
      'visiteId': instance.visiteId,
      'proId': instance.proId,
      'clientId': instance.clientId,
      'status': instance.status,
      'unreadCountClient': instance.unreadCountClient,
      'unreadCountPro': instance.unreadCountPro,
      'lastMessagePreview': instance.lastMessagePreview,
      'lastMessageAt': instance.lastMessageAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'stage': instance.stage,
      'pendingActionFor': instance.pendingActionFor,
      'relaisId': instance.relaisId,
      'reservationId': instance.reservationId,
      'actions': instance.actions,
      'readOnly': instance.readOnly,
    };
