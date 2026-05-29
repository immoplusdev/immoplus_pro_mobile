// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verify_email_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VerifyEmailResponse _$VerifyEmailResponseFromJson(Map<String, dynamic> json) {
  return _VerifyEmailResponse.fromJson(json);
}

/// @nodoc
mixin _$VerifyEmailResponse {
  VerifyEmailData get data => throw _privateConstructorUsedError;

  /// Serializes this VerifyEmailResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VerifyEmailResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerifyEmailResponseCopyWith<VerifyEmailResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerifyEmailResponseCopyWith<$Res> {
  factory $VerifyEmailResponseCopyWith(
          VerifyEmailResponse value, $Res Function(VerifyEmailResponse) then) =
      _$VerifyEmailResponseCopyWithImpl<$Res, VerifyEmailResponse>;
  @useResult
  $Res call({VerifyEmailData data});

  $VerifyEmailDataCopyWith<$Res> get data;
}

/// @nodoc
class _$VerifyEmailResponseCopyWithImpl<$Res, $Val extends VerifyEmailResponse>
    implements $VerifyEmailResponseCopyWith<$Res> {
  _$VerifyEmailResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerifyEmailResponse
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
              as VerifyEmailData,
    ) as $Val);
  }

  /// Create a copy of VerifyEmailResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VerifyEmailDataCopyWith<$Res> get data {
    return $VerifyEmailDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VerifyEmailResponseImplCopyWith<$Res>
    implements $VerifyEmailResponseCopyWith<$Res> {
  factory _$$VerifyEmailResponseImplCopyWith(_$VerifyEmailResponseImpl value,
          $Res Function(_$VerifyEmailResponseImpl) then) =
      __$$VerifyEmailResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({VerifyEmailData data});

  @override
  $VerifyEmailDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$VerifyEmailResponseImplCopyWithImpl<$Res>
    extends _$VerifyEmailResponseCopyWithImpl<$Res, _$VerifyEmailResponseImpl>
    implements _$$VerifyEmailResponseImplCopyWith<$Res> {
  __$$VerifyEmailResponseImplCopyWithImpl(_$VerifyEmailResponseImpl _value,
      $Res Function(_$VerifyEmailResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of VerifyEmailResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$VerifyEmailResponseImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as VerifyEmailData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerifyEmailResponseImpl implements _VerifyEmailResponse {
  const _$VerifyEmailResponseImpl({required this.data});

  factory _$VerifyEmailResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerifyEmailResponseImplFromJson(json);

  @override
  final VerifyEmailData data;

  @override
  String toString() {
    return 'VerifyEmailResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyEmailResponseImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of VerifyEmailResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyEmailResponseImplCopyWith<_$VerifyEmailResponseImpl> get copyWith =>
      __$$VerifyEmailResponseImplCopyWithImpl<_$VerifyEmailResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerifyEmailResponseImplToJson(
      this,
    );
  }
}

abstract class _VerifyEmailResponse implements VerifyEmailResponse {
  const factory _VerifyEmailResponse({required final VerifyEmailData data}) =
      _$VerifyEmailResponseImpl;

  factory _VerifyEmailResponse.fromJson(Map<String, dynamic> json) =
      _$VerifyEmailResponseImpl.fromJson;

  @override
  VerifyEmailData get data;

  /// Create a copy of VerifyEmailResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerifyEmailResponseImplCopyWith<_$VerifyEmailResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VerifyEmailData _$VerifyEmailDataFromJson(Map<String, dynamic> json) {
  return _VerifyEmailData.fromJson(json);
}

/// @nodoc
mixin _$VerifyEmailData {
  bool? get success => throw _privateConstructorUsedError;
  String? get token => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;

  /// Serializes this VerifyEmailData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VerifyEmailData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VerifyEmailDataCopyWith<VerifyEmailData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VerifyEmailDataCopyWith<$Res> {
  factory $VerifyEmailDataCopyWith(
          VerifyEmailData value, $Res Function(VerifyEmailData) then) =
      _$VerifyEmailDataCopyWithImpl<$Res, VerifyEmailData>;
  @useResult
  $Res call({bool? success, String? token, String? email, String? phoneNumber});
}

/// @nodoc
class _$VerifyEmailDataCopyWithImpl<$Res, $Val extends VerifyEmailData>
    implements $VerifyEmailDataCopyWith<$Res> {
  _$VerifyEmailDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VerifyEmailData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = freezed,
    Object? token = freezed,
    Object? email = freezed,
    Object? phoneNumber = freezed,
  }) {
    return _then(_value.copyWith(
      success: freezed == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VerifyEmailDataImplCopyWith<$Res>
    implements $VerifyEmailDataCopyWith<$Res> {
  factory _$$VerifyEmailDataImplCopyWith(_$VerifyEmailDataImpl value,
          $Res Function(_$VerifyEmailDataImpl) then) =
      __$$VerifyEmailDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool? success, String? token, String? email, String? phoneNumber});
}

/// @nodoc
class __$$VerifyEmailDataImplCopyWithImpl<$Res>
    extends _$VerifyEmailDataCopyWithImpl<$Res, _$VerifyEmailDataImpl>
    implements _$$VerifyEmailDataImplCopyWith<$Res> {
  __$$VerifyEmailDataImplCopyWithImpl(
      _$VerifyEmailDataImpl _value, $Res Function(_$VerifyEmailDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of VerifyEmailData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? success = freezed,
    Object? token = freezed,
    Object? email = freezed,
    Object? phoneNumber = freezed,
  }) {
    return _then(_$VerifyEmailDataImpl(
      success: freezed == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VerifyEmailDataImpl implements _VerifyEmailData {
  const _$VerifyEmailDataImpl(
      {this.success = false,
      this.token = '',
      this.email = '',
      this.phoneNumber = ''});

  factory _$VerifyEmailDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$VerifyEmailDataImplFromJson(json);

  @override
  @JsonKey()
  final bool? success;
  @override
  @JsonKey()
  final String? token;
  @override
  @JsonKey()
  final String? email;
  @override
  @JsonKey()
  final String? phoneNumber;

  @override
  String toString() {
    return 'VerifyEmailData(success: $success, token: $token, email: $email, phoneNumber: $phoneNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VerifyEmailDataImpl &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, success, token, email, phoneNumber);

  /// Create a copy of VerifyEmailData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VerifyEmailDataImplCopyWith<_$VerifyEmailDataImpl> get copyWith =>
      __$$VerifyEmailDataImplCopyWithImpl<_$VerifyEmailDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VerifyEmailDataImplToJson(
      this,
    );
  }
}

abstract class _VerifyEmailData implements VerifyEmailData {
  const factory _VerifyEmailData(
      {final bool? success,
      final String? token,
      final String? email,
      final String? phoneNumber}) = _$VerifyEmailDataImpl;

  factory _VerifyEmailData.fromJson(Map<String, dynamic> json) =
      _$VerifyEmailDataImpl.fromJson;

  @override
  bool? get success;
  @override
  String? get token;
  @override
  String? get email;
  @override
  String? get phoneNumber;

  /// Create a copy of VerifyEmailData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VerifyEmailDataImplCopyWith<_$VerifyEmailDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
