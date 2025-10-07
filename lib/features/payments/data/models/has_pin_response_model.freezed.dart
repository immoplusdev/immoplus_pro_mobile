// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'has_pin_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HasPinResponseModel _$HasPinResponseModelFromJson(Map<String, dynamic> json) {
  return _HasPinResponseModel.fromJson(json);
}

/// @nodoc
mixin _$HasPinResponseModel {
  HasPinDataModel get data => throw _privateConstructorUsedError;

  /// Serializes this HasPinResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HasPinResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HasPinResponseModelCopyWith<HasPinResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HasPinResponseModelCopyWith<$Res> {
  factory $HasPinResponseModelCopyWith(
          HasPinResponseModel value, $Res Function(HasPinResponseModel) then) =
      _$HasPinResponseModelCopyWithImpl<$Res, HasPinResponseModel>;
  @useResult
  $Res call({HasPinDataModel data});

  $HasPinDataModelCopyWith<$Res> get data;
}

/// @nodoc
class _$HasPinResponseModelCopyWithImpl<$Res, $Val extends HasPinResponseModel>
    implements $HasPinResponseModelCopyWith<$Res> {
  _$HasPinResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HasPinResponseModel
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
              as HasPinDataModel,
    ) as $Val);
  }

  /// Create a copy of HasPinResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $HasPinDataModelCopyWith<$Res> get data {
    return $HasPinDataModelCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HasPinResponseModelImplCopyWith<$Res>
    implements $HasPinResponseModelCopyWith<$Res> {
  factory _$$HasPinResponseModelImplCopyWith(_$HasPinResponseModelImpl value,
          $Res Function(_$HasPinResponseModelImpl) then) =
      __$$HasPinResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({HasPinDataModel data});

  @override
  $HasPinDataModelCopyWith<$Res> get data;
}

/// @nodoc
class __$$HasPinResponseModelImplCopyWithImpl<$Res>
    extends _$HasPinResponseModelCopyWithImpl<$Res, _$HasPinResponseModelImpl>
    implements _$$HasPinResponseModelImplCopyWith<$Res> {
  __$$HasPinResponseModelImplCopyWithImpl(_$HasPinResponseModelImpl _value,
      $Res Function(_$HasPinResponseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of HasPinResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$HasPinResponseModelImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as HasPinDataModel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HasPinResponseModelImpl implements _HasPinResponseModel {
  const _$HasPinResponseModelImpl({required this.data});

  factory _$HasPinResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HasPinResponseModelImplFromJson(json);

  @override
  final HasPinDataModel data;

  @override
  String toString() {
    return 'HasPinResponseModel(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HasPinResponseModelImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of HasPinResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HasPinResponseModelImplCopyWith<_$HasPinResponseModelImpl> get copyWith =>
      __$$HasPinResponseModelImplCopyWithImpl<_$HasPinResponseModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HasPinResponseModelImplToJson(
      this,
    );
  }
}

abstract class _HasPinResponseModel implements HasPinResponseModel {
  const factory _HasPinResponseModel({required final HasPinDataModel data}) =
      _$HasPinResponseModelImpl;

  factory _HasPinResponseModel.fromJson(Map<String, dynamic> json) =
      _$HasPinResponseModelImpl.fromJson;

  @override
  HasPinDataModel get data;

  /// Create a copy of HasPinResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HasPinResponseModelImplCopyWith<_$HasPinResponseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HasPinDataModel _$HasPinDataModelFromJson(Map<String, dynamic> json) {
  return _HasPinDataModel.fromJson(json);
}

/// @nodoc
mixin _$HasPinDataModel {
  bool get hasPin => throw _privateConstructorUsedError;

  /// Serializes this HasPinDataModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HasPinDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HasPinDataModelCopyWith<HasPinDataModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HasPinDataModelCopyWith<$Res> {
  factory $HasPinDataModelCopyWith(
          HasPinDataModel value, $Res Function(HasPinDataModel) then) =
      _$HasPinDataModelCopyWithImpl<$Res, HasPinDataModel>;
  @useResult
  $Res call({bool hasPin});
}

/// @nodoc
class _$HasPinDataModelCopyWithImpl<$Res, $Val extends HasPinDataModel>
    implements $HasPinDataModelCopyWith<$Res> {
  _$HasPinDataModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HasPinDataModel
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
abstract class _$$HasPinDataModelImplCopyWith<$Res>
    implements $HasPinDataModelCopyWith<$Res> {
  factory _$$HasPinDataModelImplCopyWith(_$HasPinDataModelImpl value,
          $Res Function(_$HasPinDataModelImpl) then) =
      __$$HasPinDataModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool hasPin});
}

/// @nodoc
class __$$HasPinDataModelImplCopyWithImpl<$Res>
    extends _$HasPinDataModelCopyWithImpl<$Res, _$HasPinDataModelImpl>
    implements _$$HasPinDataModelImplCopyWith<$Res> {
  __$$HasPinDataModelImplCopyWithImpl(
      _$HasPinDataModelImpl _value, $Res Function(_$HasPinDataModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of HasPinDataModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasPin = null,
  }) {
    return _then(_$HasPinDataModelImpl(
      hasPin: null == hasPin
          ? _value.hasPin
          : hasPin // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HasPinDataModelImpl implements _HasPinDataModel {
  const _$HasPinDataModelImpl({this.hasPin = false});

  factory _$HasPinDataModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$HasPinDataModelImplFromJson(json);

  @override
  @JsonKey()
  final bool hasPin;

  @override
  String toString() {
    return 'HasPinDataModel(hasPin: $hasPin)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HasPinDataModelImpl &&
            (identical(other.hasPin, hasPin) || other.hasPin == hasPin));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, hasPin);

  /// Create a copy of HasPinDataModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HasPinDataModelImplCopyWith<_$HasPinDataModelImpl> get copyWith =>
      __$$HasPinDataModelImplCopyWithImpl<_$HasPinDataModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HasPinDataModelImplToJson(
      this,
    );
  }
}

abstract class _HasPinDataModel implements HasPinDataModel {
  const factory _HasPinDataModel({final bool hasPin}) = _$HasPinDataModelImpl;

  factory _HasPinDataModel.fromJson(Map<String, dynamic> json) =
      _$HasPinDataModelImpl.fromJson;

  @override
  bool get hasPin;

  /// Create a copy of HasPinDataModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HasPinDataModelImplCopyWith<_$HasPinDataModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
