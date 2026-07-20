import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/data/models/rating/rating_model.dart';
import 'package:immoplus_pro/data/providers/rating_provider.dart';

class RatingRepository {
  static Future<RatingModel> submitRating({
    required Map<String, dynamic> data,
  }) async {
    try {
      final response = await RatingProvider(DioClient().dio).submitRating(data);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to submit rating: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to submit rating: $error');
    }
  }

  static Future<List<RatingModel>> getRatings({
    required int page,
    int? pageSize,
  }) async {
    try {
      final response = await RatingProvider(DioClient().dio)
          .getRatings(page, pageSize);
      return response.data;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to get ratings: ${dioError.message}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to get ratings: $error');
    }
  }
}
