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
