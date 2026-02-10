// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'date_reservation_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DateReservationModel _$DateReservationModelFromJson(Map<String, dynamic> json) {
  return _DateReservationModel.fromJson(json);
}

/// @nodoc
mixin _$DateReservationModel {
  String get date => throw _privateConstructorUsedError;

  /// Serializes this DateReservationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DateReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DateReservationModelCopyWith<DateReservationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DateReservationModelCopyWith<$Res> {
  factory $DateReservationModelCopyWith(DateReservationModel value,
          $Res Function(DateReservationModel) then) =
      _$DateReservationModelCopyWithImpl<$Res, DateReservationModel>;
  @useResult
  $Res call({String date});
}

/// @nodoc
class _$DateReservationModelCopyWithImpl<$Res,
        $Val extends DateReservationModel>
    implements $DateReservationModelCopyWith<$Res> {
  _$DateReservationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DateReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
  }) {
    return _then(_value.copyWith(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DateReservationModelImplCopyWith<$Res>
    implements $DateReservationModelCopyWith<$Res> {
  factory _$$DateReservationModelImplCopyWith(_$DateReservationModelImpl value,
          $Res Function(_$DateReservationModelImpl) then) =
      __$$DateReservationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String date});
}

/// @nodoc
class __$$DateReservationModelImplCopyWithImpl<$Res>
    extends _$DateReservationModelCopyWithImpl<$Res, _$DateReservationModelImpl>
    implements _$$DateReservationModelImplCopyWith<$Res> {
  __$$DateReservationModelImplCopyWithImpl(_$DateReservationModelImpl _value,
      $Res Function(_$DateReservationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of DateReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
  }) {
    return _then(_$DateReservationModelImpl(
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DateReservationModelImpl implements _DateReservationModel {
  const _$DateReservationModelImpl({required this.date});

  factory _$DateReservationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$DateReservationModelImplFromJson(json);

  @override
  final String date;

  @override
  String toString() {
    return 'DateReservationModel(date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DateReservationModelImpl &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, date);

  /// Create a copy of DateReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DateReservationModelImplCopyWith<_$DateReservationModelImpl>
      get copyWith =>
          __$$DateReservationModelImplCopyWithImpl<_$DateReservationModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DateReservationModelImplToJson(
      this,
    );
  }
}

abstract class _DateReservationModel implements DateReservationModel {
  const factory _DateReservationModel({required final String date}) =
      _$DateReservationModelImpl;

  factory _DateReservationModel.fromJson(Map<String, dynamic> json) =
      _$DateReservationModelImpl.fromJson;

  @override
  String get date;

  /// Create a copy of DateReservationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DateReservationModelImplCopyWith<_$DateReservationModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
