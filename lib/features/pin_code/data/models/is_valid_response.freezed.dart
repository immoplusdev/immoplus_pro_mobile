// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'is_valid_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

IsValidResponse _$IsValidResponseFromJson(Map<String, dynamic> json) {
  return _IsValidResponse.fromJson(json);
}

/// @nodoc
mixin _$IsValidResponse {
  IsValidData get data => throw _privateConstructorUsedError;

  /// Serializes this IsValidResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IsValidResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IsValidResponseCopyWith<IsValidResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IsValidResponseCopyWith<$Res> {
  factory $IsValidResponseCopyWith(
          IsValidResponse value, $Res Function(IsValidResponse) then) =
      _$IsValidResponseCopyWithImpl<$Res, IsValidResponse>;
  @useResult
  $Res call({IsValidData data});

  $IsValidDataCopyWith<$Res> get data;
}

/// @nodoc
class _$IsValidResponseCopyWithImpl<$Res, $Val extends IsValidResponse>
    implements $IsValidResponseCopyWith<$Res> {
  _$IsValidResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IsValidResponse
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
              as IsValidData,
    ) as $Val);
  }

  /// Create a copy of IsValidResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $IsValidDataCopyWith<$Res> get data {
    return $IsValidDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$IsValidResponseImplCopyWith<$Res>
    implements $IsValidResponseCopyWith<$Res> {
  factory _$$IsValidResponseImplCopyWith(_$IsValidResponseImpl value,
          $Res Function(_$IsValidResponseImpl) then) =
      __$$IsValidResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({IsValidData data});

  @override
  $IsValidDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$IsValidResponseImplCopyWithImpl<$Res>
    extends _$IsValidResponseCopyWithImpl<$Res, _$IsValidResponseImpl>
    implements _$$IsValidResponseImplCopyWith<$Res> {
  __$$IsValidResponseImplCopyWithImpl(
      _$IsValidResponseImpl _value, $Res Function(_$IsValidResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of IsValidResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$IsValidResponseImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as IsValidData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IsValidResponseImpl implements _IsValidResponse {
  const _$IsValidResponseImpl({required this.data});

  factory _$IsValidResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$IsValidResponseImplFromJson(json);

  @override
  final IsValidData data;

  @override
  String toString() {
    return 'IsValidResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IsValidResponseImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of IsValidResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IsValidResponseImplCopyWith<_$IsValidResponseImpl> get copyWith =>
      __$$IsValidResponseImplCopyWithImpl<_$IsValidResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IsValidResponseImplToJson(
      this,
    );
  }
}

abstract class _IsValidResponse implements IsValidResponse {
  const factory _IsValidResponse({required final IsValidData data}) =
      _$IsValidResponseImpl;

  factory _IsValidResponse.fromJson(Map<String, dynamic> json) =
      _$IsValidResponseImpl.fromJson;

  @override
  IsValidData get data;

  /// Create a copy of IsValidResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IsValidResponseImplCopyWith<_$IsValidResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

IsValidData _$IsValidDataFromJson(Map<String, dynamic> json) {
  return _IsValidData.fromJson(json);
}

/// @nodoc
mixin _$IsValidData {
  bool get isValid => throw _privateConstructorUsedError;

  /// Serializes this IsValidData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of IsValidData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IsValidDataCopyWith<IsValidData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IsValidDataCopyWith<$Res> {
  factory $IsValidDataCopyWith(
          IsValidData value, $Res Function(IsValidData) then) =
      _$IsValidDataCopyWithImpl<$Res, IsValidData>;
  @useResult
  $Res call({bool isValid});
}

/// @nodoc
class _$IsValidDataCopyWithImpl<$Res, $Val extends IsValidData>
    implements $IsValidDataCopyWith<$Res> {
  _$IsValidDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of IsValidData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isValid = null,
  }) {
    return _then(_value.copyWith(
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IsValidDataImplCopyWith<$Res>
    implements $IsValidDataCopyWith<$Res> {
  factory _$$IsValidDataImplCopyWith(
          _$IsValidDataImpl value, $Res Function(_$IsValidDataImpl) then) =
      __$$IsValidDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isValid});
}

/// @nodoc
class __$$IsValidDataImplCopyWithImpl<$Res>
    extends _$IsValidDataCopyWithImpl<$Res, _$IsValidDataImpl>
    implements _$$IsValidDataImplCopyWith<$Res> {
  __$$IsValidDataImplCopyWithImpl(
      _$IsValidDataImpl _value, $Res Function(_$IsValidDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of IsValidData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isValid = null,
  }) {
    return _then(_$IsValidDataImpl(
      isValid: null == isValid
          ? _value.isValid
          : isValid // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IsValidDataImpl implements _IsValidData {
  const _$IsValidDataImpl({required this.isValid});

  factory _$IsValidDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$IsValidDataImplFromJson(json);

  @override
  final bool isValid;

  @override
  String toString() {
    return 'IsValidData(isValid: $isValid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IsValidDataImpl &&
            (identical(other.isValid, isValid) || other.isValid == isValid));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isValid);

  /// Create a copy of IsValidData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IsValidDataImplCopyWith<_$IsValidDataImpl> get copyWith =>
      __$$IsValidDataImplCopyWithImpl<_$IsValidDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IsValidDataImplToJson(
      this,
    );
  }
}

abstract class _IsValidData implements IsValidData {
  const factory _IsValidData({required final bool isValid}) = _$IsValidDataImpl;

  factory _IsValidData.fromJson(Map<String, dynamic> json) =
      _$IsValidDataImpl.fromJson;

  @override
  bool get isValid;

  /// Create a copy of IsValidData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IsValidDataImplCopyWith<_$IsValidDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
