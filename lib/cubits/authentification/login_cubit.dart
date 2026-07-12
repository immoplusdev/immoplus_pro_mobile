// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:immoplus_pro/common/account_source.dart';
import 'package:immoplus_pro/common/enums.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/cubits/authentification/login_cubit_state.dart';
import 'package:immoplus_pro/cubits/authentification/social_body_enum.dart';
import 'package:immoplus_pro/cubits/authentification/social_login_body.dart';
import 'package:immoplus_pro/data/enums/api_error_code.dart';
import 'package:immoplus_pro/data/models/auth/account_creation_response.dart';
import 'package:immoplus_pro/data/models/auth/login_body_model.dart';
import 'package:immoplus_pro/data/models/auth/login_otp_body.dart';
import 'package:immoplus_pro/data/models/auth/send_opt_model.dart';
import 'package:immoplus_pro/data/models/auth/update_user_dto.dart';
import 'package:immoplus_pro/data/models/auth/update_user_response_model.dart';
import 'package:immoplus_pro/data/models/error/api_error_response.dart';
import 'package:immoplus_pro/data/repositories/auth_repository.dart';
import 'package:immoplus_pro/data/schemas/user_model_schema.dart';
import 'package:immoplus_pro/features/authentification/choose_account_type_page.dart';
import 'package:immoplus_pro/features/home_page/home_page.dart';
import 'package:immoplus_pro/features/home_v2/home_page_v2.dart';
import 'package:immoplus_pro/utils/easy_loading_handler.dart';
import 'package:immoplus_pro/features/registration/models/data_router_registration.dart';
import 'package:immoplus_pro/services/navigation_service.dart';
import 'package:immoplus_pro/services/notification_service.dart';
import 'package:immoplus_pro/splash_screen.dart';
import 'package:immoplus_pro/utils/api_error_dialog.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/utils/status_code_handler.dart';
import 'package:immoplus_pro/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus_pro/services/analytics_service.dart';
import 'package:immoplus_pro/data/models/auth/user_model.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialLoginUser {
  final String? firstName;
  final String? phoneNumber;
  final String email;
  final String? lastName;
  final String? provider;

  SocialLoginUser(
      {this.firstName,
      required this.email,
      this.lastName,
      this.phoneNumber,
      required this.provider});
}

class LoginCubit extends Cubit<LoginCubitState> {
  LoginCubit() : super(const LoginCubitState.initial());
  SocialLoginUser? socialLoginUser;

