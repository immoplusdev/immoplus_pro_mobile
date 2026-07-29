import 'package:freezed_annotation/freezed_annotation.dart';
import 'guest_behavior.dart';
import 'property_condition.dart';

part 'host_rating_request_dto.freezed.dart';
part 'host_rating_request_dto.g.dart';

@freezed
class HostRatingRequestDto with _$HostRatingRequestDto {
  const factory HostRatingRequestDto({
    required String reservationId,
    required int clientRating,
    String? clientFeedback,
    GuestBehavior? guestBehavior,
    PropertyCondition? propertyCondition,
    String? anyIssues,
    @Default(true) bool wouldRecommend,
  }) = _HostRatingRequestDto;

  factory HostRatingRequestDto.fromJson(Map<String, dynamic> json) =>
      _$HostRatingRequestDtoFromJson(json);

  @override
  Map<String, dynamic> toJson();
}
