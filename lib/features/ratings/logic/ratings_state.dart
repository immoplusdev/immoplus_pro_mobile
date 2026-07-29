import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus_pro/data/models/rating/rating_model.dart';

part 'ratings_state.freezed.dart';

@freezed
class RatingsState with _$RatingsState {
  const factory RatingsState.initial() = _Initial;
  const factory RatingsState.loading() = _Loading;
  const factory RatingsState.success() = _Success;
  const factory RatingsState.failure(String error) = _Failure;
  const factory RatingsState.historyLoaded(List<RatingModel> ratings) = _HistoryLoaded;
}