  _checkRole(String? role) {
    if (role == Roles.customer.name) {
      ApiErrorDialog.showForCode(ApiErrorCode.forbidden);

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
          ..avatar = response.data.user.avatar
          ..accessToken = response.data.accessToken
          ..refreshToken = response.data.refreshToken
          ..roleName = response.data.user.role.name
          ..activite = response.data.user.additionalData.activite
          ..nomEntreprise = response.data.user.additionalData.nomEntreprise
          ..photoIdentite = response.data.user.additionalData.photoIdentiteId
          ..pieceIdentite = response.data.user.additionalData.pieceIdentiteId
          ..emailEntreprise = response.data.user.additionalData.emailEntreprise
          ..identityVerified = response.data.user.identityVerified
          ..createdAt = response.data.user.createdAt,
      );
      //OneSignal.login(response.data.user.id ?? 'user');
      await SessionManager().getCurrentUser();
      _identifyAndLogLogin(response.data.user, "email");
      DioClient.token = response.data.accessToken;
      DioClient().dio.options.headers['Authorization'] =
          'Bearer ${SessionManager().currentUser!.accessToken}';
      emit(const LoginCubitState.success());
      getIt<NotificationService>().suscribeCurrentUser();
      NavigationService.navigatorKey.currentContext!.goNamed(HomePageV2.name);
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
      EasyLoadingHandler.showErrorToast(
          text: 'Envoie du code échoué veuillez ressayer');
      emit(const LoginCubitState.initial());
    }
  }

  Future<bool> onSendOtpData({required LoginOtpBody body}) async {
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
          ..avatar = response.data.user.avatar
          ..accessToken = response.data.accessToken
          ..refreshToken = response.data.refreshToken
          ..roleName = response.data.user.role.name
          ..activite = response.data.user.additionalData.activite
          ..nomEntreprise = response.data.user.additionalData.nomEntreprise
          ..photoIdentite = response.data.user.additionalData.photoIdentiteId
          ..pieceIdentite = response.data.user.additionalData.pieceIdentiteId
          ..emailEntreprise = response.data.user.additionalData.emailEntreprise
          ..identityVerified = response.data.user.identityVerified
          ..createdAt = response.data.user.createdAt,
      );
      // OneSignal.login(response.data.user.id ?? 'user');
      await SessionManager().getCurrentUser();
      _identifyAndLogLogin(response.data.user, "otp");
      DioClient.token = response.data.accessToken;
      DioClient().dio.options.headers['Authorization'] =
          'Bearer ${SessionManager().currentUser!.accessToken}';
      emit(const LoginCubitState.success());
      NavigationService.navigatorKey.currentContext!.goNamed(SplashScreen.name);
      return true;
    } catch (e) {
      emit(const LoginCubitState.initial());
      return false;
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
          ..avatar = response.data.avatar
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
    } catch (e) {
      emit(const LoginCubitState.initial());
    }
  }

  Future<void> signInWithGoogle() async {
    emit(const LOGIN_LOADING());
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

      await _googleSignIn.initialize();
      _googleSignIn.signOut();

      final List<String> scopes = [
        'https://www.googleapis.com/auth/userinfo.email',
      ];

      final GoogleSignInAccount? googleUser = await _googleSignIn.authenticate(
        scopeHint: scopes,
      );

      if (googleUser == null) {
        // L'utilisateur a annulé la connexion
        emit(const LoginCubitState.initial());
        return;
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      socialLoginUser = SocialLoginUser(
        firstName: googleUser.displayName?.split(' ').first ?? '',
        lastName: googleUser.displayName?.split(' ').last ?? '',
        email: googleUser.email,
        provider: SocialProviderEnum.google.value,
      );
      // Appel à l'API avec le token Google
      final body = SocialLoginBody(
        provider: SocialProviderEnum.google.value,
        token: googleAuth.idToken ?? '',
        email: googleUser.email,
        source: AccountSource.proApp.value,
      );

      await _performSocialLogin(body);
    } catch (e, s) {
      log(" Error Google Sign-In: $e ", stackTrace: s);
      if (e is GoogleSignInException &&
          e.code == GoogleSignInExceptionCode.canceled) {
        // L'utilisateur a annulé la connexion
        emit(const LoginCubitState.initial());
        return;
      }
      EasyLoadingHandler.showErrorToast(
          text: 'Erreur lors de la connexion avec Google');
      emit(const LoginCubitState.initial());
    }
  }

  Future<void> signInWithFacebook() async {
    emit(const LOGIN_LOADING());
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;

        // Récupérer les infos utilisateur
        final userData = await FacebookAuth.instance.getUserData(
          fields: "email,name",
        );

        final body = SocialLoginBody(
          provider: SocialProviderEnum.facebook.value,
          token: accessToken.tokenString,
          email: userData['email'] ?? '',
          source: AccountSource.proApp.value,
        );

        await _performSocialLogin(body);
      } else if (result.status == LoginStatus.cancelled) {
        emit(const LoginCubitState.initial());
      } else {
        EasyLoadingHandler.showErrorToast(
            text: 'Erreur lors de la connexion avec Facebook');
        emit(const LoginCubitState.initial());
      }
    } catch (e) {
      EasyLoadingHandler.showErrorToast(
          text: 'Erreur lors de la connexion avec Facebook');
      emit(const LoginCubitState.initial());
    }
  }

  Future<void> signInWithApple() async {
    emit(const LOGIN_LOADING());
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      inspect(credential);

      final emailFromToken =
          credential.email ?? _extractEmailFromToken(credential.identityToken);
      socialLoginUser = SocialLoginUser(
        firstName: credential.givenName,
        lastName: credential.familyName,
        email: emailFromToken ?? '',
        provider: SocialProviderEnum.apple.value,
      );

      if (emailFromToken == null) {
        EasyLoadingHandler.showErrorToast(
            text: "Impossible d'obtenir l'adresse email de votre compte apple");
        emit(const LoginCubitState.initial());
        return;
      }
      final body = SocialLoginBody(
        provider: SocialProviderEnum.apple.value,
        token: credential.identityToken ?? '',
        email: emailFromToken,
        source: AccountSource.proApp.value,
      );

      await _performSocialLogin(body);
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        emit(const LoginCubitState.initial());
        return;
      }
      EasyLoadingHandler.showErrorToast(
          text: 'Erreur lors de la connexion avec Apple');
      emit(const LoginCubitState.initial());
    } catch (e, s) {
      log('Error Apple Sign-In: $e', stackTrace: s);
      EasyLoadingHandler.showErrorToast(
          text: 'Erreur lors de la connexion avec Apple');
      emit(const LoginCubitState.initial());
    }
  }

  String? _extractEmailFromToken(String? identityToken) {
    if (identityToken == null) return null;
    try {
      final parts = identityToken.split('.');
      if (parts.length < 2) return null;
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final Map<String, dynamic> data = jsonDecode(payload);
      return data['email'] as String?;
    } catch (_) {
      return null;
    }
  }

