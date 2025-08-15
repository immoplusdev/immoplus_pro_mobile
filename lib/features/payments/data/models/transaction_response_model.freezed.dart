// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransactionResponseModel _$TransactionResponseModelFromJson(
    Map<String, dynamic> json) {
  return _TransactionResponseModel.fromJson(json);
}

/// @nodoc
mixin _$TransactionResponseModel {
  TransactionModel? get data => throw _privateConstructorUsedError;

  /// Serializes this TransactionResponseModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionResponseModelCopyWith<TransactionResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionResponseModelCopyWith<$Res> {
  factory $TransactionResponseModelCopyWith(TransactionResponseModel value,
          $Res Function(TransactionResponseModel) then) =
      _$TransactionResponseModelCopyWithImpl<$Res, TransactionResponseModel>;
  @useResult
  $Res call({TransactionModel? data});

  $TransactionModelCopyWith<$Res>? get data;
}

/// @nodoc
class _$TransactionResponseModelCopyWithImpl<$Res,
        $Val extends TransactionResponseModel>
    implements $TransactionResponseModelCopyWith<$Res> {
  _$TransactionResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionResponseModel
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
              as TransactionModel?,
    ) as $Val);
  }

  /// Create a copy of TransactionResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransactionModelCopyWith<$Res>? get data {
    if (_value.data == null) {
      return null;
    }

    return $TransactionModelCopyWith<$Res>(_value.data!, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TransactionResponseModelImplCopyWith<$Res>
    implements $TransactionResponseModelCopyWith<$Res> {
  factory _$$TransactionResponseModelImplCopyWith(
          _$TransactionResponseModelImpl value,
          $Res Function(_$TransactionResponseModelImpl) then) =
      __$$TransactionResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({TransactionModel? data});

  @override
  $TransactionModelCopyWith<$Res>? get data;
}

/// @nodoc
class __$$TransactionResponseModelImplCopyWithImpl<$Res>
    extends _$TransactionResponseModelCopyWithImpl<$Res,
        _$TransactionResponseModelImpl>
    implements _$$TransactionResponseModelImplCopyWith<$Res> {
  __$$TransactionResponseModelImplCopyWithImpl(
      _$TransactionResponseModelImpl _value,
      $Res Function(_$TransactionResponseModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
  }) {
    return _then(_$TransactionResponseModelImpl(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as TransactionModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionResponseModelImpl implements _TransactionResponseModel {
  _$TransactionResponseModelImpl({this.data});

  factory _$TransactionResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionResponseModelImplFromJson(json);

  @override
  final TransactionModel? data;

  @override
  String toString() {
    return 'TransactionResponseModel(data: $data)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionResponseModelImpl &&
            (identical(other.data, data) || other.data == data));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, data);

  /// Create a copy of TransactionResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionResponseModelImplCopyWith<_$TransactionResponseModelImpl>
      get copyWith => __$$TransactionResponseModelImplCopyWithImpl<
          _$TransactionResponseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionResponseModelImplToJson(
      this,
    );
  }
}

abstract class _TransactionResponseModel implements TransactionResponseModel {
  factory _TransactionResponseModel({final TransactionModel? data}) =
      _$TransactionResponseModelImpl;

  factory _TransactionResponseModel.fromJson(Map<String, dynamic> json) =
      _$TransactionResponseModelImpl.fromJson;

  @override
  TransactionModel? get data;

  /// Create a copy of TransactionResponseModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionResponseModelImplCopyWith<_$TransactionResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
