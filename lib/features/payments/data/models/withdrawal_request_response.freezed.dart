// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'withdrawal_request_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WithdrawalRequestResponse _$WithdrawalRequestResponseFromJson(
    Map<String, dynamic> json) {
  return _WithdrawalRequestResponse.fromJson(json);
}

/// @nodoc
mixin _$WithdrawalRequestResponse {
  WithdrawalRequestModel get data => throw _privateConstructorUsedError;

  /// Serializes this WithdrawalRequestResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WithdrawalRequestResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WithdrawalRequestResponseCopyWith<WithdrawalRequestResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WithdrawalRequestResponseCopyWith<$Res> {
  factory $WithdrawalRequestResponseCopyWith(WithdrawalRequestResponse value,
          $Res Function(WithdrawalRequestResponse) then) =
      _$WithdrawalRequestResponseCopyWithImpl<$Res, WithdrawalRequestResponse>;
  @useResult
  $Res call({WithdrawalRequestModel data});

  $WithdrawalRequestModelCopyWith<$Res> get data;
}

/// @nodoc
class _$WithdrawalRequestResponseCopyWithImpl<$Res,
        $Val extends WithdrawalRequestResponse>
    implements $WithdrawalRequestResponseCopyWith<$Res> {
  _$WithdrawalRequestResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WithdrawalRequestResponse
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
              as WithdrawalRequestModel,
    ) as $Val);
  }

  /// Create a copy of WithdrawalRequestResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WithdrawalRequestModelCopyWith<$Res> get data {
    return $WithdrawalRequestModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WithdrawalRequestResponseImplCopyWith<$Res>
    implements $WithdrawalRequestResponseCopyWith<$Res> {
  factory _$$WithdrawalRequestResponseImplCopyWith(
          _$WithdrawalRequestResponseImpl value,
          $Res Function(_$WithdrawalRequestResponseImpl) then) =
      __$$WithdrawalRequestResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({WithdrawalRequestModel data});

  @override
  $WithdrawalRequestModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$WithdrawalRequestResponseImplCopyWithImpl<$Res>
    extends _$WithdrawalRequestResponseCopyWithImpl<$Res,
        _$WithdrawalRequestResponseImpl>
    implements _$$WithdrawalRequestResponseImplCopyWith<$Res> {
  __$$WithdrawalRequestResponseImplCopyWithImpl(
      _$WithdrawalRequestResponseImpl _value,
      $Res Function(_$WithdrawalRequestResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of WithdrawalRequestResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$WithdrawalRequestResponseImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as WithdrawalRequestModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WithdrawalRequestResponseImpl implements _WithdrawalRequestResponse {
  _$WithdrawalRequestResponseImpl({required this.data});

  factory _$WithdrawalRequestResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$WithdrawalRequestResponseImplFromJson(json);

  @override
  final WithdrawalRequestModel data;

  @override
  String toString() {
    return 'WithdrawalRequestResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WithdrawalRequestResponseImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of WithdrawalRequestResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WithdrawalRequestResponseImplCopyWith<_$WithdrawalRequestResponseImpl>
      get copyWith => __$$WithdrawalRequestResponseImplCopyWithImpl<
          _$WithdrawalRequestResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WithdrawalRequestResponseImplToJson(
      this,
    );
  }
}

abstract class _WithdrawalRequestResponse implements WithdrawalRequestResponse {
  factory _WithdrawalRequestResponse(
          {required final WithdrawalRequestModel data}) =
      _$WithdrawalRequestResponseImpl;

  factory _WithdrawalRequestResponse.fromJson(Map<String, dynamic> json) =
      _$WithdrawalRequestResponseImpl.fromJson;

  @override
  WithdrawalRequestModel get data;

  /// Create a copy of WithdrawalRequestResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WithdrawalRequestResponseImplCopyWith<_$WithdrawalRequestResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
