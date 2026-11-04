import 'package:immoplus_pro/core/error/app_error_mapper.dart';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/data/models/rating/host_rating_request_dto.dart';
import 'package:immoplus_pro/data/models/rating/rating_model.dart';
import 'package:immoplus_pro/data/providers/rating_provider.dart';

class RatingRepository {
  static Future<RatingModel> submitRating({
    required HostRatingRequestDto dto,
  }) async {
    try {
      final response = await RatingProvider(DioClient().dio).submitRating(dto);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
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
      throw AppErrorMapper.from(dioError);
    } catch (error) {
      log('Error: $error');
      throw AppErrorMapper.from(error);
    }
  }
}
