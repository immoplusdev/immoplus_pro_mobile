// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rating_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RatingModel _$RatingModelFromJson(Map<String, dynamic> json) {
  return _RatingModel.fromJson(json);
}

/// @nodoc
mixin _$RatingModel {
  String get id => throw _privateConstructorUsedError;
  String get reservationId => throw _privateConstructorUsedError;
  String get propertyId => throw _privateConstructorUsedError;
  String get perspective => throw _privateConstructorUsedError;
  String get ratedAt => throw _privateConstructorUsedError;
  int get propertyRating => throw _privateConstructorUsedError;
  int get hostRating => throw _privateConstructorUsedError;
  String get propertyFeedback => throw _privateConstructorUsedError;
  String get hostFeedback => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  int get clientRating => throw _privateConstructorUsedError;
  String get clientFeedback => throw _privateConstructorUsedError;
  String get guestBehavior => throw _privateConstructorUsedError;
  String get propertyCondition => throw _privateConstructorUsedError;
  bool get wouldRecommend => throw _privateConstructorUsedError;

  /// Serializes this RatingModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RatingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RatingModelCopyWith<RatingModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RatingModelCopyWith<$Res> {
  factory $RatingModelCopyWith(
          RatingModel value, $Res Function(RatingModel) then) =
      _$RatingModelCopyWithImpl<$Res, RatingModel>;
  @useResult
  $Res call(
      {String id,
      String reservationId,
      String propertyId,
      String perspective,
      String ratedAt,
      int propertyRating,
      int hostRating,
      String propertyFeedback,
      String hostFeedback,
      List<String> tags,
      int clientRating,
      String clientFeedback,
      String guestBehavior,
      String propertyCondition,
      bool wouldRecommend});
}

/// @nodoc
class _$RatingModelCopyWithImpl<$Res, $Val extends RatingModel>
    implements $RatingModelCopyWith<$Res> {
  _$RatingModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RatingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reservationId = null,
    Object? propertyId = null,
    Object? perspective = null,
    Object? ratedAt = null,
    Object? propertyRating = null,
    Object? hostRating = null,
    Object? propertyFeedback = null,
    Object? hostFeedback = null,
    Object? tags = null,
    Object? clientRating = null,
    Object? clientFeedback = null,
    Object? guestBehavior = null,
    Object? propertyCondition = null,
    Object? wouldRecommend = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      reservationId: null == reservationId
          ? _value.reservationId
          : reservationId // ignore: cast_nullable_to_non_nullable
              as String,
      propertyId: null == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as String,
      perspective: null == perspective
          ? _value.perspective
          : perspective // ignore: cast_nullable_to_non_nullable
              as String,
      ratedAt: null == ratedAt
          ? _value.ratedAt
          : ratedAt // ignore: cast_nullable_to_non_nullable
              as String,
      propertyRating: null == propertyRating
          ? _value.propertyRating
          : propertyRating // ignore: cast_nullable_to_non_nullable
              as int,
      hostRating: null == hostRating
          ? _value.hostRating
          : hostRating // ignore: cast_nullable_to_non_nullable
              as int,
      propertyFeedback: null == propertyFeedback
          ? _value.propertyFeedback
          : propertyFeedback // ignore: cast_nullable_to_non_nullable
              as String,
      hostFeedback: null == hostFeedback
          ? _value.hostFeedback
          : hostFeedback // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      clientRating: null == clientRating
          ? _value.clientRating
          : clientRating // ignore: cast_nullable_to_non_nullable
              as int,
      clientFeedback: null == clientFeedback
          ? _value.clientFeedback
          : clientFeedback // ignore: cast_nullable_to_non_nullable
              as String,
      guestBehavior: null == guestBehavior
          ? _value.guestBehavior
          : guestBehavior // ignore: cast_nullable_to_non_nullable
              as String,
      propertyCondition: null == propertyCondition
          ? _value.propertyCondition
          : propertyCondition // ignore: cast_nullable_to_non_nullable
              as String,
      wouldRecommend: null == wouldRecommend
          ? _value.wouldRecommend
          : wouldRecommend // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RatingModelImplCopyWith<$Res>
    implements $RatingModelCopyWith<$Res> {
  factory _$$RatingModelImplCopyWith(
          _$RatingModelImpl value, $Res Function(_$RatingModelImpl) then) =
      __$$RatingModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String reservationId,
      String propertyId,
      String perspective,
      String ratedAt,
      int propertyRating,
      int hostRating,
      String propertyFeedback,
      String hostFeedback,
      List<String> tags,
      int clientRating,
      String clientFeedback,
      String guestBehavior,
      String propertyCondition,
      bool wouldRecommend});
}

