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
      emit(MyFeedError(e.toString()));
    }
  }

  Future<void> deleteVideo(String id) async {
    await FeedRepository.deleteVideo(id);
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
