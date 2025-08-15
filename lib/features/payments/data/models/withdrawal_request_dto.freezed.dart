// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'withdrawal_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WithdrawalRequestDto _$WithdrawalRequestDtoFromJson(Map<String, dynamic> json) {
  return _WithdrawalRequestDto.fromJson(json);
}

/// @nodoc
mixin _$WithdrawalRequestDto {
  int get amount => throw _privateConstructorUsedError;
  String get currency => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  String get operator => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;

  /// Serializes this WithdrawalRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WithdrawalRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WithdrawalRequestDtoCopyWith<WithdrawalRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WithdrawalRequestDtoCopyWith<$Res> {
  factory $WithdrawalRequestDtoCopyWith(WithdrawalRequestDto value,
          $Res Function(WithdrawalRequestDto) then) =
      _$WithdrawalRequestDtoCopyWithImpl<$Res, WithdrawalRequestDto>;
  @useResult
  $Res call(
      {int amount,
      String currency,
      String phoneNumber,
      String operator,
      String status,
      String? note});
}

/// @nodoc
class _$WithdrawalRequestDtoCopyWithImpl<$Res,
        $Val extends WithdrawalRequestDto>
    implements $WithdrawalRequestDtoCopyWith<$Res> {
  _$WithdrawalRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WithdrawalRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? currency = null,
    Object? phoneNumber = null,
    Object? operator = null,
    Object? status = null,
    Object? note = freezed,
  }) {
    return _then(_value.copyWith(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      operator: null == operator
          ? _value.operator
          : operator // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WithdrawalRequestDtoImplCopyWith<$Res>
    implements $WithdrawalRequestDtoCopyWith<$Res> {
  factory _$$WithdrawalRequestDtoImplCopyWith(_$WithdrawalRequestDtoImpl value,
          $Res Function(_$WithdrawalRequestDtoImpl) then) =
      __$$WithdrawalRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int amount,
      String currency,
      String phoneNumber,
      String operator,
      String status,
      String? note});
}

/// @nodoc
class __$$WithdrawalRequestDtoImplCopyWithImpl<$Res>
    extends _$WithdrawalRequestDtoCopyWithImpl<$Res, _$WithdrawalRequestDtoImpl>
    implements _$$WithdrawalRequestDtoImplCopyWith<$Res> {
  __$$WithdrawalRequestDtoImplCopyWithImpl(_$WithdrawalRequestDtoImpl _value,
      $Res Function(_$WithdrawalRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of WithdrawalRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? amount = null,
    Object? currency = null,
    Object? phoneNumber = null,
    Object? operator = null,
    Object? status = null,
    Object? note = freezed,
  }) {
    return _then(_$WithdrawalRequestDtoImpl(
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      operator: null == operator
          ? _value.operator
          : operator // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WithdrawalRequestDtoImpl implements _WithdrawalRequestDto {
  _$WithdrawalRequestDtoImpl(
      {required this.amount,
      required this.currency,
      required this.phoneNumber,
      required this.operator,
      required this.status,
      this.note});

  factory _$WithdrawalRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$WithdrawalRequestDtoImplFromJson(json);

  @override
  final int amount;
  @override
  final String currency;
  @override
  final String phoneNumber;
  @override
  final String operator;
  @override
  final String status;
  @override
  final String? note;

  @override
  String toString() {
    return 'WithdrawalRequestDto(amount: $amount, currency: $currency, phoneNumber: $phoneNumber, operator: $operator, status: $status, note: $note)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WithdrawalRequestDtoImpl &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.operator, operator) ||
                other.operator == operator) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, amount, currency, phoneNumber, operator, status, note);

  /// Create a copy of WithdrawalRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WithdrawalRequestDtoImplCopyWith<_$WithdrawalRequestDtoImpl>
      get copyWith =>
          __$$WithdrawalRequestDtoImplCopyWithImpl<_$WithdrawalRequestDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WithdrawalRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _WithdrawalRequestDto implements WithdrawalRequestDto {
  factory _WithdrawalRequestDto(
      {required final int amount,
      required final String currency,
      required final String phoneNumber,
      required final String operator,
      required final String status,
      final String? note}) = _$WithdrawalRequestDtoImpl;

  factory _WithdrawalRequestDto.fromJson(Map<String, dynamic> json) =
      _$WithdrawalRequestDtoImpl.fromJson;

  @override
  int get amount;
  @override
  String get currency;
  @override
  String get phoneNumber;
  @override
  String get operator;
  @override
  String get status;
  @override
  String? get note;

  /// Create a copy of WithdrawalRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WithdrawalRequestDtoImplCopyWith<_$WithdrawalRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
