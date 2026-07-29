import 'package:freezed_annotation/freezed_annotation.dart';
import 'rating_model.dart';

part 'rating_history_response_model.freezed.dart';
part 'rating_history_response_model.g.dart';

@freezed
class RatingHistoryResponseModel with _$RatingHistoryResponseModel {
  const factory RatingHistoryResponseModel({
    @Default([]) List<RatingModel> data,
    @Default(0) int currentPage,
    @Default(0) int totalPages,
    @Default(0) int pageSize,
    @Default(0) int totalCount,
    @Default(false) bool hasPrevious,
    @Default(false) bool hasNext,
  }) = _RatingHistoryResponseModel;

  factory RatingHistoryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RatingHistoryResponseModelFromJson(json);
}
