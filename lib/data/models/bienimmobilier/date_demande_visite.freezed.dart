// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'date_demande_visite.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DateDemandeVisite _$DateDemandeVisiteFromJson(Map<String, dynamic> json) {
  return _DateDemandeVisite.fromJson(json);
}

/// @nodoc
mixin _$DateDemandeVisite {
  DateTime? get date => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DateDemandeVisiteCopyWith<DateDemandeVisite> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DateDemandeVisiteCopyWith<$Res> {
  factory $DateDemandeVisiteCopyWith(
          DateDemandeVisite value, $Res Function(DateDemandeVisite) then) =
      _$DateDemandeVisiteCopyWithImpl<$Res, DateDemandeVisite>;
  @useResult
  $Res call({DateTime? date});
}

/// @nodoc
class _$DateDemandeVisiteCopyWithImpl<$Res, $Val extends DateDemandeVisite>
    implements $DateDemandeVisiteCopyWith<$Res> {
  _$DateDemandeVisiteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = freezed,
  }) {
    return _then(_value.copyWith(
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DateDemandeVisiteImplCopyWith<$Res>
    implements $DateDemandeVisiteCopyWith<$Res> {
  factory _$$DateDemandeVisiteImplCopyWith(_$DateDemandeVisiteImpl value,
          $Res Function(_$DateDemandeVisiteImpl) then) =
      __$$DateDemandeVisiteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime? date});
}

/// @nodoc
class __$$DateDemandeVisiteImplCopyWithImpl<$Res>
    extends _$DateDemandeVisiteCopyWithImpl<$Res, _$DateDemandeVisiteImpl>
    implements _$$DateDemandeVisiteImplCopyWith<$Res> {
  __$$DateDemandeVisiteImplCopyWithImpl(_$DateDemandeVisiteImpl _value,
      $Res Function(_$DateDemandeVisiteImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = freezed,
  }) {
    return _then(_$DateDemandeVisiteImpl(
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DateDemandeVisiteImpl implements _DateDemandeVisite {
  const _$DateDemandeVisiteImpl({this.date});

  factory _$DateDemandeVisiteImpl.fromJson(Map<String, dynamic> json) =>
      _$$DateDemandeVisiteImplFromJson(json);

  @override
  final DateTime? date;

  @override
  String toString() {
    return 'DateDemandeVisite(date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DateDemandeVisiteImpl &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, date);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DateDemandeVisiteImplCopyWith<_$DateDemandeVisiteImpl> get copyWith =>
      __$$DateDemandeVisiteImplCopyWithImpl<_$DateDemandeVisiteImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DateDemandeVisiteImplToJson(
      this,
    );
  }
}

abstract class _DateDemandeVisite implements DateDemandeVisite {
  const factory _DateDemandeVisite({final DateTime? date}) =
      _$DateDemandeVisiteImpl;

  factory _DateDemandeVisite.fromJson(Map<String, dynamic> json) =
      _$DateDemandeVisiteImpl.fromJson;

  @override
  DateTime? get date;
  @override
  @JsonKey(ignore: true)
  _$$DateDemandeVisiteImplCopyWith<_$DateDemandeVisiteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
