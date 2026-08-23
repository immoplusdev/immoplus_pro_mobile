import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:immoplus_pro/data/schemas/user_model_schema.dart';
import 'package:immoplus_pro/utils/session_manager.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    UserModelSchema? data = await SessionManager().getCurrentUser();

    if (data != null) {
      final token = data.accessToken;
      options.headers['Authorization'] = 'Bearer $token';
      if (kDebugMode) {
        debugPrint('🔑 accessToken: $token');
      }
    }
    super.onRequest(options, handler);
  }
}
