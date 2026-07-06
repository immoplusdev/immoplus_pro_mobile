import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit_state.dart';
import 'package:immoplus_pro/cubits/authentification/verify_email_response.dart';
import 'package:immoplus_pro/data/models/auth/account_creation_response.dart';
import 'package:immoplus_pro/data/models/auth/enterprise_registration_body.dart';
import 'package:immoplus_pro/data/models/auth/particulier_registration_body.dart';
import 'package:immoplus_pro/data/models/auth/send_email_otp_body.dart';
import 'package:immoplus_pro/data/models/auth/verify_email_otp.dart';
import 'package:immoplus_pro/data/repositories/auth_repository.dart';
import 'package:immoplus_pro/data/schemas/user_model_schema.dart';
import 'package:immoplus_pro/features/home_v2/home_page_v2.dart';
import 'package:immoplus_pro/modules/files_uploader.dart/file_uploader_controller.dart';
import 'package:immoplus_pro/services/navigation_service.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/features/home_page/home_page.dart';
import 'package:immoplus_pro/services/analytics_service.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus_pro/data/models/auth/user_model.dart';

class RgistrationCubitCubit extends Cubit<RegistrationCubitState> {
  RgistrationCubitCubit() : super(const RegistrationCubitState.initial());

  Future<bool> userSendOTP({String? email, String? phoneNumber, bool? is_whatssap}) async {
    emit(const RegistrationCubitState.loading());
    try {
      final response = await AuthRepository().userSendOTP(
          body: SendEmailOtpBody(
              email: email, phoneNumber: phoneNumber, is_whatssap: is_whatssap));
      emit(RegistrationCubitState.initial());
      if ([200, 201].contains(response.response.statusCode)) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      emit(RegistrationCubitState.initial());
      return false;
    } catch (error) {
      log('Error: $error');
      emit(RegistrationCubitState.initial());
      return false;
    }
  }

  Future<VerifyEmailResponse?> verifyOtp(
      {String? email, String? phoneNumber, required String otp}) async {
    emit(const RegistrationCubitState.loading());
    try {
      final response = await AuthRepository().verifyOtp(
          body:
              VerifyEmailOtp(email: email, phoneNumber: phoneNumber, otp: otp));
      emit(RegistrationCubitState.initial());
      return response;
    } on DioException catch (dioError) {
      log('DioError: ${dioError.message}');
      emit(RegistrationCubitState.initial());
      return null;
    } catch (error) {
      log('Error: $error');
      emit(RegistrationCubitState.initial());
      return null;
    }
  }

  createEnterpriseAccount(
      {required EnterpriseRegistrationBody enterpriseRegistrationBody,
      required FileUploaderController fileUploaderController}) async {
    emit(const RegistrationCubitState.loading());
    try {
      // Réutilise l'upload déjà démarré en arrière-plan dès la sélection du
      // fichier (étape 2) au lieu d'en relancer un nouveau ici.
      final registreCommerceId = await fileUploaderController.ensureUploaded();
      log('registreCommerceId: $registreCommerceId', name: 'FIle Uploaded');
      final body = enterpriseRegistrationBody.copyWith(
          registreCommerceId: registreCommerceId);
      AccountCreationResponse response =
          await AuthRepository.registrationEnterprise(body: body);

      await SessionManager().saveUser(
        UserModelSchema()
          ..id = 1
          ..userId = response.data.user.id
          ..firstName = response.data.user.firstName
          ..lastName = response.data.user.lastName
          ..phoneNumber = response.data.user.phoneNumber
          ..email = response.data.user.email
          ..avatar = response.data.user.avatar
          ..accessToken = response.data.accessToken
          ..refreshToken = response.data.refreshToken
          ..roleName = response.data.user.role.name
          ..role = response.data.user.role.name
          ..activite = response.data.user.additionalData.activite
          ..nomEntreprise = response.data.user.additionalData.nomEntreprise
          ..emailEntreprise = response.data.user.additionalData.emailEntreprise
          ..identityVerified = response.data.user.identityVerified
          ..createdAt = response.data.user.createdAt,
      );
      _identifyAndLogSignUp(response.data.user, "email");
      getIt<AnalyticsService>().logKycSubmitted();
      EasyLoading.instance.backgroundColor = Colors.green.shade400;
      EasyLoading.showInfo("vous êtes inscript", dismissOnTap: true);
      emit(const RegistrationCubitState.initial());
      NavigationService.navigatorKey.currentContext!.goNamed(HomePageV2.name);
    } catch (e) {
      log(e.toString(), name: "ERROR BLOC");

      emit(const RegistrationCubitState.initial());
    }
  }

