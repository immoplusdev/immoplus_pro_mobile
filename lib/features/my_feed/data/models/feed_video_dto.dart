class FeedVideoDto {
  final String id;
  final String source;
  final String? videoUrl;
  final String? videoType;
  final List<int> availableBitrates;
  final Map<String, String> bitrateUrls;
  final String? thumbnailUrl;
  final String status; // ready, processing, failed, deleted
  final FeedContentDto content;
  final FeedStatsDto stats;
  final FeedRelatedToDto? relatedTo;
  final FeedAuthorDto? author;
  final String shortCode;
  final DateTime? createdAt;

  FeedVideoDto({
    required this.id,
    required this.source,
    this.videoUrl,
    this.videoType,
    this.availableBitrates = const [],
    this.bitrateUrls = const {},
    this.thumbnailUrl,
    required this.status,
    required this.content,
    required this.stats,
    this.relatedTo,
    this.author,
    required this.shortCode,
    this.createdAt,
  });

  factory FeedVideoDto.fromJson(Map<String, dynamic> json) {
    return FeedVideoDto(
      id: json['id'] ?? '',
      source: json['source'] ?? 'post',
      videoUrl: json['videoUrl'],
      videoType: json['videoType'],
      availableBitrates: (json['availableBitrates'] as List?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      bitrateUrls: (json['bitrateUrls'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v.toString())) ??
          {},
      thumbnailUrl: json['thumbnailUrl'],
      status: json['status'] ?? 'processing',
      content: FeedContentDto.fromJson(json['content'] ?? {}),
      stats: FeedStatsDto.fromJson(json['stats'] ?? {}),
      relatedTo: json['relatedTo'] != null
          ? FeedRelatedToDto.fromJson(json['relatedTo'])
          : null,
      author: json['author'] != null
          ? FeedAuthorDto.fromJson(json['author'])
          : null,
      shortCode: json['shortCode'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  bool get isReady => status == 'ready';
  bool get isProcessing => status == 'processing';
  bool get isFailed => status == 'failed';
  bool get isDeleted => status == 'deleted';
}

class FeedContentDto {
  final String title;
  final String description;
  final String price;
  final String location;

  FeedContentDto({
    required this.title,
    required this.description,
    required this.price,
    required this.location,
  });

  factory FeedContentDto.fromJson(Map<String, dynamic> json) {
    return FeedContentDto(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      location: json['location'] ?? '',
    );
  }
}

class FeedStatsDto {
  final int likes;
  final int views;
  final bool liked;

  FeedStatsDto({
    required this.likes,
    required this.views,
    required this.liked,
  });

  factory FeedStatsDto.fromJson(Map<String, dynamic> json) {
    return FeedStatsDto(
      likes: json['likes'] ?? 0,
      views: json['views'] ?? 0,
      liked: json['liked'] ?? false,
    );
  }
}

class FeedRelatedToDto {
  final String entity;
  final String id;

  FeedRelatedToDto({required this.entity, required this.id});

  factory FeedRelatedToDto.fromJson(Map<String, dynamic> json) {
    return FeedRelatedToDto(
      entity: json['entity'] ?? '',
      id: json['id'] ?? '',
    );
  }
}

class FeedAuthorDto {
  final String id;
  final String name;
  final String? avatar;

  FeedAuthorDto({required this.id, required this.name, this.avatar});

  factory FeedAuthorDto.fromJson(Map<String, dynamic> json) {
    return FeedAuthorDto(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'],
    );
  }
}

class FeedSummaryDto {
  final int totalVideos;
  final int totalViews;
  final int totalLikes;

  FeedSummaryDto({
    required this.totalVideos,
    required this.totalViews,
    required this.totalLikes,
  });

  factory FeedSummaryDto.fromJson(Map<String, dynamic> json) {
    return FeedSummaryDto(
      totalVideos: json['totalVideos'] ?? 0,
      totalViews: json['totalViews'] ?? 0,
      totalLikes: json['totalLikes'] ?? 0,
    );
  }
}

class FeedResponse {
  final List<FeedVideoDto> data;
  final FeedSummaryDto summary;
  final String? cursor;
  final bool hasMore;

  FeedResponse({
    required this.data,
    required this.summary,
    this.cursor,
    required this.hasMore,
  });

  factory FeedResponse.fromJson(Map<String, dynamic> json) {
    return FeedResponse(
      data: (json['data'] as List? ?? [])
          .map((e) => FeedVideoDto.fromJson(e))
          .where((v) => !v.isDeleted)
          .toList(),
      summary: FeedSummaryDto.fromJson(json['summary'] ?? {}),
      cursor: json['cursor'],
      hasMore: json['has_more'] ?? false,
    );
  }
}
