// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'motif_echec_reponse_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MotifEchecReponseModel _$MotifEchecReponseModelFromJson(
    Map<String, dynamic> json) {
  return _MotifEchecReponseModel.fromJson(json);
}

/// @nodoc
mixin _$MotifEchecReponseModel {
  MotifEchecReponseData get data => throw _privateConstructorUsedError;

  /// Serializes this MotifEchecReponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MotifEchecReponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MotifEchecReponseModelCopyWith<MotifEchecReponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MotifEchecReponseModelCopyWith<$Res> {
  factory $MotifEchecReponseModelCopyWith(MotifEchecReponseModel value,
          $Res Function(MotifEchecReponseModel) then) =
      _$MotifEchecReponseModelCopyWithImpl<$Res, MotifEchecReponseModel>;
  @useResult
  $Res call({MotifEchecReponseData data});

  $MotifEchecReponseDataCopyWith<$Res> get data;
}

/// @nodoc
class _$MotifEchecReponseModelCopyWithImpl<$Res,
        $Val extends MotifEchecReponseModel>
    implements $MotifEchecReponseModelCopyWith<$Res> {
  _$MotifEchecReponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MotifEchecReponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as MotifEchecReponseData,
    ) as $Val);
  }

  /// Create a copy of MotifEchecReponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MotifEchecReponseDataCopyWith<$Res> get data {
    return $MotifEchecReponseDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MotifEchecReponseModelImplCopyWith<$Res>
    implements $MotifEchecReponseModelCopyWith<$Res> {
  factory _$$MotifEchecReponseModelImplCopyWith(
          _$MotifEchecReponseModelImpl value,
          $Res Function(_$MotifEchecReponseModelImpl) then) =
      __$$MotifEchecReponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({MotifEchecReponseData data});

  @override
  $MotifEchecReponseDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$MotifEchecReponseModelImplCopyWithImpl<$Res>
    extends _$MotifEchecReponseModelCopyWithImpl<$Res,
        _$MotifEchecReponseModelImpl>
    implements _$$MotifEchecReponseModelImplCopyWith<$Res> {
  __$$MotifEchecReponseModelImplCopyWithImpl(
      _$MotifEchecReponseModelImpl _value,
      $Res Function(_$MotifEchecReponseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MotifEchecReponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$MotifEchecReponseModelImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as MotifEchecReponseData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MotifEchecReponseModelImpl implements _MotifEchecReponseModel {
  const _$MotifEchecReponseModelImpl({required this.data});

  factory _$MotifEchecReponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MotifEchecReponseModelImplFromJson(json);

  @override
  final MotifEchecReponseData data;

  @override
  String toString() {
    return 'MotifEchecReponseModel(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MotifEchecReponseModelImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of MotifEchecReponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MotifEchecReponseModelImplCopyWith<_$MotifEchecReponseModelImpl>
      get copyWith => __$$MotifEchecReponseModelImplCopyWithImpl<
          _$MotifEchecReponseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MotifEchecReponseModelImplToJson(
      this,
    );
  }
}

abstract class _MotifEchecReponseModel implements MotifEchecReponseModel {
  const factory _MotifEchecReponseModel(
          {required final MotifEchecReponseData data}) =
      _$MotifEchecReponseModelImpl;

  factory _MotifEchecReponseModel.fromJson(Map<String, dynamic> json) =
      _$MotifEchecReponseModelImpl.fromJson;

  @override
  MotifEchecReponseData get data;

  /// Create a copy of MotifEchecReponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MotifEchecReponseModelImplCopyWith<_$MotifEchecReponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}

MotifEchecReponseData _$MotifEchecReponseDataFromJson(
    Map<String, dynamic> json) {
  return _MotifEchecReponseData.fromJson(json);
}

/// @nodoc
mixin _$MotifEchecReponseData {
  String? get actor => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String get reasonCode => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  DateTime? get respondedAt => throw _privateConstructorUsedError;

  /// Serializes this MotifEchecReponseData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MotifEchecReponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MotifEchecReponseDataCopyWith<MotifEchecReponseData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MotifEchecReponseDataCopyWith<$Res> {
  factory $MotifEchecReponseDataCopyWith(MotifEchecReponseData value,
          $Res Function(MotifEchecReponseData) then) =
      _$MotifEchecReponseDataCopyWithImpl<$Res, MotifEchecReponseData>;
  @useResult
  $Res call(
      {String? actor,
      String? status,
      String reasonCode,
      String? comment,
      DateTime? respondedAt});
}

/// @nodoc
class _$MotifEchecReponseDataCopyWithImpl<$Res,
        $Val extends MotifEchecReponseData>
    implements $MotifEchecReponseDataCopyWith<$Res> {
  _$MotifEchecReponseDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MotifEchecReponseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? actor = freezed,
    Object? status = freezed,
    Object? reasonCode = null,
    Object? comment = freezed,
    Object? respondedAt = freezed,
  }) {
    return _then(_value.copyWith(
      actor: freezed == actor
          ? _value.actor
          : actor // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      reasonCode: null == reasonCode
          ? _value.reasonCode
          : reasonCode // ignore: cast_nullable_to_non_nullable
              as String,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MotifEchecReponseDataImplCopyWith<$Res>
    implements $MotifEchecReponseDataCopyWith<$Res> {
  factory _$$MotifEchecReponseDataImplCopyWith(
          _$MotifEchecReponseDataImpl value,
          $Res Function(_$MotifEchecReponseDataImpl) then) =
      __$$MotifEchecReponseDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? actor,
      String? status,
      String reasonCode,
      String? comment,
      DateTime? respondedAt});
}

/// @nodoc
class __$$MotifEchecReponseDataImplCopyWithImpl<$Res>
    extends _$MotifEchecReponseDataCopyWithImpl<$Res,
        _$MotifEchecReponseDataImpl>
    implements _$$MotifEchecReponseDataImplCopyWith<$Res> {
  __$$MotifEchecReponseDataImplCopyWithImpl(_$MotifEchecReponseDataImpl _value,
      $Res Function(_$MotifEchecReponseDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of MotifEchecReponseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? actor = freezed,
    Object? status = freezed,
    Object? reasonCode = null,
    Object? comment = freezed,
    Object? respondedAt = freezed,
  }) {
    return _then(_$MotifEchecReponseDataImpl(
      actor: freezed == actor
          ? _value.actor
          : actor // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      reasonCode: null == reasonCode
          ? _value.reasonCode
          : reasonCode // ignore: cast_nullable_to_non_nullable
              as String,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      respondedAt: freezed == respondedAt
          ? _value.respondedAt
          : respondedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MotifEchecReponseDataImpl implements _MotifEchecReponseData {
  const _$MotifEchecReponseDataImpl(
      {this.actor,
      this.status,
      required this.reasonCode,
      this.comment,
      this.respondedAt});

  factory _$MotifEchecReponseDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MotifEchecReponseDataImplFromJson(json);

  @override
  final String? actor;
  @override
  final String? status;
  @override
  final String reasonCode;
  @override
  final String? comment;
  @override
  final DateTime? respondedAt;

  @override
  String toString() {
    return 'MotifEchecReponseData(actor: $actor, status: $status, reasonCode: $reasonCode, comment: $comment, respondedAt: $respondedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MotifEchecReponseDataImpl &&
            (identical(other.actor, actor) || other.actor == actor) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.reasonCode, reasonCode) ||
                other.reasonCode == reasonCode) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.respondedAt, respondedAt) ||
                other.respondedAt == respondedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, actor, status, reasonCode, comment, respondedAt);

  /// Create a copy of MotifEchecReponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MotifEchecReponseDataImplCopyWith<_$MotifEchecReponseDataImpl>
      get copyWith => __$$MotifEchecReponseDataImplCopyWithImpl<
          _$MotifEchecReponseDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MotifEchecReponseDataImplToJson(
      this,
    );
  }
}

abstract class _MotifEchecReponseData implements MotifEchecReponseData {
  const factory _MotifEchecReponseData(
      {final String? actor,
      final String? status,
      required final String reasonCode,
      final String? comment,
      final DateTime? respondedAt}) = _$MotifEchecReponseDataImpl;

  factory _MotifEchecReponseData.fromJson(Map<String, dynamic> json) =
      _$MotifEchecReponseDataImpl.fromJson;

  @override
  String? get actor;
  @override
  String? get status;
  @override
  String get reasonCode;
  @override
  String? get comment;
  @override
  DateTime? get respondedAt;

  /// Create a copy of MotifEchecReponseData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MotifEchecReponseDataImplCopyWith<_$MotifEchecReponseDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
