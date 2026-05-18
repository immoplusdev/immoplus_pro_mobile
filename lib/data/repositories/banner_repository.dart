import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/data/models/banners/banner_model.dart';
import 'package:immoplus_pro/data/providers/banner_provider.dart';

class BannerRepository {
  static Future<BannerResponse> getBanners({required String source}) async {
    try {
      final response = await BannerProvider(DioClient().dio).getBanners(source);
      return response;
    } on DioException catch (dioError) {
      log('DioError in BannerRepository: ${dioError.message}');
      throw Exception('Failed to load banners: ${dioError.message}');
    } catch (error) {
      log('Error in BannerRepository: $error');
      throw Exception('Failed to load banners: $error');
    }
  }
}
