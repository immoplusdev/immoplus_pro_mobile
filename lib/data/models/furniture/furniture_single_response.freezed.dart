// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'furniture_single_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FurnitureSingleResponse _$FurnitureSingleResponseFromJson(
    Map<String, dynamic> json) {
  return _FurnitureSingleResponse.fromJson(json);
}

/// @nodoc
mixin _$FurnitureSingleResponse {
  FurnitureModel? get data => throw _privateConstructorUsedError;

  /// Serializes this FurnitureSingleResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FurnitureSingleResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FurnitureSingleResponseCopyWith<FurnitureSingleResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FurnitureSingleResponseCopyWith<$Res> {
  factory $FurnitureSingleResponseCopyWith(FurnitureSingleResponse value,
          $Res Function(FurnitureSingleResponse) then) =
      _$FurnitureSingleResponseCopyWithImpl<$Res, FurnitureSingleResponse>;
  @useResult
  $Res call({FurnitureModel? data});

  $FurnitureModelCopyWith<$Res>? get data;
}

/// @nodoc
class _$FurnitureSingleResponseCopyWithImpl<$Res,
        $Val extends FurnitureSingleResponse>
    implements $FurnitureSingleResponseCopyWith<$Res> {
  _$FurnitureSingleResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FurnitureSingleResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_value.copyWith(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as FurnitureModel?,
    ) as $Val);
  }

  /// Create a copy of FurnitureSingleResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FurnitureModelCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $FurnitureModelCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FurnitureSingleResponseImplCopyWith<$Res>
    implements $FurnitureSingleResponseCopyWith<$Res> {
  factory _$$FurnitureSingleResponseImplCopyWith(
          _$FurnitureSingleResponseImpl value,
          $Res Function(_$FurnitureSingleResponseImpl) then) =
      __$$FurnitureSingleResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({FurnitureModel? data});

  @override
  $FurnitureModelCopyWith<$Res>? get data;
}

/// @nodoc
class __$$FurnitureSingleResponseImplCopyWithImpl<$Res>
    extends _$FurnitureSingleResponseCopyWithImpl<$Res,
        _$FurnitureSingleResponseImpl>
    implements _$$FurnitureSingleResponseImplCopyWith<$Res> {
  __$$FurnitureSingleResponseImplCopyWithImpl(
      _$FurnitureSingleResponseImpl _value,
      $Res Function(_$FurnitureSingleResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of FurnitureSingleResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$FurnitureSingleResponseImpl(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as FurnitureModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FurnitureSingleResponseImpl implements _FurnitureSingleResponse {
  _$FurnitureSingleResponseImpl({this.data});

  factory _$FurnitureSingleResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$FurnitureSingleResponseImplFromJson(json);

  @override
  final FurnitureModel? data;

  @override
  String toString() {
    return 'FurnitureSingleResponse(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FurnitureSingleResponseImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of FurnitureSingleResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FurnitureSingleResponseImplCopyWith<_$FurnitureSingleResponseImpl>
      get copyWith => __$$FurnitureSingleResponseImplCopyWithImpl<
          _$FurnitureSingleResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FurnitureSingleResponseImplToJson(
      this,
    );
  }
}

abstract class _FurnitureSingleResponse implements FurnitureSingleResponse {
  factory _FurnitureSingleResponse({final FurnitureModel? data}) =
      _$FurnitureSingleResponseImpl;

  factory _FurnitureSingleResponse.fromJson(Map<String, dynamic> json) =
      _$FurnitureSingleResponseImpl.fromJson;

  @override
  FurnitureModel? get data;

  /// Create a copy of FurnitureSingleResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FurnitureSingleResponseImplCopyWith<_$FurnitureSingleResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
