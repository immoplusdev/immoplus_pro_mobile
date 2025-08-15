// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WalletResponseModel _$WalletResponseModelFromJson(Map<String, dynamic> json) {
  return _WalletResponseModel.fromJson(json);
}

/// @nodoc
mixin _$WalletResponseModel {
  WalletModel? get data => throw _privateConstructorUsedError;

  /// Serializes this WalletResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WalletResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WalletResponseModelCopyWith<WalletResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WalletResponseModelCopyWith<$Res> {
  factory $WalletResponseModelCopyWith(
          WalletResponseModel value, $Res Function(WalletResponseModel) then) =
      _$WalletResponseModelCopyWithImpl<$Res, WalletResponseModel>;
  @useResult
  $Res call({WalletModel? data});

  $WalletModelCopyWith<$Res>? get data;
}

/// @nodoc
class _$WalletResponseModelCopyWithImpl<$Res, $Val extends WalletResponseModel>
    implements $WalletResponseModelCopyWith<$Res> {
  _$WalletResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WalletResponseModel
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
              as WalletModel?,
    ) as $Val);
  }

  /// Create a copy of WalletResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $WalletModelCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $WalletModelCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$WalletResponseModelImplCopyWith<$Res>
    implements $WalletResponseModelCopyWith<$Res> {
  factory _$$WalletResponseModelImplCopyWith(_$WalletResponseModelImpl value,
          $Res Function(_$WalletResponseModelImpl) then) =
      __$$WalletResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({WalletModel? data});

  @override
  $WalletModelCopyWith<$Res>? get data;
}

/// @nodoc
class __$$WalletResponseModelImplCopyWithImpl<$Res>
    extends _$WalletResponseModelCopyWithImpl<$Res, _$WalletResponseModelImpl>
    implements _$$WalletResponseModelImplCopyWith<$Res> {
  __$$WalletResponseModelImplCopyWithImpl(_$WalletResponseModelImpl _value,
      $Res Function(_$WalletResponseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of WalletResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$WalletResponseModelImpl(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as WalletModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WalletResponseModelImpl implements _WalletResponseModel {
  _$WalletResponseModelImpl({this.data});

  factory _$WalletResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$WalletResponseModelImplFromJson(json);

  @override
  final WalletModel? data;

  @override
  String toString() {
    return 'WalletResponseModel(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WalletResponseModelImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of WalletResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WalletResponseModelImplCopyWith<_$WalletResponseModelImpl> get copyWith =>
      __$$WalletResponseModelImplCopyWithImpl<_$WalletResponseModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WalletResponseModelImplToJson(
      this,
    );
  }
}

abstract class _WalletResponseModel implements WalletResponseModel {
  factory _WalletResponseModel({final WalletModel? data}) =
      _$WalletResponseModelImpl;

  factory _WalletResponseModel.fromJson(Map<String, dynamic> json) =
      _$WalletResponseModelImpl.fromJson;

  @override
  WalletModel? get data;

  /// Create a copy of WalletResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WalletResponseModelImplCopyWith<_$WalletResponseModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
