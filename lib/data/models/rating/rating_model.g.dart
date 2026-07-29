// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RatingModelImpl _$$RatingModelImplFromJson(Map<String, dynamic> json) =>
    _$RatingModelImpl(
      id: json['id'] as String? ?? '',
      reservationId: json['reservationId'] as String? ?? '',
      propertyId: json['propertyId'] as String? ?? '',
      perspective: json['perspective'] as String? ?? '',
      ratedAt: json['ratedAt'] as String? ?? '',
      propertyRating: (json['propertyRating'] as num?)?.toInt() ?? 0,
      hostRating: (json['hostRating'] as num?)?.toInt() ?? 0,
      propertyFeedback: json['propertyFeedback'] as String? ?? '',
      hostFeedback: json['hostFeedback'] as String? ?? '',
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      clientRating: (json['clientRating'] as num?)?.toInt() ?? 0,
      clientFeedback: json['clientFeedback'] as String? ?? '',
      guestBehavior: json['guestBehavior'] as String? ?? '',
      propertyCondition: json['propertyCondition'] as String? ?? '',
      wouldRecommend: json['wouldRecommend'] as bool? ?? false,
    );

Map<String, dynamic> _$$RatingModelImplToJson(_$RatingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reservationId': instance.reservationId,
      'propertyId': instance.propertyId,
      'perspective': instance.perspective,
      'ratedAt': instance.ratedAt,
      'propertyRating': instance.propertyRating,
      'hostRating': instance.hostRating,
      'propertyFeedback': instance.propertyFeedback,
      'hostFeedback': instance.hostFeedback,
      'tags': instance.tags,
      'clientRating': instance.clientRating,
      'clientFeedback': instance.clientFeedback,
      'guestBehavior': instance.guestBehavior,
      'propertyCondition': instance.propertyCondition,
      'wouldRecommend': instance.wouldRecommend,
    };
