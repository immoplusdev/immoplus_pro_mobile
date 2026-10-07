// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'submit_motif_echec_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SubmitMotifEchecPayload _$SubmitMotifEchecPayloadFromJson(
    Map<String, dynamic> json) {
  return _SubmitMotifEchecPayload.fromJson(json);
}

/// @nodoc
mixin _$SubmitMotifEchecPayload {
  String get reasonCode => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;

  /// Serializes this SubmitMotifEchecPayload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubmitMotifEchecPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubmitMotifEchecPayloadCopyWith<SubmitMotifEchecPayload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubmitMotifEchecPayloadCopyWith<$Res> {
  factory $SubmitMotifEchecPayloadCopyWith(SubmitMotifEchecPayload value,
          $Res Function(SubmitMotifEchecPayload) then) =
      _$SubmitMotifEchecPayloadCopyWithImpl<$Res, SubmitMotifEchecPayload>;
  @useResult
  $Res call({String reasonCode, String? comment});
}

/// @nodoc
class _$SubmitMotifEchecPayloadCopyWithImpl<$Res,
        $Val extends SubmitMotifEchecPayload>
    implements $SubmitMotifEchecPayloadCopyWith<$Res> {
  _$SubmitMotifEchecPayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubmitMotifEchecPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reasonCode = null,
    Object? comment = freezed,
  }) {
    return _then(_value.copyWith(
      reasonCode: null == reasonCode
          ? _value.reasonCode
          : reasonCode // ignore: cast_nullable_to_non_nullable
              as String,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SubmitMotifEchecPayloadImplCopyWith<$Res>
    implements $SubmitMotifEchecPayloadCopyWith<$Res> {
  factory _$$SubmitMotifEchecPayloadImplCopyWith(
          _$SubmitMotifEchecPayloadImpl value,
          $Res Function(_$SubmitMotifEchecPayloadImpl) then) =
      __$$SubmitMotifEchecPayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String reasonCode, String? comment});
}

/// @nodoc
class __$$SubmitMotifEchecPayloadImplCopyWithImpl<$Res>
    extends _$SubmitMotifEchecPayloadCopyWithImpl<$Res,
        _$SubmitMotifEchecPayloadImpl>
    implements _$$SubmitMotifEchecPayloadImplCopyWith<$Res> {
  __$$SubmitMotifEchecPayloadImplCopyWithImpl(
      _$SubmitMotifEchecPayloadImpl _value,
      $Res Function(_$SubmitMotifEchecPayloadImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubmitMotifEchecPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reasonCode = null,
    Object? comment = freezed,
  }) {
    return _then(_$SubmitMotifEchecPayloadImpl(
      reasonCode: null == reasonCode
          ? _value.reasonCode
          : reasonCode // ignore: cast_nullable_to_non_nullable
              as String,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubmitMotifEchecPayloadImpl implements _SubmitMotifEchecPayload {
  const _$SubmitMotifEchecPayloadImpl({required this.reasonCode, this.comment});

  factory _$SubmitMotifEchecPayloadImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubmitMotifEchecPayloadImplFromJson(json);

  @override
  final String reasonCode;
  @override
  final String? comment;

  @override
  String toString() {
    return 'SubmitMotifEchecPayload(reasonCode: $reasonCode, comment: $comment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubmitMotifEchecPayloadImpl &&
            (identical(other.reasonCode, reasonCode) ||
                other.reasonCode == reasonCode) &&
            (identical(other.comment, comment) || other.comment == comment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, reasonCode, comment);

  /// Create a copy of SubmitMotifEchecPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubmitMotifEchecPayloadImplCopyWith<_$SubmitMotifEchecPayloadImpl>
      get copyWith => __$$SubmitMotifEchecPayloadImplCopyWithImpl<
          _$SubmitMotifEchecPayloadImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubmitMotifEchecPayloadImplToJson(
      this,
    );
  }
}

abstract class _SubmitMotifEchecPayload implements SubmitMotifEchecPayload {
  const factory _SubmitMotifEchecPayload(
      {required final String reasonCode,
      final String? comment}) = _$SubmitMotifEchecPayloadImpl;

  factory _SubmitMotifEchecPayload.fromJson(Map<String, dynamic> json) =
      _$SubmitMotifEchecPayloadImpl.fromJson;

  @override
  String get reasonCode;
  @override
  String? get comment;

  /// Create a copy of SubmitMotifEchecPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubmitMotifEchecPayloadImplCopyWith<_$SubmitMotifEchecPayloadImpl>
      get copyWith => throw _privateConstructorUsedError;
}