// Méthode commune pour les connexions sociales
  Future<void> _performSocialLogin(SocialLoginBody body) async {
    try {
      AccountCreationResponse response =
          await AuthRepository().socialLogin(body: body);

      await SessionManager().saveUser(
        UserModelSchema()
          ..id = 1
          ..userId = response.data.user.id
          ..role = response.data.user.role.name
          ..firstName = response.data.user.firstName
          ..lastName = response.data.user.lastName
          ..phoneNumber = response.data.user.phoneNumber
          ..email = response.data.user.email
          ..avatar = response.data.user.avatar
          ..accessToken = response.data.accessToken
          ..refreshToken = response.data.refreshToken
          ..roleName = response.data.user.role.name
          ..activite = response.data.user.additionalData.activite
          ..nomEntreprise = response.data.user.additionalData.nomEntreprise
          ..photoIdentite = response.data.user.additionalData.photoIdentiteId
          ..pieceIdentite = response.data.user.additionalData.pieceIdentiteId
          ..emailEntreprise = response.data.user.additionalData.emailEntreprise
          ..identityVerified = response.data.user.identityVerified
          ..createdAt = response.data.user.createdAt,
      );

      final sessionManager = SessionManager();

      await sessionManager.getCurrentUser();
      _identifyAndLogLogin(response.data.user, body.provider ?? "social");
      DioClient().dio.options.headers['Authorization'] =
          'Bearer ${sessionManager.currentUser!.accessToken}';
      emit(const LoginCubitState.success());
      getIt<NotificationService>().suscribeCurrentUser();
      NavigationService.navigatorKey.currentContext!.goNamed(HomePageV2.name);
    } on DioException catch (e) {
      final errorData = e.response?.data;
      final errorResponse = ApiErrorResponse.fromJson(errorData);
      if (errorResponse.errorCode == ApiErrorCode.socialAccountNotFound) {
        emit(const LoginCubitState.initial());
        _redirectToSocialRegistration(body);
        return;
      }
      log('❌ Erreur social login: $e');
    } catch (e) {
      log('❌ Erreur inattendue: $e');
    } finally {
      emit(const LoginCubitState.initial());
    }
  }

  void _redirectToSocialRegistration(SocialLoginBody socialBody) {
    // Récupérer les infos depuis le token si besoin
    final context = NavigationService.navigatorKey.currentContext;

    if (context == null) return;
    context.pushNamed(ChooseAccountTypePage.name,
        extra: DataRouterRegistration(
          email: socialBody.email,
          token: socialBody.token,
          firstName: socialLoginUser?.firstName,
          lastName: socialLoginUser?.lastName,
          provider: socialLoginUser?.provider,
        ));
  }

  Future<void> _identifyAndLogLogin(UserModel user, String method) async {
    try {
      int totalPropertiesCount = 0;
      try {
        final collection = await BienImmobilierRepository.getBiensImmobiliers(page: 1, perPage: 1);
        totalPropertiesCount = collection.totalCount ?? 0;
      } catch (e) {
        log('GA4 identify error fetching properties: $e', name: 'ANALYTICS');
      }

      await getIt<AnalyticsService>().identifyUser(
        userId: user.id ?? '',
        totalProperties: totalPropertiesCount,
        kycStatus: (user.identityVerified == true) ? 'validated' : 'not_validated',
        isProValidated: user.role.name != Roles.customer.name,
        accountStatus: user.status ?? 'activated',
        accountType: user.role.name ?? '',
        registrationDate: user.createdAt ?? '',
      );

      await getIt<AnalyticsService>().logLogin(method: method);
    } catch (e) {
      log('GA4 error identify and log login: $e', name: 'ANALYTICS');
    }
  }
}
