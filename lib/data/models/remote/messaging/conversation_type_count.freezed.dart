// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation_type_count.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConversationTypeCount _$ConversationTypeCountFromJson(
    Map<String, dynamic> json) {
  return _ConversationTypeCount.fromJson(json);
}

/// @nodoc
mixin _$ConversationTypeCount {
  String get type => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get unread => throw _privateConstructorUsedError;

  /// Serializes this ConversationTypeCount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConversationTypeCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationTypeCountCopyWith<ConversationTypeCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationTypeCountCopyWith<$Res> {
  factory $ConversationTypeCountCopyWith(ConversationTypeCount value,
          $Res Function(ConversationTypeCount) then) =
      _$ConversationTypeCountCopyWithImpl<$Res, ConversationTypeCount>;
  @useResult
  $Res call({String type, int total, int unread});
}

/// @nodoc
class _$ConversationTypeCountCopyWithImpl<$Res,
        $Val extends ConversationTypeCount>
    implements $ConversationTypeCountCopyWith<$Res> {
  _$ConversationTypeCountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConversationTypeCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? total = null,
    Object? unread = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      unread: null == unread
          ? _value.unread
          : unread // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConversationTypeCountImplCopyWith<$Res>
    implements $ConversationTypeCountCopyWith<$Res> {
  factory _$$ConversationTypeCountImplCopyWith(
          _$ConversationTypeCountImpl value,
          $Res Function(_$ConversationTypeCountImpl) then) =
      __$$ConversationTypeCountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, int total, int unread});
}

/// @nodoc
class __$$ConversationTypeCountImplCopyWithImpl<$Res>
    extends _$ConversationTypeCountCopyWithImpl<$Res,
        _$ConversationTypeCountImpl>
    implements _$$ConversationTypeCountImplCopyWith<$Res> {
  __$$ConversationTypeCountImplCopyWithImpl(_$ConversationTypeCountImpl _value,
      $Res Function(_$ConversationTypeCountImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConversationTypeCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? total = null,
    Object? unread = null,
  }) {
    return _then(_$ConversationTypeCountImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      unread: null == unread
          ? _value.unread
          : unread // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationTypeCountImpl extends _ConversationTypeCount {
  const _$ConversationTypeCountImpl(
      {required this.type, this.total = 0, this.unread = 0})
      : super._();

  factory _$ConversationTypeCountImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationTypeCountImplFromJson(json);

  @override
  final String type;
  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final int unread;

  @override
  String toString() {
    return 'ConversationTypeCount(type: $type, total: $total, unread: $unread)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationTypeCountImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.unread, unread) || other.unread == unread));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, type, total, unread);

  /// Create a copy of ConversationTypeCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationTypeCountImplCopyWith<_$ConversationTypeCountImpl>
      get copyWith => __$$ConversationTypeCountImplCopyWithImpl<
          _$ConversationTypeCountImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationTypeCountImplToJson(
      this,
    );
  }
}

abstract class _ConversationTypeCount extends ConversationTypeCount {
  const factory _ConversationTypeCount(
      {required final String type,
      final int total,
      final int unread}) = _$ConversationTypeCountImpl;
  const _ConversationTypeCount._() : super._();

  factory _ConversationTypeCount.fromJson(Map<String, dynamic> json) =
      _$ConversationTypeCountImpl.fromJson;

  @override
  String get type;
  @override
  int get total;
  @override
  int get unread;

  /// Create a copy of ConversationTypeCount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationTypeCountImplCopyWith<_$ConversationTypeCountImpl>
      get copyWith => throw _privateConstructorUsedError;
}
