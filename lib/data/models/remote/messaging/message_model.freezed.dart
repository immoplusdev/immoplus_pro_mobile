// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) {
  return _MessageModel.fromJson(json);
}

/// @nodoc
mixin _$MessageModel {
  String get id => throw _privateConstructorUsedError;
  String get conversationId => throw _privateConstructorUsedError;
  String? get senderId => throw _privateConstructorUsedError;
  String get senderRole => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String? get moderationStatus => throw _privateConstructorUsedError;
  DateTime? get readAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Id temporaire côté client (envoi optimiste), jamais renvoyé par
  /// l'API — sert uniquement à réconcilier la bulle locale avec la
  /// version confirmée par le serveur (`message_new`/ACK `send_message`).
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get clientTempId => throw _privateConstructorUsedError;

  /// État d'envoi purement local : sending/sent/failed. Absent du JSON —
  /// jamais renvoyé par le backend.
  @JsonKey(includeFromJson: false, includeToJson: false)
  MessageDeliveryState get deliveryState => throw _privateConstructorUsedError;

  /// Serializes this MessageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageModelCopyWith<MessageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageModelCopyWith<$Res> {
  factory $MessageModelCopyWith(
          MessageModel value, $Res Function(MessageModel) then) =
      _$MessageModelCopyWithImpl<$Res, MessageModel>;
  @useResult
  $Res call(
      {String id,
      String conversationId,
      String? senderId,
      String senderRole,
      String type,
      String content,
      String? moderationStatus,
      DateTime? readAt,
      DateTime? createdAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      String? clientTempId,
      @JsonKey(includeFromJson: false, includeToJson: false)
      MessageDeliveryState deliveryState});
}

/// @nodoc
class _$MessageModelCopyWithImpl<$Res, $Val extends MessageModel>
    implements $MessageModelCopyWith<$Res> {
  _$MessageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? senderId = freezed,
    Object? senderRole = null,
    Object? type = null,
    Object? content = null,
    Object? moderationStatus = freezed,
    Object? readAt = freezed,
    Object? createdAt = freezed,
    Object? clientTempId = freezed,
    Object? deliveryState = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: freezed == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String?,
      senderRole: null == senderRole
          ? _value.senderRole
          : senderRole // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      moderationStatus: freezed == moderationStatus
          ? _value.moderationStatus
          : moderationStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      clientTempId: freezed == clientTempId
          ? _value.clientTempId
          : clientTempId // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryState: null == deliveryState
          ? _value.deliveryState
          : deliveryState // ignore: cast_nullable_to_non_nullable
              as MessageDeliveryState,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageModelImplCopyWith<$Res>
    implements $MessageModelCopyWith<$Res> {
  factory _$$MessageModelImplCopyWith(
          _$MessageModelImpl value, $Res Function(_$MessageModelImpl) then) =
      __$$MessageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String conversationId,
      String? senderId,
      String senderRole,
      String type,
      String content,
      String? moderationStatus,
      DateTime? readAt,
      DateTime? createdAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      String? clientTempId,
      @JsonKey(includeFromJson: false, includeToJson: false)
      MessageDeliveryState deliveryState});
}

