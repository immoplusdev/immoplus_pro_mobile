import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus_pro/core/network/interceptors/auth_interceptor.dart';
import 'package:immoplus_pro/core/network/interceptors/error_interceptor.dart';
import 'package:immoplus_pro/core/network/interceptors/request_interceptor.dart';
import 'package:immoplus_pro/request_path.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late Dio _dio;
  int _baseUrlChangesCount = 0;
  static String? token;
  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    _dio = Dio();
    _configureDio();
  }

  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: RequestPath.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    );

    // Ajouter des interceptors
    _dio.interceptors
        .addAll([AuthInterceptor(), RequestInterceptor(), ErrorInterceptor()]);
  }

  Dio get dio => _dio;

  void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
    _baseUrlChangesCount++;
    log('Base URL updated to: $newBaseUrl');
  }

  int get baseUrlChangesCount => _baseUrlChangesCount;
}
