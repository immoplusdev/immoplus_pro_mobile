// ignore_for_file: constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/common/enums.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/cubits/authentification/login_cubit_state.dart';
import 'package:immoplus_pro/data/models/auth/account_creation_response.dart';
import 'package:immoplus_pro/data/models/auth/login_body_model.dart';
import 'package:immoplus_pro/data/models/auth/login_otp_body.dart';
import 'package:immoplus_pro/data/models/auth/send_opt_model.dart';
import 'package:immoplus_pro/data/models/auth/update_user_dto.dart';
import 'package:immoplus_pro/data/models/auth/update_user_response_model.dart';
import 'package:immoplus_pro/data/repositories/auth_repository.dart';
import 'package:immoplus_pro/data/schemas/user_model_schema.dart';
import 'package:immoplus_pro/features/home_page/home_page.dart';
import 'package:immoplus_pro/features/home_page/utils/custom_popup.dart';
import 'package:immoplus_pro/services/navigation_service.dart';
import 'package:immoplus_pro/splash_screen.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/utils/status_code_handler.dart';
import 'package:toastification/toastification.dart';

class LoginCubit extends Cubit<LoginCubitState> {
  LoginCubit() : super(const LoginCubitState.initial());

  _checkRole(String? role) {
    if (role == Roles.customer.name) {
      toastification.show(
        type: ToastificationType.error,
        context: NavigationService.navigatorKey
            .currentContext, // optional if you use ToastificationWrapper
        title: const Text("Accès interdit"),
        description: const Text(
            "Vous devez disposer d'un compte professionnel ImmoPlus pour vous connecter à l'application."),
        autoCloseDuration: const Duration(seconds: 5),

        showProgressBar: false,
        alignment: Alignment.bottomCenter,
        style: ToastificationStyle.flatColored,
      );

      throw Exception(
          "Vous devez disposer d'un compte professionnel ImmoPlus pour vous connecter à l'application.");
    }
  }

  onSendData({required LoginBodyModel body}) async {
    emit(const LOGIN_LOADING());
    try {
      AccountCreationResponse response = await AuthRepository.login(body: body);

      _checkRole(response.data.user.role.name);
      await SessionManager().saveUser(
        UserModelSchema()
          ..id = 1
          ..userId = response.data.user.id
          ..firstName = response.data.user.firstName
          ..lastName = response.data.user.lastName
          ..role = response.data.user.role.name
          ..phoneNumber = response.data.user.phoneNumber
          ..email = response.data.user.email
          ..accessToken = response.data.accessToken
          ..refreshToken = response.data.refreshToken
          ..roleName = response.data.user.role.name
          ..activite = response.data.user.additionalData.activite
          ..nomEntreprise = response.data.user.additionalData.nomEntreprise
          ..photoIdentite = response.data.user.additionalData.photoIdentiteId
          ..pieceIdentite = response.data.user.additionalData.pieceIdentiteId
          ..emailEntreprise = response.data.user.additionalData.emailEntreprise,
      );
      //OneSignal.login(response.data.user.id ?? 'user');
      await SessionManager().getCurrentUser();
      DioClient.token = response.data.accessToken;
      DioClient().dio.options.headers['Authorization'] =
          'Bearer ${SessionManager().currentUser!.accessToken}';
      emit(const LoginCubitState.success());
      NavigationService.navigatorKey.currentContext!.goNamed(HomePage.name);
      if (NavigationService.navigatorKey.currentContext!.canPop()) {
        NavigationService.navigatorKey.currentContext!.pop();
      }
    } catch (e) {
      emit(const LoginCubitState.initial());
    }
  }

  sendOtp(
      {required SendOptModel body,
      required PageController pageController}) async {
    emit(const LOGIN_LOADING());
    final response = await AuthRepository.sendOtp(body: body);
    if (StatusCodeHandler.isSuccess(response.response.statusCode)) {
      emit(const LoginCubitState.initial());
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      CustomPopup.showErrorToast(
          text: 'Envoie du code échoué veuillez ressayer');
      emit(const LoginCubitState.initial());
    }
  }

  onSendOtpData({required LoginOtpBody body}) async {
    emit(const LOGIN_LOADING());
    try {
      AccountCreationResponse response =
          await AuthRepository.loginWithOtp(body: body);
      _checkRole(response.data.user.role.name);
      await SessionManager().saveUser(
        UserModelSchema()
          ..id = 1
          ..userId = response.data.user.id
          ..role = response.data.user.role.name
          ..firstName = response.data.user.firstName
          ..lastName = response.data.user.lastName
          ..phoneNumber = response.data.user.phoneNumber
          ..email = response.data.user.email
          ..accessToken = response.data.accessToken
          ..refreshToken = response.data.refreshToken
          ..roleName = response.data.user.role.name
          ..activite = response.data.user.additionalData.activite
          ..nomEntreprise = response.data.user.additionalData.nomEntreprise
          ..photoIdentite = response.data.user.additionalData.photoIdentiteId
          ..pieceIdentite = response.data.user.additionalData.pieceIdentiteId
          ..emailEntreprise = response.data.user.additionalData.emailEntreprise,
      );
      // OneSignal.login(response.data.user.id ?? 'user');
      await SessionManager().getCurrentUser();
      DioClient.token = response.data.accessToken;
      DioClient().dio.options.headers['Authorization'] =
          'Bearer ${SessionManager().currentUser!.accessToken}';
      emit(const LoginCubitState.success());
      NavigationService.navigatorKey.currentContext!.goNamed(SplashScreen.name);
    } catch (e) {
      emit(const LoginCubitState.initial());
    }
  }

  updateUserData({required UpdateUserDto body}) async {
    emit(const LOGIN_LOADING());
    try {
      UpdateUserResponseModel response = await AuthRepository.updateUser(
          userId: SessionManager().currentUser!.userId!, body: body);
      _checkRole(response.data.role.name);
      await SessionManager().saveUser(
        UserModelSchema()
          ..id = 1
          ..userId = response.data.id
          ..firstName = response.data.firstName
          ..role = response.data.role.name
          ..lastName = response.data.lastName
          ..avatar = response.data.avatar
          ..phoneNumber = response.data.phoneNumber
          ..email = response.data.email
          ..accessToken = SessionManager().currentUser!.accessToken
          ..refreshToken = SessionManager().currentUser!.refreshToken
          ..roleName = response.data.role.name
          ..activite = response.data.additionalData.activite
          ..nomEntreprise = response.data.additionalData.nomEntreprise
          ..photoIdentite = response.data.additionalData.photoIdentiteId
          ..pieceIdentite = response.data.additionalData.pieceIdentiteId
          ..emailEntreprise = response.data.additionalData.emailEntreprise,
      );
      // OneSignal.login(response.data.user.id ?? 'user');
      await SessionManager().getCurrentUser();

      emit(const LoginCubitState.success());
      NavigationService.navigatorKey.currentContext?.pop();
    } catch (e) {
      emit(const LoginCubitState.initial());
    }
  }
}
