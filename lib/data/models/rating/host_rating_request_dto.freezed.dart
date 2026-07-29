// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'host_rating_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HostRatingRequestDto _$HostRatingRequestDtoFromJson(Map<String, dynamic> json) {
  return _HostRatingRequestDto.fromJson(json);
}

/// @nodoc
mixin _$HostRatingRequestDto {
  String get reservationId => throw _privateConstructorUsedError;
  int get clientRating => throw _privateConstructorUsedError;
  String? get clientFeedback => throw _privateConstructorUsedError;
  GuestBehavior? get guestBehavior => throw _privateConstructorUsedError;
  PropertyCondition? get propertyCondition =>
      throw _privateConstructorUsedError;
  String? get anyIssues => throw _privateConstructorUsedError;
  bool get wouldRecommend => throw _privateConstructorUsedError;

  /// Serializes this HostRatingRequestDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HostRatingRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HostRatingRequestDtoCopyWith<HostRatingRequestDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HostRatingRequestDtoCopyWith<$Res> {
  factory $HostRatingRequestDtoCopyWith(HostRatingRequestDto value,
          $Res Function(HostRatingRequestDto) then) =
      _$HostRatingRequestDtoCopyWithImpl<$Res, HostRatingRequestDto>;
  @useResult
  $Res call(
      {String reservationId,
      int clientRating,
      String? clientFeedback,
      GuestBehavior? guestBehavior,
      PropertyCondition? propertyCondition,
      String? anyIssues,
      bool wouldRecommend});
}

