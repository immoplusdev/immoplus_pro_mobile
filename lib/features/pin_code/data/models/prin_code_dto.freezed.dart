// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prin_code_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PrinCodeDto _$PrinCodeDtoFromJson(Map<String, dynamic> json) {
  return _PrinCodeDto.fromJson(json);
}

/// @nodoc
mixin _$PrinCodeDto {
  String get pin => throw _privateConstructorUsedError;

  /// Serializes this PrinCodeDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PrinCodeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PrinCodeDtoCopyWith<PrinCodeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PrinCodeDtoCopyWith<$Res> {
  factory $PrinCodeDtoCopyWith(
          PrinCodeDto value, $Res Function(PrinCodeDto) then) =
      _$PrinCodeDtoCopyWithImpl<$Res, PrinCodeDto>;
  @useResult
  $Res call({String pin});
}

/// @nodoc
class _$PrinCodeDtoCopyWithImpl<$Res, $Val extends PrinCodeDto>
    implements $PrinCodeDtoCopyWith<$Res> {
  _$PrinCodeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PrinCodeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pin = null,
  }) {
    return _then(_value.copyWith(
      pin: null == pin
          ? _value.pin
          : pin // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PrinCodeDtoImplCopyWith<$Res>
    implements $PrinCodeDtoCopyWith<$Res> {
  factory _$$PrinCodeDtoImplCopyWith(
          _$PrinCodeDtoImpl value, $Res Function(_$PrinCodeDtoImpl) then) =
      __$$PrinCodeDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String pin});
}

/// @nodoc
class __$$PrinCodeDtoImplCopyWithImpl<$Res>
    extends _$PrinCodeDtoCopyWithImpl<$Res, _$PrinCodeDtoImpl>
    implements _$$PrinCodeDtoImplCopyWith<$Res> {
  __$$PrinCodeDtoImplCopyWithImpl(
      _$PrinCodeDtoImpl _value, $Res Function(_$PrinCodeDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of PrinCodeDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pin = null,
  }) {
    return _then(_$PrinCodeDtoImpl(
      pin: null == pin
          ? _value.pin
          : pin // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PrinCodeDtoImpl implements _PrinCodeDto {
  const _$PrinCodeDtoImpl({required this.pin});

  factory _$PrinCodeDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$PrinCodeDtoImplFromJson(json);

  @override
  final String pin;

  @override
  String toString() {
    return 'PrinCodeDto(pin: $pin)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PrinCodeDtoImpl &&
            (identical(other.pin, pin) || other.pin == pin));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, pin);

  /// Create a copy of PrinCodeDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PrinCodeDtoImplCopyWith<_$PrinCodeDtoImpl> get copyWith =>
      __$$PrinCodeDtoImplCopyWithImpl<_$PrinCodeDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PrinCodeDtoImplToJson(
      this,
    );
  }
}

abstract class _PrinCodeDto implements PrinCodeDto {
  const factory _PrinCodeDto({required final String pin}) = _$PrinCodeDtoImpl;

  factory _PrinCodeDto.fromJson(Map<String, dynamic> json) =
      _$PrinCodeDtoImpl.fromJson;

  @override
  String get pin;

  /// Create a copy of PrinCodeDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PrinCodeDtoImplCopyWith<_$PrinCodeDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