/// @nodoc
class __$$RatingModelImplCopyWithImpl<$Res>
    extends _$RatingModelCopyWithImpl<$Res, _$RatingModelImpl>
    implements _$$RatingModelImplCopyWith<$Res> {
  __$$RatingModelImplCopyWithImpl(
      _$RatingModelImpl _value, $Res Function(_$RatingModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RatingModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reservationId = null,
    Object? propertyId = null,
    Object? perspective = null,
    Object? ratedAt = null,
    Object? propertyRating = null,
    Object? hostRating = null,
    Object? propertyFeedback = null,
    Object? hostFeedback = null,
    Object? tags = null,
    Object? clientRating = null,
    Object? clientFeedback = null,
    Object? guestBehavior = null,
    Object? propertyCondition = null,
    Object? wouldRecommend = null,
  }) {
    return _then(_$RatingModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      reservationId: null == reservationId
          ? _value.reservationId
          : reservationId // ignore: cast_nullable_to_non_nullable
              as String,
      propertyId: null == propertyId
          ? _value.propertyId
          : propertyId // ignore: cast_nullable_to_non_nullable
              as String,
      perspective: null == perspective
          ? _value.perspective
          : perspective // ignore: cast_nullable_to_non_nullable
              as String,
      ratedAt: null == ratedAt
          ? _value.ratedAt
          : ratedAt // ignore: cast_nullable_to_non_nullable
              as String,
      propertyRating: null == propertyRating
          ? _value.propertyRating
          : propertyRating // ignore: cast_nullable_to_non_nullable
              as int,
      hostRating: null == hostRating
          ? _value.hostRating
          : hostRating // ignore: cast_nullable_to_non_nullable
              as int,
      propertyFeedback: null == propertyFeedback
          ? _value.propertyFeedback
          : propertyFeedback // ignore: cast_nullable_to_non_nullable
              as String,
      hostFeedback: null == hostFeedback
          ? _value.hostFeedback
          : hostFeedback // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      clientRating: null == clientRating
          ? _value.clientRating
          : clientRating // ignore: cast_nullable_to_non_nullable
              as int,
      clientFeedback: null == clientFeedback
          ? _value.clientFeedback
          : clientFeedback // ignore: cast_nullable_to_non_nullable
              as String,
      guestBehavior: null == guestBehavior
          ? _value.guestBehavior
          : guestBehavior // ignore: cast_nullable_to_non_nullable
              as String,
      propertyCondition: null == propertyCondition
          ? _value.propertyCondition
          : propertyCondition // ignore: cast_nullable_to_non_nullable
              as String,
      wouldRecommend: null == wouldRecommend
          ? _value.wouldRecommend
          : wouldRecommend // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RatingModelImpl implements _RatingModel {
  const _$RatingModelImpl(
      {this.id = '',
      this.reservationId = '',
      this.propertyId = '',
      this.perspective = '',
      this.ratedAt = '',
      this.propertyRating = 0,
      this.hostRating = 0,
      this.propertyFeedback = '',
      this.hostFeedback = '',
      final List<String> tags = const [],
      this.clientRating = 0,
      this.clientFeedback = '',
      this.guestBehavior = '',
      this.propertyCondition = '',
      this.wouldRecommend = false})
      : _tags = tags;

  factory _$RatingModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$RatingModelImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String reservationId;
  @override
  @JsonKey()
  final String propertyId;
  @override
  @JsonKey()
  final String perspective;
  @override
  @JsonKey()
  final String ratedAt;
  @override
  @JsonKey()
  final int propertyRating;
  @override
  @JsonKey()
  final int hostRating;
  @override
  @JsonKey()
  final String propertyFeedback;
  @override
  @JsonKey()
  final String hostFeedback;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final int clientRating;
  @override
  @JsonKey()
  final String clientFeedback;
  @override
  @JsonKey()
  final String guestBehavior;
  @override
  @JsonKey()
  final String propertyCondition;
  @override
  @JsonKey()
  final bool wouldRecommend;

  @override
  String toString() {
    return 'RatingModel(id: $id, reservationId: $reservationId, propertyId: $propertyId, perspective: $perspective, ratedAt: $ratedAt, propertyRating: $propertyRating, hostRating: $hostRating, propertyFeedback: $propertyFeedback, hostFeedback: $hostFeedback, tags: $tags, clientRating: $clientRating, clientFeedback: $clientFeedback, guestBehavior: $guestBehavior, propertyCondition: $propertyCondition, wouldRecommend: $wouldRecommend)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RatingModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reservationId, reservationId) ||
                other.reservationId == reservationId) &&
            (identical(other.propertyId, propertyId) ||
                other.propertyId == propertyId) &&
            (identical(other.perspective, perspective) ||
                other.perspective == perspective) &&
            (identical(other.ratedAt, ratedAt) || other.ratedAt == ratedAt) &&
            (identical(other.propertyRating, propertyRating) ||
                other.propertyRating == propertyRating) &&
            (identical(other.hostRating, hostRating) ||
                other.hostRating == hostRating) &&
            (identical(other.propertyFeedback, propertyFeedback) ||
                other.propertyFeedback == propertyFeedback) &&
            (identical(other.hostFeedback, hostFeedback) ||
                other.hostFeedback == hostFeedback) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.clientRating, clientRating) ||
                other.clientRating == clientRating) &&
            (identical(other.clientFeedback, clientFeedback) ||
                other.clientFeedback == clientFeedback) &&
            (identical(other.guestBehavior, guestBehavior) ||
                other.guestBehavior == guestBehavior) &&
            (identical(other.propertyCondition, propertyCondition) ||
                other.propertyCondition == propertyCondition) &&
            (identical(other.wouldRecommend, wouldRecommend) ||
                other.wouldRecommend == wouldRecommend));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      reservationId,
      propertyId,
      perspective,
      ratedAt,
      propertyRating,
      hostRating,
      propertyFeedback,
      hostFeedback,
      const DeepCollectionEquality().hash(_tags),
      clientRating,
      clientFeedback,
      guestBehavior,
      propertyCondition,
      wouldRecommend);

  /// Create a copy of RatingModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RatingModelImplCopyWith<_$RatingModelImpl> get copyWith =>
      __$$RatingModelImplCopyWithImpl<_$RatingModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RatingModelImplToJson(
      this,
    );
  }
}

abstract class _RatingModel implements RatingModel {
  const factory _RatingModel(
      {final String id,
      final String reservationId,
      final String propertyId,
      final String perspective,
      final String ratedAt,
      final int propertyRating,
      final int hostRating,
      final String propertyFeedback,
      final String hostFeedback,
      final List<String> tags,
      final int clientRating,
      final String clientFeedback,
      final String guestBehavior,
      final String propertyCondition,
      final bool wouldRecommend}) = _$RatingModelImpl;

  factory _RatingModel.fromJson(Map<String, dynamic> json) =
      _$RatingModelImpl.fromJson;

  @override
  String get id;
  @override
  String get reservationId;
  @override
  String get propertyId;
  @override
  String get perspective;
  @override
  String get ratedAt;
  @override
  int get propertyRating;
  @override
  int get hostRating;
  @override
  String get propertyFeedback;
  @override
  String get hostFeedback;
  @override
  List<String> get tags;
  @override
  int get clientRating;
  @override
  String get clientFeedback;
  @override
  String get guestBehavior;
  @override
  String get propertyCondition;
  @override
  bool get wouldRecommend;

  /// Create a copy of RatingModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RatingModelImplCopyWith<_$RatingModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
