// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_login_body.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SocialLoginBody _$SocialLoginBodyFromJson(Map<String, dynamic> json) {
  return _SocialLoginBody.fromJson(json);
}

/// @nodoc
mixin _$SocialLoginBody {
  String get provider =>
      throw _privateConstructorUsedError; // "google" ou "facebook"
  String get token => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;

  /// Serializes this SocialLoginBody to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SocialLoginBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SocialLoginBodyCopyWith<SocialLoginBody> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialLoginBodyCopyWith<$Res> {
  factory $SocialLoginBodyCopyWith(
          SocialLoginBody value, $Res Function(SocialLoginBody) then) =
      _$SocialLoginBodyCopyWithImpl<$Res, SocialLoginBody>;
  @useResult
  $Res call({String provider, String token, String email, String source});
}

/// @nodoc
class _$SocialLoginBodyCopyWithImpl<$Res, $Val extends SocialLoginBody>
    implements $SocialLoginBodyCopyWith<$Res> {
  _$SocialLoginBodyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SocialLoginBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? provider = null,
    Object? token = null,
    Object? email = null,
    Object? source = null,
  }) {
    return _then(_value.copyWith(
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SocialLoginBodyImplCopyWith<$Res>
    implements $SocialLoginBodyCopyWith<$Res> {
  factory _$$SocialLoginBodyImplCopyWith(_$SocialLoginBodyImpl value,
          $Res Function(_$SocialLoginBodyImpl) then) =
      __$$SocialLoginBodyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String provider, String token, String email, String source});
}

/// @nodoc
class __$$SocialLoginBodyImplCopyWithImpl<$Res>
    extends _$SocialLoginBodyCopyWithImpl<$Res, _$SocialLoginBodyImpl>
    implements _$$SocialLoginBodyImplCopyWith<$Res> {
  __$$SocialLoginBodyImplCopyWithImpl(
      _$SocialLoginBodyImpl _value, $Res Function(_$SocialLoginBodyImpl) _then)
      : super(_value, _then);

  /// Create a copy of SocialLoginBody
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? provider = null,
    Object? token = null,
    Object? email = null,
    Object? source = null,
  }) {
    return _then(_$SocialLoginBodyImpl(
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as String,
      token: null == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SocialLoginBodyImpl implements _SocialLoginBody {
  const _$SocialLoginBodyImpl(
      {required this.provider,
      required this.token,
      required this.email,
      required this.source});

  factory _$SocialLoginBodyImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialLoginBodyImplFromJson(json);

  @override
  final String provider;
// "google" ou "facebook"
  @override
  final String token;
  @override
  final String email;
  @override
  final String source;

  @override
  String toString() {
    return 'SocialLoginBody(provider: $provider, token: $token, email: $email, source: $source)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialLoginBodyImpl &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.source, source) || other.source == source));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, provider, token, email, source);

  /// Create a copy of SocialLoginBody
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialLoginBodyImplCopyWith<_$SocialLoginBodyImpl> get copyWith =>
      __$$SocialLoginBodyImplCopyWithImpl<_$SocialLoginBodyImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialLoginBodyImplToJson(
      this,
    );
  }
}

abstract class _SocialLoginBody implements SocialLoginBody {
  const factory _SocialLoginBody(
      {required final String provider,
      required final String token,
      required final String email,
      required final String source}) = _$SocialLoginBodyImpl;

  factory _SocialLoginBody.fromJson(Map<String, dynamic> json) =
      _$SocialLoginBodyImpl.fromJson;

  @override
  String get provider; // "google" ou "facebook"
  @override
  String get token;
  @override
  String get email;
  @override
  String get source;

  /// Create a copy of SocialLoginBody
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SocialLoginBodyImplCopyWith<_$SocialLoginBodyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
