import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/data/repositories/rating_repository.dart';
import 'ratings_state.dart';

class RatingsCubit extends Cubit<RatingsState> {
  RatingsCubit() : super(const RatingsState.initial());

  Future<void> submitRating({
    required String reservationId,
    required int clientRating,
    String? clientFeedback,
    String? guestBehavior,
    String? propertyCondition,
    String? anyIssues,
    bool wouldRecommend = true,
  }) async {
    emit(const RatingsState.loading());
    try {
      final data = {
        'reservationId': reservationId,
        'clientRating': clientRating,
        if (clientFeedback != null) 'clientFeedback': clientFeedback,
        if (guestBehavior != null) 'guestBehavior': guestBehavior,
        if (propertyCondition != null) 'propertyCondition': propertyCondition,
        if (anyIssues != null) 'anyIssues': anyIssues,
        'wouldRecommend': wouldRecommend,
      };
      await RatingRepository.submitRating(data: data);
      emit(const RatingsState.success());
    } catch (e) {
      emit(RatingsState.failure(e.toString()));
    }
  }

  Future<void> loadHistory({int page = 1, int? pageSize}) async {
    emit(const RatingsState.loading());
    try {
      final response = await RatingRepository.getRatings(
        page: page,
        pageSize: pageSize,
      );
      emit(RatingsState.historyLoaded(response));
    } catch (e) {
      emit(RatingsState.failure(e.toString()));
    }
  }
}
