import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:immoplus_pro/app_router.dart';
import 'package:immoplus_pro/request_path.dart';
import 'package:immoplus_pro/services/navigation_service.dart';
import 'package:immoplus_pro/views/login_page/login_page.dart';

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
        'Authorization': 'Bearer $token',
      },
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    );

    // Ajouter des interceptors
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        log(options.method, name: 'METHOD');
        log("${options.baseUrl}${options.path} ", name: 'URL');
        String header = _addIndentation(options.headers.toString(), 2);
        log(header, name: 'HEADER');
        String jsonString = _addIndentation(options.data.toString(), 2);
        log(jsonString, name: 'BODY DATA');
        String param = _addIndentation(options.queryParameters.toString(), 2);
        log(param, name: 'PARAMS DATA');

        return handler.next(options); // Continuez l'envoi de la requête
      },
      onResponse: (response, handler) {
        inspect(response);
        log(response.statusCode.toString(), name: 'RESPONSE STATUS');
        String jsonString = _addIndentation(response.data.toString(), 2);
        log(jsonString, name: 'RESPONSE DATA');

        return handler.next(response);
      },
      onError: (DioException error, handler) {
        log(error.response!.data.toString(), name: "Response Error");
        if (error.response != null) {
          if (error.response!.statusCode == 401) {
            AppRouter.router.goNamed(LoginPage.name);
          }
        }

        if (error.response!.data['message'] != null) {
          EasyLoading.instance.backgroundColor = Colors.red.shade400;
          EasyLoading.showToast(error.response!.data['message'].toString(),
              toastPosition: EasyLoadingToastPosition.bottom);
        }

        return handler.next(error); // Continuez à renvoyer l'erreur
      },
    ));
  }

  Dio get dio => _dio;

  void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
    _baseUrlChangesCount++;
    log('Base URL updated to: $newBaseUrl');
  }

  int get baseUrlChangesCount => _baseUrlChangesCount;
}

String _addIndentation(String jsonString, int indentation) {
  StringBuffer indentedJson = StringBuffer();
  String indent = ' ' * indentation;

  int nestingLevel = 0;
  for (int i = 0; i < jsonString.length; i++) {
    String char = jsonString[i];

    if (char == '{' || char == '[') {
      nestingLevel++;
      indentedJson.write(char);
      indentedJson.write('\n${indent * nestingLevel}');
    } else if (char == '}' || char == ']') {
      nestingLevel--;
      indentedJson.write('\n${indent * nestingLevel}');
      indentedJson.write(char);
    } else if (char == ',') {
      indentedJson.write(char);
      indentedJson.write('\n${indent * nestingLevel}');
    } else {
      indentedJson.write(char);
    }
  }

  return indentedJson.toString();
}
