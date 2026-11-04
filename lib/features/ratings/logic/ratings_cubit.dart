import 'package:immoplus_pro/core/error/error_context.dart';
import 'package:immoplus_pro/core/error/error_feedback.dart';
import 'package:immoplus_pro/core/error/error_messages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/data/models/rating/host_rating_request_dto.dart';
import 'package:immoplus_pro/data/repositories/rating_repository.dart';
import 'ratings_state.dart';

class RatingsCubit extends Cubit<RatingsState> {
  RatingsCubit() : super(const RatingsState.initial());

  Future<void> submitRating(HostRatingRequestDto dto) async {
    emit(const RatingsState.loading());
    try {
      await RatingRepository.submitRating(dto: dto);
      emit(const RatingsState.success());
    } catch (e) {
      ErrorFeedback.show(e, context: ErrorContext.rating);
      emit(RatingsState.failure(ErrorMessages.messageOf(e, ErrorContext.rating)));
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
      ErrorFeedback.show(e, context: ErrorContext.rating);
      emit(RatingsState.failure(ErrorMessages.messageOf(e, ErrorContext.rating)));
    }
  }
}
