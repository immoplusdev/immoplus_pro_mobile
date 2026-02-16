import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/core/request_response_exeption.dart';
import 'package:immoplus_pro/cubits/authentification/social_login_body.dart';
import 'package:immoplus_pro/cubits/authentification/verify_email_response.dart';
import 'package:immoplus_pro/data/models/auth/account_creation_response.dart';
import 'package:immoplus_pro/data/models/auth/enterprise_registration_body.dart';
import 'package:immoplus_pro/data/models/auth/login_body_model.dart';
import 'package:immoplus_pro/data/models/auth/login_otp_body.dart';
import 'package:immoplus_pro/data/models/auth/particulier_registration_body.dart';
import 'package:immoplus_pro/data/models/auth/reset_password_body.dart';
import 'package:immoplus_pro/data/models/auth/send_email_otp_body.dart';
import 'package:immoplus_pro/data/models/auth/send_opt_model.dart';
import 'package:immoplus_pro/data/models/auth/update_password_body.dart';
import 'package:immoplus_pro/data/models/auth/update_user_dto.dart';
import 'package:immoplus_pro/data/models/auth/update_user_response_model.dart';
import 'package:immoplus_pro/data/models/auth/verify_email_body.dart';
import 'package:immoplus_pro/data/models/auth/verify_email_otp.dart';
import 'package:immoplus_pro/data/models/configs/config_model.dart';
import 'package:immoplus_pro/data/models/files/file_data_model.dart';
import 'package:immoplus_pro/data/providers/auth_provider.dart';
import 'package:retrofit/retrofit.dart';

class AuthRepository {
  static Future<FileDataModel> uplaodFile({required File file}) async {
    try {
      final response = await AuthProvider(DioClient().dio).uploadImage(file);
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

  static Future<UpdateUserResponseModel> updateUser(
      {required String userId, required UpdateUserDto body}) async {
    try {
      final response =
          await AuthProvider(DioClient().dio).updateUser(userId, body);
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

  static Future<HttpResponse> sendOtp({required SendOptModel body}) async {
    try {
      final response = await AuthProvider(DioClient().dio).sendOtp(body);
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

  static Future<AccountCreationResponse> loginWithOtp(
      {required LoginOtpBody body}) async {
    try {
      final response = await AuthProvider(DioClient().dio).loginOtp(body);
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

// Étape 1: Envoyer l'OTP par email
  static Future<HttpResponse> sendEmailOtp(
      {required SendEmailOtpBody body}) async {
    try {
      final response = await AuthProvider(DioClient().dio).sendEmailOtp(body);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to send email OTP: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to send email OTP: $error');
    }
  }

// Étape 2: Vérifier l'email avec l'OTP
  @Deprecated(
      'La vérification OTP se fait maintenant directement dans resetPassword.')
  static Future<HttpResponse> verifyEmailOtp(
      {required VerifyEmailBody body}) async {
    try {
      final response = await AuthProvider(DioClient().dio).verifyEmail(body);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to verify email: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to verify email: $error');
    }
  }

// Étape 3: Réinitialiser le mot de passe
  static Future<HttpResponse> resetPassword(
      {required ResetPasswordBody body}) async {
    try {
      final response = await AuthProvider(DioClient().dio).resetPassword(body);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to reset password: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to reset password: $error');
    }
  }

  static Future<HttpResponse> updatePassword(
      {required UpdatePasswordBody body}) async {
    try {
      final response = await AuthProvider(DioClient().dio).updatePassword(body);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to updatePassword password: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to updatePassword password: $error');
    }
  }

  Future<HttpResponse> userSendOTP({required SendEmailOtpBody body}) async {
    try {
      final response = await AuthProvider(DioClient().dio).userSendOTP(body);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to send email OTP: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to send email OTP: $error');
    }
  }

  Future<VerifyEmailResponse?> verifyOtp({required VerifyEmailOtp body}) async {
    try {
      final response = await AuthProvider(DioClient().dio).verifyOtp(body);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to send email OTP: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to send email OTP: $error');
    }
  }

  static Future<HttpResponse> deleteAccount({required String userId}) async {
    try {
      final response =
          await AuthProvider(DioClient().dio).deleteAccount(userId);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      throw Exception('Failed to delete account: ${dioError.message}');
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to delete account: $error');
    }
  }

  Future<AccountCreationResponse> socialLogin(
      {required SocialLoginBody body}) async {
    try {
      final response = await AuthProvider(DioClient().dio).socialLogin(body);
      inspect(response);
      return response;
    } on DioException catch (_) {
      rethrow;
    } on RequestResponseExeption catch (requestResponseExeption) {
      EasyLoading.showError(requestResponseExeption.toString());
      log("RequestResponseExeption");
      throw Exception('Failed : ${requestResponseExeption.toString()}');
    } catch (error) {
      log('Error: $error');
      throw Exception('Failed to social login: $error');
    }
  }

  Future<ConfigModel> getConfig() async {
    try {
      final response = await AuthProvider(DioClient().dio).getCongig();
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
}
