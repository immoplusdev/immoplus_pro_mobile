// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'crate_payement_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CratePayementRequestDto _$CratePayementRequestDtoFromJson(
    Map<String, dynamic> json) {
  return _CratePayementRequestDto.fromJson(json);
}

/// @nodoc
mixin _$CratePayementRequestDto {
  String get reservationId => throw _privateConstructorUsedError;
  String get paymentMethod => throw _privateConstructorUsedError;
  String get paymentAddress => throw _privateConstructorUsedError;

  /// Serializes this CratePayementRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CratePayementRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CratePayementRequestDtoCopyWith<CratePayementRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CratePayementRequestDtoCopyWith<$Res> {
  factory $CratePayementRequestDtoCopyWith(CratePayementRequestDto value,
          $Res Function(CratePayementRequestDto) then) =
      _$CratePayementRequestDtoCopyWithImpl<$Res, CratePayementRequestDto>;
  @useResult
  $Res call(
      {String reservationId, String paymentMethod, String paymentAddress});
}

/// @nodoc
class _$CratePayementRequestDtoCopyWithImpl<$Res,
        $Val extends CratePayementRequestDto>
    implements $CratePayementRequestDtoCopyWith<$Res> {
  _$CratePayementRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CratePayementRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reservationId = null,
    Object? paymentMethod = null,
    Object? paymentAddress = null,
  }) {
    return _then(_value.copyWith(
      reservationId: null == reservationId
          ? _value.reservationId
          : reservationId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      paymentAddress: null == paymentAddress
          ? _value.paymentAddress
          : paymentAddress // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CratePayementRequestDtoImplCopyWith<$Res>
    implements $CratePayementRequestDtoCopyWith<$Res> {
  factory _$$CratePayementRequestDtoImplCopyWith(
          _$CratePayementRequestDtoImpl value,
          $Res Function(_$CratePayementRequestDtoImpl) then) =
      __$$CratePayementRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String reservationId, String paymentMethod, String paymentAddress});
}

/// @nodoc
class __$$CratePayementRequestDtoImplCopyWithImpl<$Res>
    extends _$CratePayementRequestDtoCopyWithImpl<$Res,
        _$CratePayementRequestDtoImpl>
    implements _$$CratePayementRequestDtoImplCopyWith<$Res> {
  __$$CratePayementRequestDtoImplCopyWithImpl(
      _$CratePayementRequestDtoImpl _value,
      $Res Function(_$CratePayementRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CratePayementRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reservationId = null,
    Object? paymentMethod = null,
    Object? paymentAddress = null,
  }) {
    return _then(_$CratePayementRequestDtoImpl(
      reservationId: null == reservationId
          ? _value.reservationId
          : reservationId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      paymentAddress: null == paymentAddress
          ? _value.paymentAddress
          : paymentAddress // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CratePayementRequestDtoImpl implements _CratePayementRequestDto {
  _$CratePayementRequestDtoImpl(
      {required this.reservationId,
      required this.paymentMethod,
      required this.paymentAddress});

  factory _$CratePayementRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CratePayementRequestDtoImplFromJson(json);

  @override
  final String reservationId;
  @override
  final String paymentMethod;
  @override
  final String paymentAddress;

  @override
  String toString() {
    return 'CratePayementRequestDto(reservationId: $reservationId, paymentMethod: $paymentMethod, paymentAddress: $paymentAddress)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CratePayementRequestDtoImpl &&
            (identical(other.reservationId, reservationId) ||
                other.reservationId == reservationId) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.paymentAddress, paymentAddress) ||
                other.paymentAddress == paymentAddress));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, reservationId, paymentMethod, paymentAddress);

  /// Create a copy of CratePayementRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CratePayementRequestDtoImplCopyWith<_$CratePayementRequestDtoImpl>
      get copyWith => __$$CratePayementRequestDtoImplCopyWithImpl<
          _$CratePayementRequestDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CratePayementRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _CratePayementRequestDto implements CratePayementRequestDto {
  factory _CratePayementRequestDto(
      {required final String reservationId,
      required final String paymentMethod,
      required final String paymentAddress}) = _$CratePayementRequestDtoImpl;

  factory _CratePayementRequestDto.fromJson(Map<String, dynamic> json) =
      _$CratePayementRequestDtoImpl.fromJson;

  @override
  String get reservationId;
  @override
  String get paymentMethod;
  @override
  String get paymentAddress;

  /// Create a copy of CratePayementRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CratePayementRequestDtoImplCopyWith<_$CratePayementRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
