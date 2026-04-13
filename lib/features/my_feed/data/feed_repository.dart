import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/features/my_feed/data/models/feed_video_dto.dart';

class FeedRepository {
  static Future<FeedResponse> getMyVideos({
    String? cursor,
    int limit = 20,
    String status = 'all',
  }) async {
    try {
      final response = await DioClient().dio.get(
        '/feed/my-videos',
        queryParameters: {
          'limit': limit,
          'status': status,
          if (cursor != null) 'cursor': cursor,
        },
      );
      return FeedResponse.fromJson(response.data);
    } on DioException catch (e) {
      log('DioError feed: ${e.message}');
      throw Exception('Erreur chargement feed: ${e.message}');
    } catch (e) {
      log('Error feed: $e');
      throw Exception('Erreur chargement feed: $e');
    }
  }

  static Future<void> retryEncoding(String videoId) async {
    await DioClient().dio.post('/feed/videos/$videoId/retry');
  }

  static Future<void> deleteVideo(String videoId) async {
    await DioClient().dio.delete('/feed/videos/$videoId');
  }
}