/// @nodoc
class _$HostRatingRequestDtoCopyWithImpl<$Res,
        $Val extends HostRatingRequestDto>
    implements $HostRatingRequestDtoCopyWith<$Res> {
  _$HostRatingRequestDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HostRatingRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reservationId = null,
    Object? clientRating = null,
    Object? clientFeedback = freezed,
    Object? guestBehavior = freezed,
    Object? propertyCondition = freezed,
    Object? anyIssues = freezed,
    Object? wouldRecommend = null,
  }) {
    return _then(_value.copyWith(
      reservationId: null == reservationId
          ? _value.reservationId
          : reservationId // ignore: cast_nullable_to_non_nullable
              as String,
      clientRating: null == clientRating
          ? _value.clientRating
          : clientRating // ignore: cast_nullable_to_non_nullable
              as int,
      clientFeedback: freezed == clientFeedback
          ? _value.clientFeedback
          : clientFeedback // ignore: cast_nullable_to_non_nullable
              as String?,
      guestBehavior: freezed == guestBehavior
          ? _value.guestBehavior
          : guestBehavior // ignore: cast_nullable_to_non_nullable
              as GuestBehavior?,
      propertyCondition: freezed == propertyCondition
          ? _value.propertyCondition
          : propertyCondition // ignore: cast_nullable_to_non_nullable
              as PropertyCondition?,
      anyIssues: freezed == anyIssues
          ? _value.anyIssues
          : anyIssues // ignore: cast_nullable_to_non_nullable
              as String?,
      wouldRecommend: null == wouldRecommend
          ? _value.wouldRecommend
          : wouldRecommend // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HostRatingRequestDtoImplCopyWith<$Res>
    implements $HostRatingRequestDtoCopyWith<$Res> {
  factory _$$HostRatingRequestDtoImplCopyWith(_$HostRatingRequestDtoImpl value,
          $Res Function(_$HostRatingRequestDtoImpl) then) =
      __$$HostRatingRequestDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String reservationId,
      int clientRating,
      String? clientFeedback,
      GuestBehavior? guestBehavior,
      PropertyCondition? propertyCondition,
      String? anyIssues,
      bool wouldRecommend});
}

/// @nodoc
class __$$HostRatingRequestDtoImplCopyWithImpl<$Res>
    extends _$HostRatingRequestDtoCopyWithImpl<$Res, _$HostRatingRequestDtoImpl>
    implements _$$HostRatingRequestDtoImplCopyWith<$Res> {
  __$$HostRatingRequestDtoImplCopyWithImpl(_$HostRatingRequestDtoImpl _value,
      $Res Function(_$HostRatingRequestDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of HostRatingRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reservationId = null,
    Object? clientRating = null,
    Object? clientFeedback = freezed,
    Object? guestBehavior = freezed,
    Object? propertyCondition = freezed,
    Object? anyIssues = freezed,
    Object? wouldRecommend = null,
  }) {
    return _then(_$HostRatingRequestDtoImpl(
      reservationId: null == reservationId
          ? _value.reservationId
          : reservationId // ignore: cast_nullable_to_non_nullable
              as String,
      clientRating: null == clientRating
          ? _value.clientRating
          : clientRating // ignore: cast_nullable_to_non_nullable
              as int,
      clientFeedback: freezed == clientFeedback
          ? _value.clientFeedback
          : clientFeedback // ignore: cast_nullable_to_non_nullable
              as String?,
      guestBehavior: freezed == guestBehavior
          ? _value.guestBehavior
          : guestBehavior // ignore: cast_nullable_to_non_nullable
              as GuestBehavior?,
      propertyCondition: freezed == propertyCondition
          ? _value.propertyCondition
          : propertyCondition // ignore: cast_nullable_to_non_nullable
              as PropertyCondition?,
      anyIssues: freezed == anyIssues
          ? _value.anyIssues
          : anyIssues // ignore: cast_nullable_to_non_nullable
              as String?,
      wouldRecommend: null == wouldRecommend
          ? _value.wouldRecommend
          : wouldRecommend // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HostRatingRequestDtoImpl implements _HostRatingRequestDto {
  const _$HostRatingRequestDtoImpl(
      {required this.reservationId,
      required this.clientRating,
      this.clientFeedback,
      this.guestBehavior,
      this.propertyCondition,
      this.anyIssues,
      this.wouldRecommend = true});

  factory _$HostRatingRequestDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$HostRatingRequestDtoImplFromJson(json);

  @override
  final String reservationId;
  @override
  final int clientRating;
  @override
  final String? clientFeedback;
  @override
  final GuestBehavior? guestBehavior;
  @override
  final PropertyCondition? propertyCondition;
  @override
  final String? anyIssues;
  @override
  @JsonKey()
  final bool wouldRecommend;

  @override
  String toString() {
    return 'HostRatingRequestDto(reservationId: $reservationId, clientRating: $clientRating, clientFeedback: $clientFeedback, guestBehavior: $guestBehavior, propertyCondition: $propertyCondition, anyIssues: $anyIssues, wouldRecommend: $wouldRecommend)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HostRatingRequestDtoImpl &&
            (identical(other.reservationId, reservationId) ||
                other.reservationId == reservationId) &&
            (identical(other.clientRating, clientRating) ||
                other.clientRating == clientRating) &&
            (identical(other.clientFeedback, clientFeedback) ||
                other.clientFeedback == clientFeedback) &&
            (identical(other.guestBehavior, guestBehavior) ||
                other.guestBehavior == guestBehavior) &&
            (identical(other.propertyCondition, propertyCondition) ||
                other.propertyCondition == propertyCondition) &&
            (identical(other.anyIssues, anyIssues) ||
                other.anyIssues == anyIssues) &&
            (identical(other.wouldRecommend, wouldRecommend) ||
                other.wouldRecommend == wouldRecommend));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      reservationId,
      clientRating,
      clientFeedback,
      guestBehavior,
      propertyCondition,
      anyIssues,
      wouldRecommend);

  /// Create a copy of HostRatingRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HostRatingRequestDtoImplCopyWith<_$HostRatingRequestDtoImpl>
      get copyWith =>
          __$$HostRatingRequestDtoImplCopyWithImpl<_$HostRatingRequestDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HostRatingRequestDtoImplToJson(
      this,
    );
  }
}

abstract class _HostRatingRequestDto implements HostRatingRequestDto {
  const factory _HostRatingRequestDto(
      {required final String reservationId,
      required final int clientRating,
      final String? clientFeedback,
      final GuestBehavior? guestBehavior,
      final PropertyCondition? propertyCondition,
      final String? anyIssues,
      final bool wouldRecommend}) = _$HostRatingRequestDtoImpl;

  factory _HostRatingRequestDto.fromJson(Map<String, dynamic> json) =
      _$HostRatingRequestDtoImpl.fromJson;

  @override
  String get reservationId;
  @override
  int get clientRating;
  @override
  String? get clientFeedback;
  @override
  GuestBehavior? get guestBehavior;
  @override
  PropertyCondition? get propertyCondition;
  @override
  String? get anyIssues;
  @override
  bool get wouldRecommend;

  /// Create a copy of HostRatingRequestDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HostRatingRequestDtoImplCopyWith<_$HostRatingRequestDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