  createParticulierAccount(
      {required ParticulierRegistrationBody particulierRegistrationBody,
      required FileUploaderController fileUploaderControllerPhotoIdentite,
      required FileUploaderController fileUploaderControllerPieceIdentite,
      required FileUploaderController
          fileUploaderControllerPieceIdentiteVerso}) async {
    emit(const RegistrationCubitState.loading());
    try {
      // Réutilise les uploads déjà démarrés en arrière-plan dès la sélection
      // des fichiers (étapes 1 et 2) : ici on ne fait qu'attendre leur fin,
      // sans relancer un upload complet.
      final ids = await Future.wait([
        fileUploaderControllerPhotoIdentite.ensureUploaded(),
        fileUploaderControllerPieceIdentite.ensureUploaded(),
        fileUploaderControllerPieceIdentiteVerso.ensureUploaded(),
      ]);
      final photoIdentiteId = ids[0];
      final pieceIdentiteId = ids[1];
      final pieceIdentiteVersoId = ids[2];
      log('photoIdentiteId: $photoIdentiteId', name: 'FIle Uploaded');
      log('pieceIdentiteId: $pieceIdentiteId', name: 'FIle Uploaded');
      log('pieceIdentiteVersoId: $pieceIdentiteVersoId', name: 'FIle Uploaded');

      final body = particulierRegistrationBody.copyWith(
        pieceIdentiteId: pieceIdentiteId,
        pieceIdentiteVersoId: pieceIdentiteVersoId,
        photoIdentiteId: photoIdentiteId,
      );
      inspect(body);
      AccountCreationResponse response =
          await AuthRepository.registrationParticulier(body: body);

      await SessionManager().saveUser(
        UserModelSchema()
          ..id = 1
          ..userId = response.data.user.id
          ..avatar = response.data.user.avatar
          ..photoIdentite = response.data.user.additionalData.photoIdentiteId
          ..pieceIdentite = response.data.user.additionalData.pieceIdentiteId
          ..firstName = response.data.user.firstName
          ..lastName = response.data.user.lastName
          ..phoneNumber = response.data.user.phoneNumber
          ..email = response.data.user.email
          ..avatar = response.data.user.avatar
          ..accessToken = response.data.accessToken
          ..refreshToken = response.data.refreshToken
          ..roleName = response.data.user.role.name
          ..role = response.data.user.role.name
          ..activite = response.data.user.additionalData.activite
          ..nomEntreprise = response.data.user.additionalData.nomEntreprise
          ..photoIdentite = response.data.user.additionalData.photoIdentiteId
          ..pieceIdentite = response.data.user.additionalData.pieceIdentiteId
          ..emailEntreprise = response.data.user.additionalData.emailEntreprise
          ..identityVerified = response.data.user.identityVerified
          ..createdAt = response.data.user.createdAt,
      );
      _identifyAndLogSignUp(response.data.user, "email");
      getIt<AnalyticsService>().logKycSubmitted();
      emit(const RegistrationCubitState.initial());
      NavigationService.navigatorKey.currentContext!.goNamed(HomePageV2.name);
    } catch (e) {
      log(e.toString(), name: "ERROR BLOC");

      emit(const RegistrationCubitState.initial());
    }
  }

  Future<void> _identifyAndLogSignUp(UserModel user, String method) async {
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
        isProValidated: user.role.name != 'customer',
        accountStatus: user.status ?? 'activated',
        accountType: user.role.name ?? '',
        registrationDate: user.createdAt ?? '',
      );

      await getIt<AnalyticsService>().logSignUp(method: method);
    } catch (e) {
      log('GA4 error identify and log sign up: $e', name: 'ANALYTICS');
    }
  }
}
