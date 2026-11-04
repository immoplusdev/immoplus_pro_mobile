import 'package:immoplus_pro/core/error/error_feedback.dart';
import 'package:immoplus_pro/core/error/error_messages.dart';
import 'package:immoplus_pro/core/error/error_context.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/features/my_feed/data/feed_repository.dart';
import 'package:immoplus_pro/features/my_feed/logic/my_feed_state.dart';

class MyFeedCubit extends Cubit<MyFeedState> {
  MyFeedCubit() : super(MyFeedInitial());

  Future<void> loadFeed() async {
    emit(MyFeedLoading());
    try {
      final response = await FeedRepository.getMyVideos();
      emit(MyFeedLoaded(
        videos: response.data,
        summary: response.summary,
        cursor: response.cursor,
        hasMore: response.hasMore,
      ));
    } catch (e) {
      ErrorFeedback.show(e, context: ErrorContext.feedLoad);
      emit(MyFeedError(ErrorMessages.messageOf(e, ErrorContext.feedLoad)));
    }
  }

  Future<void> deleteVideo(String id) async {
    try {
      await FeedRepository.deleteVideo(id);
    } catch (e) {
      ErrorFeedback.show(e, context: ErrorContext.feedLoad);
      return;
    }
    final current = state;
    if (current is MyFeedLoaded) {
      final updated = current.videos.where((v) => v.id != id).toList();
      emit(MyFeedLoaded(
        videos: updated,
        summary: current.summary,
        cursor: current.cursor,
        hasMore: current.hasMore,
      ));
    }
  }
}
