// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConversationModel _$ConversationModelFromJson(Map<String, dynamic> json) {
  return _ConversationModel.fromJson(json);
}

/// @nodoc
mixin _$ConversationModel {
  String get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  /// Non-null seulement pour `type == reservation`.
  String? get residenceId => throw _privateConstructorUsedError;

  /// Non-null seulement pour `type == visite`.
  String? get visiteId => throw _privateConstructorUsedError;

  /// Toujours `null` pour `type == support` (boîte partagée, pas
  /// d'interlocuteur fixe).
  String? get proId => throw _privateConstructorUsedError;
  String get clientId => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int get unreadCountClient => throw _privateConstructorUsedError;
  int get unreadCountPro => throw _privateConstructorUsedError;
  String? get lastMessagePreview => throw _privateConstructorUsedError;
  DateTime? get lastMessageAt => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ConversationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationModelCopyWith<ConversationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationModelCopyWith<$Res> {
  factory $ConversationModelCopyWith(
          ConversationModel value, $Res Function(ConversationModel) then) =
      _$ConversationModelCopyWithImpl<$Res, ConversationModel>;
  @useResult
  $Res call(
      {String id,
      String type,
      String? residenceId,
      String? visiteId,
      String? proId,
      String clientId,
      String status,
      int unreadCountClient,
      int unreadCountPro,
      String? lastMessagePreview,
      DateTime? lastMessageAt,
      DateTime? createdAt});
}

/// @nodoc
class _$ConversationModelCopyWithImpl<$Res, $Val extends ConversationModel>
    implements $ConversationModelCopyWith<$Res> {
  _$ConversationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? residenceId = freezed,
    Object? visiteId = freezed,
    Object? proId = freezed,
    Object? clientId = null,
    Object? status = null,
    Object? unreadCountClient = null,
    Object? unreadCountPro = null,
    Object? lastMessagePreview = freezed,
    Object? lastMessageAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      residenceId: freezed == residenceId
          ? _value.residenceId
          : residenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      visiteId: freezed == visiteId
          ? _value.visiteId
          : visiteId // ignore: cast_nullable_to_non_nullable
              as String?,
      proId: freezed == proId
          ? _value.proId
          : proId // ignore: cast_nullable_to_non_nullable
              as String?,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      unreadCountClient: null == unreadCountClient
          ? _value.unreadCountClient
          : unreadCountClient // ignore: cast_nullable_to_non_nullable
              as int,
      unreadCountPro: null == unreadCountPro
          ? _value.unreadCountPro
          : unreadCountPro // ignore: cast_nullable_to_non_nullable
              as int,
      lastMessagePreview: freezed == lastMessagePreview
          ? _value.lastMessagePreview
          : lastMessagePreview // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationModelImplCopyWith<$Res>
    implements $ConversationModelCopyWith<$Res> {
  factory _$$ConversationModelImplCopyWith(_$ConversationModelImpl value,
          $Res Function(_$ConversationModelImpl) then) =
      __$$ConversationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      String? residenceId,
      String? visiteId,
      String? proId,
      String clientId,
      String status,
      int unreadCountClient,
      int unreadCountPro,
      String? lastMessagePreview,
      DateTime? lastMessageAt,
      DateTime? createdAt});
}

