import 'package:freezed_annotation/freezed_annotation.dart';

enum RatingStatus {
  @JsonValue('not_applicable')
  notApplicable,

  @JsonValue('pending')
  pending,

  @JsonValue('rated')
  rated,

  @JsonValue('expired')
  expired;

  String get backendValue {
    switch (this) {
      case RatingStatus.notApplicable:
        return 'not_applicable';
      case RatingStatus.pending:
        return 'pending';
      case RatingStatus.rated:
        return 'rated';
      case RatingStatus.expired:
        return 'expired';
    }
  }

  static RatingStatus fromString(String? value) {
    if (value == null) return RatingStatus.notApplicable;
    switch (value.toLowerCase()) {
      case 'pending':
        return RatingStatus.pending;
      case 'rated':
        return RatingStatus.rated;
      case 'expired':
        return RatingStatus.expired;
      case 'not_applicable':
      default:
        return RatingStatus.notApplicable;
    }
  }
}
