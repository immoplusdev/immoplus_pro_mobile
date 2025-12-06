// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'has_pin_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HasPinResponse _$HasPinResponseFromJson(Map<String, dynamic> json) {
  return _HasPinResponse.fromJson(json);
}

/// @nodoc
mixin _$HasPinResponse {
  HasPinData get data => throw _privateConstructorUsedError;

  /// Serializes this HasPinResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HasPinResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HasPinResponseCopyWith<HasPinResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HasPinResponseCopyWith<$Res> {
  factory $HasPinResponseCopyWith(
          HasPinResponse value, $Res Function(HasPinResponse) then) =
      _$HasPinResponseCopyWithImpl<$Res, HasPinResponse>;
  @useResult
  $Res call({HasPinData data});

  $HasPinDataCopyWith<$Res> get data;
}

/// @nodoc
class _$HasPinResponseCopyWithImpl<$Res, $Val extends HasPinResponse>
    implements $HasPinResponseCopyWith<$Res> {
  _$HasPinResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HasPinResponse
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
              as HasPinData,
    ) as $Val);
  }

  /// Create a copy of HasPinResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HasPinDataCopyWith<$Res> get data {
    return $HasPinDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HasPinResponseImplCopyWith<$Res>
    implements $HasPinResponseCopyWith<$Res> {
  factory _$$HasPinResponseImplCopyWith(_$HasPinResponseImpl value,
          $Res Function(_$HasPinResponseImpl) then) =
      __$$HasPinResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({HasPinData data});

  @override
  $HasPinDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$HasPinResponseImplCopyWithImpl<$Res>
    extends _$HasPinResponseCopyWithImpl<$Res, _$HasPinResponseImpl>
    implements _$$HasPinResponseImplCopyWith<$Res> {
  __$$HasPinResponseImplCopyWithImpl(
      _$HasPinResponseImpl _value, $Res Function(_$HasPinResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of HasPinResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$HasPinResponseImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as HasPinData,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HasPinResponseImpl implements _HasPinResponse {
  const _$HasPinResponseImpl({required this.data});

  factory _$HasPinResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$HasPinResponseImplFromJson(json);

  @override
  final HasPinData data;

  @override
  String toString() {
    return 'HasPinResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HasPinResponseImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of HasPinResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HasPinResponseImplCopyWith<_$HasPinResponseImpl> get copyWith =>
      __$$HasPinResponseImplCopyWithImpl<_$HasPinResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HasPinResponseImplToJson(
      this,
    );
  }
}

abstract class _HasPinResponse implements HasPinResponse {
  const factory _HasPinResponse({required final HasPinData data}) =
      _$HasPinResponseImpl;

  factory _HasPinResponse.fromJson(Map<String, dynamic> json) =
      _$HasPinResponseImpl.fromJson;

  @override
  HasPinData get data;

  /// Create a copy of HasPinResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HasPinResponseImplCopyWith<_$HasPinResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HasPinData _$HasPinDataFromJson(Map<String, dynamic> json) {
  return _HasPinData.fromJson(json);
}

/// @nodoc
mixin _$HasPinData {
  bool get hasPin => throw _privateConstructorUsedError;

  /// Serializes this HasPinData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HasPinData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HasPinDataCopyWith<HasPinData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HasPinDataCopyWith<$Res> {
  factory $HasPinDataCopyWith(
          HasPinData value, $Res Function(HasPinData) then) =
      _$HasPinDataCopyWithImpl<$Res, HasPinData>;
  @useResult
  $Res call({bool hasPin});
}

/// @nodoc
class _$HasPinDataCopyWithImpl<$Res, $Val extends HasPinData>
    implements $HasPinDataCopyWith<$Res> {
  _$HasPinDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HasPinData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasPin = null,
  }) {
    return _then(_value.copyWith(
      hasPin: null == hasPin
          ? _value.hasPin
          : hasPin // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HasPinDataImplCopyWith<$Res>
    implements $HasPinDataCopyWith<$Res> {
  factory _$$HasPinDataImplCopyWith(
          _$HasPinDataImpl value, $Res Function(_$HasPinDataImpl) then) =
      __$$HasPinDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool hasPin});
}

/// @nodoc
class __$$HasPinDataImplCopyWithImpl<$Res>
    extends _$HasPinDataCopyWithImpl<$Res, _$HasPinDataImpl>
    implements _$$HasPinDataImplCopyWith<$Res> {
  __$$HasPinDataImplCopyWithImpl(
      _$HasPinDataImpl _value, $Res Function(_$HasPinDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of HasPinData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasPin = null,
  }) {
    return _then(_$HasPinDataImpl(
      hasPin: null == hasPin
          ? _value.hasPin
          : hasPin // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HasPinDataImpl implements _HasPinData {
  const _$HasPinDataImpl({required this.hasPin});

  factory _$HasPinDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$HasPinDataImplFromJson(json);

  @override
  final bool hasPin;

  @override
  String toString() {
    return 'HasPinData(hasPin: $hasPin)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HasPinDataImpl &&
            (identical(other.hasPin, hasPin) || other.hasPin == hasPin));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, hasPin);

  /// Create a copy of HasPinData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HasPinDataImplCopyWith<_$HasPinDataImpl> get copyWith =>
      __$$HasPinDataImplCopyWithImpl<_$HasPinDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HasPinDataImplToJson(
      this,
    );
  }
}

abstract class _HasPinData implements HasPinData {
  const factory _HasPinData({required final bool hasPin}) = _$HasPinDataImpl;

  factory _HasPinData.fromJson(Map<String, dynamic> json) =
      _$HasPinDataImpl.fromJson;

  @override
  bool get hasPin;

  /// Create a copy of HasPinData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HasPinDataImplCopyWith<_$HasPinDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
