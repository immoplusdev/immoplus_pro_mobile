import 'package:freezed_annotation/freezed_annotation.dart';

import 'residence_model.dart';

part 'residences_response.freezed.dart';
part 'residences_response.g.dart';

@freezed
class ResidencesResponse with _$ResidencesResponse {
  factory ResidencesResponse({
    @Default([]) List<ResidenceModel>? data,
    @Default(0) int? currentPage,
    @Default(0) int? totalPages,
    @Default(0) int? pageSize,
    @Default(false) bool? hasNext,
    @Default(false) bool? hasPrevious,
  }) = _ResidencesResponse;

  factory ResidencesResponse.fromJson(Map<String, dynamic> json) =>
      _$ResidencesResponseFromJson(json);
}
