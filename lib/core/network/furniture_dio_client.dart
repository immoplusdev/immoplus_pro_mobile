import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus_pro/core/network/interceptors/auth_interceptor.dart';
import 'package:immoplus_pro/core/network/interceptors/error_interceptor.dart';
import 'package:immoplus_pro/core/network/interceptors/request_interceptor.dart';


class FurnitureDioClient {
  static final FurnitureDioClient _instance = FurnitureDioClient._internal();
  late Dio _dio;

  static const String _baseUrl = String.fromEnvironment('API_BASE_URL');

  factory FurnitureDioClient() {
    return _instance;
  }

  FurnitureDioClient._internal() {
    _dio = Dio();
    _configureDio();
  }

  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: _baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': '*/*',
      },
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    );

    _dio.interceptors.addAll([
      AuthInterceptor(),
      RequestInterceptor(),
      ErrorInterceptor(),
    ]);

    log('FurnitureDioClient configuré → $_baseUrl', name: 'FURNITURE_DIO');
  }

  Dio get dio => _dio;

  String get baseUrl => _baseUrl;
}
