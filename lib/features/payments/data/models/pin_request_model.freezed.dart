// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pin_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PinRequestModel _$PinRequestModelFromJson(Map<String, dynamic> json) {
  return _PinRequestModel.fromJson(json);
}

/// @nodoc
mixin _$PinRequestModel {
  String get pin => throw _privateConstructorUsedError;

  /// Serializes this PinRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PinRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PinRequestModelCopyWith<PinRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PinRequestModelCopyWith<$Res> {
  factory $PinRequestModelCopyWith(
          PinRequestModel value, $Res Function(PinRequestModel) then) =
      _$PinRequestModelCopyWithImpl<$Res, PinRequestModel>;
  @useResult
  $Res call({String pin});
}

/// @nodoc
class _$PinRequestModelCopyWithImpl<$Res, $Val extends PinRequestModel>
    implements $PinRequestModelCopyWith<$Res> {
  _$PinRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PinRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pin = null,
  }) {
    return _then(_value.copyWith(
      pin: null == pin
          ? _value.pin
          : pin // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PinRequestModelImplCopyWith<$Res>
    implements $PinRequestModelCopyWith<$Res> {
  factory _$$PinRequestModelImplCopyWith(_$PinRequestModelImpl value,
          $Res Function(_$PinRequestModelImpl) then) =
      __$$PinRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String pin});
}

/// @nodoc
class __$$PinRequestModelImplCopyWithImpl<$Res>
    extends _$PinRequestModelCopyWithImpl<$Res, _$PinRequestModelImpl>
    implements _$$PinRequestModelImplCopyWith<$Res> {
  __$$PinRequestModelImplCopyWithImpl(
      _$PinRequestModelImpl _value, $Res Function(_$PinRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PinRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pin = null,
  }) {
    return _then(_$PinRequestModelImpl(
      pin: null == pin
          ? _value.pin
          : pin // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PinRequestModelImpl implements _PinRequestModel {
  const _$PinRequestModelImpl({this.pin = ''});

  factory _$PinRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PinRequestModelImplFromJson(json);

  @override
  @JsonKey()
  final String pin;

  @override
  String toString() {
    return 'PinRequestModel(pin: $pin)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PinRequestModelImpl &&
            (identical(other.pin, pin) || other.pin == pin));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, pin);

  /// Create a copy of PinRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PinRequestModelImplCopyWith<_$PinRequestModelImpl> get copyWith =>
      __$$PinRequestModelImplCopyWithImpl<_$PinRequestModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PinRequestModelImplToJson(
      this,
    );
  }
}

abstract class _PinRequestModel implements PinRequestModel {
  const factory _PinRequestModel({final String pin}) = _$PinRequestModelImpl;

  factory _PinRequestModel.fromJson(Map<String, dynamic> json) =
      _$PinRequestModelImpl.fromJson;

  @override
  String get pin;

  /// Create a copy of PinRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PinRequestModelImplCopyWith<_$PinRequestModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
