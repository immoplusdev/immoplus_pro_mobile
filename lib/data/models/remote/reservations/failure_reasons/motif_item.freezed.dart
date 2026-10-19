// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'motif_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MotifItem _$MotifItemFromJson(Map<String, dynamic> json) {
  return _MotifItem.fromJson(json);
}

/// @nodoc
mixin _$MotifItem {
  String get code => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;

  /// Serializes this MotifItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MotifItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MotifItemCopyWith<MotifItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MotifItemCopyWith<$Res> {
  factory $MotifItemCopyWith(MotifItem value, $Res Function(MotifItem) then) =
      _$MotifItemCopyWithImpl<$Res, MotifItem>;
  @useResult
  $Res call({String code, String label});
}

/// @nodoc
class _$MotifItemCopyWithImpl<$Res, $Val extends MotifItem>
    implements $MotifItemCopyWith<$Res> {
  _$MotifItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MotifItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? label = null,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MotifItemImplCopyWith<$Res>
    implements $MotifItemCopyWith<$Res> {
  factory _$$MotifItemImplCopyWith(
          _$MotifItemImpl value, $Res Function(_$MotifItemImpl) then) =
      __$$MotifItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String code, String label});
}

/// @nodoc
class __$$MotifItemImplCopyWithImpl<$Res>
    extends _$MotifItemCopyWithImpl<$Res, _$MotifItemImpl>
    implements _$$MotifItemImplCopyWith<$Res> {
  __$$MotifItemImplCopyWithImpl(
      _$MotifItemImpl _value, $Res Function(_$MotifItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of MotifItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? label = null,
  }) {
    return _then(_$MotifItemImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MotifItemImpl implements _MotifItem {
  const _$MotifItemImpl({required this.code, required this.label});

  factory _$MotifItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$MotifItemImplFromJson(json);

  @override
  final String code;
  @override
  final String label;

  @override
  String toString() {
    return 'MotifItem(code: $code, label: $label)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MotifItemImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.label, label) || other.label == label));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, label);

  /// Create a copy of MotifItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MotifItemImplCopyWith<_$MotifItemImpl> get copyWith =>
      __$$MotifItemImplCopyWithImpl<_$MotifItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MotifItemImplToJson(
      this,
    );
  }
}

abstract class _MotifItem implements MotifItem {
  const factory _MotifItem(
      {required final String code,
      required final String label}) = _$MotifItemImpl;

  factory _MotifItem.fromJson(Map<String, dynamic> json) =
      _$MotifItemImpl.fromJson;

  @override
  String get code;
  @override
  String get label;

  /// Create a copy of MotifItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MotifItemImplCopyWith<_$MotifItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
