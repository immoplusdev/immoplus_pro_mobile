// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verify_email_otp.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VerifyEmailOtp _$VerifyEmailOtpFromJson(Map<String, dynamic> json) {
  return _VerifyEmailOtp.fromJson(json);
}

/// @nodoc
mixin _$VerifyEmailOtp {
  String get email => throw _privateConstructorUsedError;
  String get otp => throw _privateConstructorUsedError;

  /// Serializes this VerifyEmailOtp to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VerifyEmailOtp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerifyEmailOtpCopyWith<VerifyEmailOtp> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerifyEmailOtpCopyWith<$Res> {
  factory $VerifyEmailOtpCopyWith(
          VerifyEmailOtp value, $Res Function(VerifyEmailOtp) then) =
      _$VerifyEmailOtpCopyWithImpl<$Res, VerifyEmailOtp>;
  @useResult
  $Res call({String email, String otp});
}

/// @nodoc
class _$VerifyEmailOtpCopyWithImpl<$Res, $Val extends VerifyEmailOtp>
    implements $VerifyEmailOtpCopyWith<$Res> {
  _$VerifyEmailOtpCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerifyEmailOtp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? otp = null,
  }) {
    return _then(_value.copyWith(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VerifyEmailOtpImplCopyWith<$Res>
    implements $VerifyEmailOtpCopyWith<$Res> {
  factory _$$VerifyEmailOtpImplCopyWith(_$VerifyEmailOtpImpl value,
          $Res Function(_$VerifyEmailOtpImpl) then) =
      __$$VerifyEmailOtpImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String email, String otp});
}

/// @nodoc
class __$$VerifyEmailOtpImplCopyWithImpl<$Res>
    extends _$VerifyEmailOtpCopyWithImpl<$Res, _$VerifyEmailOtpImpl>
    implements _$$VerifyEmailOtpImplCopyWith<$Res> {
  __$$VerifyEmailOtpImplCopyWithImpl(
      _$VerifyEmailOtpImpl _value, $Res Function(_$VerifyEmailOtpImpl) _then)
      : super(_value, _then);

  /// Create a copy of VerifyEmailOtp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? otp = null,
  }) {
    return _then(_$VerifyEmailOtpImpl(
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      otp: null == otp
          ? _value.otp
          : otp // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerifyEmailOtpImpl implements _VerifyEmailOtp {
  _$VerifyEmailOtpImpl({required this.email, required this.otp});

  factory _$VerifyEmailOtpImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerifyEmailOtpImplFromJson(json);

  @override
  final String email;
  @override
  final String otp;

  @override
  String toString() {
    return 'VerifyEmailOtp(email: $email, otp: $otp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyEmailOtpImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.otp, otp) || other.otp == otp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, email, otp);

  /// Create a copy of VerifyEmailOtp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyEmailOtpImplCopyWith<_$VerifyEmailOtpImpl> get copyWith =>
      __$$VerifyEmailOtpImplCopyWithImpl<_$VerifyEmailOtpImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerifyEmailOtpImplToJson(
      this,
    );
  }
}

abstract class _VerifyEmailOtp implements VerifyEmailOtp {
  factory _VerifyEmailOtp(
      {required final String email,
      required final String otp}) = _$VerifyEmailOtpImpl;

  factory _VerifyEmailOtp.fromJson(Map<String, dynamic> json) =
      _$VerifyEmailOtpImpl.fromJson;

  @override
  String get email;
  @override
  String get otp;

  /// Create a copy of VerifyEmailOtp
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerifyEmailOtpImplCopyWith<_$VerifyEmailOtpImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
