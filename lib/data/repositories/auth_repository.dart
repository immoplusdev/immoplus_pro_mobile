import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:immoplus_pro/core/dio_client.dart';
import 'package:immoplus_pro/core/request_response_exeption.dart';
import 'package:immoplus_pro/data/models/auth/account_creation_response.dart';
import 'package:immoplus_pro/data/models/auth/enterprise_registration_body.dart';
import 'package:immoplus_pro/data/models/auth/login_body_model.dart';
import 'package:immoplus_pro/data/models/auth/particulier_registration_body.dart';
import 'package:immoplus_pro/data/models/files/file_data_model.dart';
import 'package:immoplus_pro/data/providers/auth_provider.dart';

class AuthRepository {
  static Future<FileDataModel> uplaodFile({required File file}) async {
    try {
      final response =
          await compute(AuthProvider(DioClient().dio).uploadImage, file);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }

  static Future<AccountCreationResponse> registrationEnterprise(
      {required EnterpriseRegistrationBody body}) async {
    try {
      final response =
          await AuthProvider(DioClient().dio).registrationEnterprise(body);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }

  static Future<AccountCreationResponse> registrationParticulier(
      {required ParticulierRegistrationBody body}) async {
    try {
      final response =
          await AuthProvider(DioClient().dio).registrationParticulier(body);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }

  static Future<AccountCreationResponse> login(
      {required LoginBodyModel body}) async {
    try {
      final response = await AuthProvider(DioClient().dio).login(body);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      // Gérer les exceptions Dio ici
      log('DioError: ${dioError.message}');
      throw Exception('Failed to load users: ${dioError.message}');
    } catch (error) {
      inspect(error);
      // Gérer d'autres types d'exceptions ici
      log('Error: $error');
      throw Exception('Failed to load users: $error');
    }
  }
}
