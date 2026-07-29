// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'host_rating_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HostRatingRequestDtoImpl _$$HostRatingRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$HostRatingRequestDtoImpl(
      reservationId: json['reservationId'] as String,
      clientRating: (json['clientRating'] as num).toInt(),
      clientFeedback: json['clientFeedback'] as String?,
      guestBehavior:
          $enumDecodeNullable(_$GuestBehaviorEnumMap, json['guestBehavior']),
      propertyCondition: $enumDecodeNullable(
          _$PropertyConditionEnumMap, json['propertyCondition']),
      anyIssues: json['anyIssues'] as String?,
      wouldRecommend: json['wouldRecommend'] as bool? ?? true,
    );

Map<String, dynamic> _$$HostRatingRequestDtoImplToJson(
        _$HostRatingRequestDtoImpl instance) =>
    <String, dynamic>{
      'reservationId': instance.reservationId,
      'clientRating': instance.clientRating,
      'clientFeedback': instance.clientFeedback,
      'guestBehavior': _$GuestBehaviorEnumMap[instance.guestBehavior],
      'propertyCondition':
          _$PropertyConditionEnumMap[instance.propertyCondition],
      'anyIssues': instance.anyIssues,
      'wouldRecommend': instance.wouldRecommend,
    };

const _$GuestBehaviorEnumMap = {
  GuestBehavior.respectful: 'Respectueux',
  GuestBehavior.acceptable: 'Acceptable',
  GuestBehavior.problematic: 'Problématique',
};

const _$PropertyConditionEnumMap = {
  PropertyCondition.excellent: 'Excellente',
  PropertyCondition.good: 'Bonne',
  PropertyCondition.toClean: 'À nettoyer',
  PropertyCondition.degraded: 'Dégradée',
};
