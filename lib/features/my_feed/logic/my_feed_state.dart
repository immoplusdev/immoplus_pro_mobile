import 'package:immoplus_pro/features/my_feed/data/models/feed_video_dto.dart';

abstract class MyFeedState {}

class MyFeedInitial extends MyFeedState {}

class MyFeedLoading extends MyFeedState {}

class MyFeedLoaded extends MyFeedState {
  final List<FeedVideoDto> videos;
  final FeedSummaryDto summary;
  final String? cursor;
  final bool hasMore;

  MyFeedLoaded({
    required this.videos,
    required this.summary,
    this.cursor,
    required this.hasMore,
  });
}

class MyFeedError extends MyFeedState {
  final String message;
  MyFeedError(this.message);
}