/// @nodoc
class __$$ConversationModelImplCopyWithImpl<$Res>
    extends _$ConversationModelCopyWithImpl<$Res, _$ConversationModelImpl>
    implements _$$ConversationModelImplCopyWith<$Res> {
  __$$ConversationModelImplCopyWithImpl(_$ConversationModelImpl _value,
      $Res Function(_$ConversationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? residenceId = freezed,
    Object? visiteId = freezed,
    Object? proId = freezed,
    Object? clientId = null,
    Object? status = null,
    Object? unreadCountClient = null,
    Object? unreadCountPro = null,
    Object? lastMessagePreview = freezed,
    Object? lastMessageAt = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$ConversationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      residenceId: freezed == residenceId
          ? _value.residenceId
          : residenceId // ignore: cast_nullable_to_non_nullable
              as String?,
      visiteId: freezed == visiteId
          ? _value.visiteId
          : visiteId // ignore: cast_nullable_to_non_nullable
              as String?,
      proId: freezed == proId
          ? _value.proId
          : proId // ignore: cast_nullable_to_non_nullable
              as String?,
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      unreadCountClient: null == unreadCountClient
          ? _value.unreadCountClient
          : unreadCountClient // ignore: cast_nullable_to_non_nullable
              as int,
      unreadCountPro: null == unreadCountPro
          ? _value.unreadCountPro
          : unreadCountPro // ignore: cast_nullable_to_non_nullable
              as int,
      lastMessagePreview: freezed == lastMessagePreview
          ? _value.lastMessagePreview
          : lastMessagePreview // ignore: cast_nullable_to_non_nullable
              as String?,
      lastMessageAt: freezed == lastMessageAt
          ? _value.lastMessageAt
          : lastMessageAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationModelImpl extends _ConversationModel {
  const _$ConversationModelImpl(
      {required this.id,
      this.type = 'reservation',
      this.residenceId,
      this.visiteId,
      this.proId,
      required this.clientId,
      this.status = 'active',
      this.unreadCountClient = 0,
      this.unreadCountPro = 0,
      this.lastMessagePreview,
      this.lastMessageAt,
      this.createdAt})
      : super._();

  factory _$ConversationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey()
  final String type;

  /// Non-null seulement pour `type == reservation`.
  @override
  final String? residenceId;

  /// Non-null seulement pour `type == visite`.
  @override
  final String? visiteId;

  /// Toujours `null` pour `type == support` (boîte partagée, pas
  /// d'interlocuteur fixe).
  @override
  final String? proId;
  @override
  final String clientId;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final int unreadCountClient;
  @override
  @JsonKey()
  final int unreadCountPro;
  @override
  final String? lastMessagePreview;
  @override
  final DateTime? lastMessageAt;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'ConversationModel(id: $id, type: $type, residenceId: $residenceId, visiteId: $visiteId, proId: $proId, clientId: $clientId, status: $status, unreadCountClient: $unreadCountClient, unreadCountPro: $unreadCountPro, lastMessagePreview: $lastMessagePreview, lastMessageAt: $lastMessageAt, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.residenceId, residenceId) ||
                other.residenceId == residenceId) &&
            (identical(other.visiteId, visiteId) ||
                other.visiteId == visiteId) &&
            (identical(other.proId, proId) || other.proId == proId) &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.unreadCountClient, unreadCountClient) ||
                other.unreadCountClient == unreadCountClient) &&
            (identical(other.unreadCountPro, unreadCountPro) ||
                other.unreadCountPro == unreadCountPro) &&
            (identical(other.lastMessagePreview, lastMessagePreview) ||
                other.lastMessagePreview == lastMessagePreview) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      residenceId,
      visiteId,
      proId,
      clientId,
      status,
      unreadCountClient,
      unreadCountPro,
      lastMessagePreview,
      lastMessageAt,
      createdAt);

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationModelImplCopyWith<_$ConversationModelImpl> get copyWith =>
      __$$ConversationModelImplCopyWithImpl<_$ConversationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationModelImplToJson(
      this,
    );
  }
}

abstract class _ConversationModel extends ConversationModel {
  const factory _ConversationModel(
      {required final String id,
      final String type,
      final String? residenceId,
      final String? visiteId,
      final String? proId,
      required final String clientId,
      final String status,
      final int unreadCountClient,
      final int unreadCountPro,
      final String? lastMessagePreview,
      final DateTime? lastMessageAt,
      final DateTime? createdAt}) = _$ConversationModelImpl;
  const _ConversationModel._() : super._();

  factory _ConversationModel.fromJson(Map<String, dynamic> json) =
      _$ConversationModelImpl.fromJson;

  @override
  String get id;
  @override
  String get type;

  /// Non-null seulement pour `type == reservation`.
  @override
  String? get residenceId;

  /// Non-null seulement pour `type == visite`.
  @override
  String? get visiteId;

  /// Toujours `null` pour `type == support` (boîte partagée, pas
  /// d'interlocuteur fixe).
  @override
  String? get proId;
  @override
  String get clientId;
  @override
  String get status;
  @override
  int get unreadCountClient;
  @override
  int get unreadCountPro;
  @override
  String? get lastMessagePreview;
  @override
  DateTime? get lastMessageAt;
  @override
  DateTime? get createdAt;

  /// Create a copy of ConversationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationModelImplCopyWith<_$ConversationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
