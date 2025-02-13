// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'withdraw_booking_history_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WithdrawBookingHistoryDto _$WithdrawBookingHistoryDtoFromJson(
    Map<String, dynamic> json) {
  return _WithdrawBookingHistoryDto.fromJson(json);
}

/// @nodoc
mixin _$WithdrawBookingHistoryDto {
  int get montantNonRetire => throw _privateConstructorUsedError;
  int get montantRetire => throw _privateConstructorUsedError;
  int get montantTotal => throw _privateConstructorUsedError;

  /// Serializes this WithdrawBookingHistoryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WithdrawBookingHistoryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WithdrawBookingHistoryDtoCopyWith<WithdrawBookingHistoryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WithdrawBookingHistoryDtoCopyWith<$Res> {
  factory $WithdrawBookingHistoryDtoCopyWith(WithdrawBookingHistoryDto value,
          $Res Function(WithdrawBookingHistoryDto) then) =
      _$WithdrawBookingHistoryDtoCopyWithImpl<$Res, WithdrawBookingHistoryDto>;
  @useResult
  $Res call({int montantNonRetire, int montantRetire, int montantTotal});
}

/// @nodoc
class _$WithdrawBookingHistoryDtoCopyWithImpl<$Res,
        $Val extends WithdrawBookingHistoryDto>
    implements $WithdrawBookingHistoryDtoCopyWith<$Res> {
  _$WithdrawBookingHistoryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WithdrawBookingHistoryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? montantNonRetire = null,
    Object? montantRetire = null,
    Object? montantTotal = null,
  }) {
    return _then(_value.copyWith(
      montantNonRetire: null == montantNonRetire
          ? _value.montantNonRetire
          : montantNonRetire // ignore: cast_nullable_to_non_nullable
              as int,
      montantRetire: null == montantRetire
          ? _value.montantRetire
          : montantRetire // ignore: cast_nullable_to_non_nullable
              as int,
      montantTotal: null == montantTotal
          ? _value.montantTotal
          : montantTotal // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WithdrawBookingHistoryDtoImplCopyWith<$Res>
    implements $WithdrawBookingHistoryDtoCopyWith<$Res> {
  factory _$$WithdrawBookingHistoryDtoImplCopyWith(
          _$WithdrawBookingHistoryDtoImpl value,
          $Res Function(_$WithdrawBookingHistoryDtoImpl) then) =
      __$$WithdrawBookingHistoryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int montantNonRetire, int montantRetire, int montantTotal});
}

/// @nodoc
class __$$WithdrawBookingHistoryDtoImplCopyWithImpl<$Res>
    extends _$WithdrawBookingHistoryDtoCopyWithImpl<$Res,
        _$WithdrawBookingHistoryDtoImpl>
    implements _$$WithdrawBookingHistoryDtoImplCopyWith<$Res> {
  __$$WithdrawBookingHistoryDtoImplCopyWithImpl(
      _$WithdrawBookingHistoryDtoImpl _value,
      $Res Function(_$WithdrawBookingHistoryDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of WithdrawBookingHistoryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? montantNonRetire = null,
    Object? montantRetire = null,
    Object? montantTotal = null,
  }) {
    return _then(_$WithdrawBookingHistoryDtoImpl(
      montantNonRetire: null == montantNonRetire
          ? _value.montantNonRetire
          : montantNonRetire // ignore: cast_nullable_to_non_nullable
              as int,
      montantRetire: null == montantRetire
          ? _value.montantRetire
          : montantRetire // ignore: cast_nullable_to_non_nullable
              as int,
      montantTotal: null == montantTotal
          ? _value.montantTotal
          : montantTotal // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WithdrawBookingHistoryDtoImpl implements _WithdrawBookingHistoryDto {
  const _$WithdrawBookingHistoryDtoImpl(
      {this.montantNonRetire = 0,
      this.montantRetire = 0,
      this.montantTotal = 0});

  factory _$WithdrawBookingHistoryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WithdrawBookingHistoryDtoImplFromJson(json);

  @override
  @JsonKey()
  final int montantNonRetire;
  @override
  @JsonKey()
  final int montantRetire;
  @override
  @JsonKey()
  final int montantTotal;

  @override
  String toString() {
    return 'WithdrawBookingHistoryDto(montantNonRetire: $montantNonRetire, montantRetire: $montantRetire, montantTotal: $montantTotal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WithdrawBookingHistoryDtoImpl &&
            (identical(other.montantNonRetire, montantNonRetire) ||
                other.montantNonRetire == montantNonRetire) &&
            (identical(other.montantRetire, montantRetire) ||
                other.montantRetire == montantRetire) &&
            (identical(other.montantTotal, montantTotal) ||
                other.montantTotal == montantTotal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, montantNonRetire, montantRetire, montantTotal);

  /// Create a copy of WithdrawBookingHistoryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WithdrawBookingHistoryDtoImplCopyWith<_$WithdrawBookingHistoryDtoImpl>
      get copyWith => __$$WithdrawBookingHistoryDtoImplCopyWithImpl<
          _$WithdrawBookingHistoryDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WithdrawBookingHistoryDtoImplToJson(
      this,
    );
  }
}

abstract class _WithdrawBookingHistoryDto implements WithdrawBookingHistoryDto {
  const factory _WithdrawBookingHistoryDto(
      {final int montantNonRetire,
      final int montantRetire,
      final int montantTotal}) = _$WithdrawBookingHistoryDtoImpl;

  factory _WithdrawBookingHistoryDto.fromJson(Map<String, dynamic> json) =
      _$WithdrawBookingHistoryDtoImpl.fromJson;

  @override
  int get montantNonRetire;
  @override
  int get montantRetire;
  @override
  int get montantTotal;

  /// Create a copy of WithdrawBookingHistoryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WithdrawBookingHistoryDtoImplCopyWith<_$WithdrawBookingHistoryDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