/// @nodoc
class __$$MessageModelImplCopyWithImpl<$Res>
    extends _$MessageModelCopyWithImpl<$Res, _$MessageModelImpl>
    implements _$$MessageModelImplCopyWith<$Res> {
  __$$MessageModelImplCopyWithImpl(
      _$MessageModelImpl _value, $Res Function(_$MessageModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationId = null,
    Object? senderId = freezed,
    Object? senderRole = null,
    Object? type = null,
    Object? content = null,
    Object? moderationStatus = freezed,
    Object? readAt = freezed,
    Object? createdAt = freezed,
    Object? clientTempId = freezed,
    Object? deliveryState = null,
  }) {
    return _then(_$MessageModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conversationId: null == conversationId
          ? _value.conversationId
          : conversationId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: freezed == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String?,
      senderRole: null == senderRole
          ? _value.senderRole
          : senderRole // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      moderationStatus: freezed == moderationStatus
          ? _value.moderationStatus
          : moderationStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      clientTempId: freezed == clientTempId
          ? _value.clientTempId
          : clientTempId // ignore: cast_nullable_to_non_nullable
              as String?,
      deliveryState: null == deliveryState
          ? _value.deliveryState
          : deliveryState // ignore: cast_nullable_to_non_nullable
              as MessageDeliveryState,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageModelImpl extends _MessageModel {
  const _$MessageModelImpl(
      {required this.id,
      required this.conversationId,
      this.senderId,
      this.senderRole = 'client',
      this.type = 'text',
      required this.content,
      this.moderationStatus,
      this.readAt,
      this.createdAt,
      @JsonKey(includeFromJson: false, includeToJson: false) this.clientTempId,
      @JsonKey(includeFromJson: false, includeToJson: false)
      this.deliveryState = MessageDeliveryState.sent})
      : super._();

  factory _$MessageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageModelImplFromJson(json);

  @override
  final String id;
  @override
  final String conversationId;
  @override
  final String? senderId;
  @override
  @JsonKey()
  final String senderRole;
  @override
  @JsonKey()
  final String type;
  @override
  final String content;
  @override
  final String? moderationStatus;
  @override
  final DateTime? readAt;
  @override
  final DateTime? createdAt;

  /// Id temporaire côté client (envoi optimiste), jamais renvoyé par
  /// l'API — sert uniquement à réconcilier la bulle locale avec la
  /// version confirmée par le serveur (`message_new`/ACK `send_message`).
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? clientTempId;

  /// État d'envoi purement local : sending/sent/failed. Absent du JSON —
  /// jamais renvoyé par le backend.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final MessageDeliveryState deliveryState;

  @override
  String toString() {
    return 'MessageModel(id: $id, conversationId: $conversationId, senderId: $senderId, senderRole: $senderRole, type: $type, content: $content, moderationStatus: $moderationStatus, readAt: $readAt, createdAt: $createdAt, clientTempId: $clientTempId, deliveryState: $deliveryState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationId, conversationId) ||
                other.conversationId == conversationId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.senderRole, senderRole) ||
                other.senderRole == senderRole) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.moderationStatus, moderationStatus) ||
                other.moderationStatus == moderationStatus) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.clientTempId, clientTempId) ||
                other.clientTempId == clientTempId) &&
            (identical(other.deliveryState, deliveryState) ||
                other.deliveryState == deliveryState));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      conversationId,
      senderId,
      senderRole,
      type,
      content,
      moderationStatus,
      readAt,
      createdAt,
      clientTempId,
      deliveryState);

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      __$$MessageModelImplCopyWithImpl<_$MessageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageModelImplToJson(
      this,
    );
  }
}

abstract class _MessageModel extends MessageModel {
  const factory _MessageModel(
      {required final String id,
      required final String conversationId,
      final String? senderId,
      final String senderRole,
      final String type,
      required final String content,
      final String? moderationStatus,
      final DateTime? readAt,
      final DateTime? createdAt,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final String? clientTempId,
      @JsonKey(includeFromJson: false, includeToJson: false)
      final MessageDeliveryState deliveryState}) = _$MessageModelImpl;
  const _MessageModel._() : super._();

  factory _MessageModel.fromJson(Map<String, dynamic> json) =
      _$MessageModelImpl.fromJson;

  @override
  String get id;
  @override
  String get conversationId;
  @override
  String? get senderId;
  @override
  String get senderRole;
  @override
  String get type;
  @override
  String get content;
  @override
  String? get moderationStatus;
  @override
  DateTime? get readAt;
  @override
  DateTime? get createdAt;

  /// Id temporaire côté client (envoi optimiste), jamais renvoyé par
  /// l'API — sert uniquement à réconcilier la bulle locale avec la
  /// version confirmée par le serveur (`message_new`/ACK `send_message`).
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  String? get clientTempId;

  /// État d'envoi purement local : sending/sent/failed. Absent du JSON —
  /// jamais renvoyé par le backend.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  MessageDeliveryState get deliveryState;

  /// Create a copy of MessageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
