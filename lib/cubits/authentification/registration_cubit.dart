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
import 'package:immoplus_pro/data/models/files/file_data_model.dart';
import 'package:immoplus_pro/data/repositories/auth_repository.dart';
import 'package:immoplus_pro/data/schemas/user_model_schema.dart';
import 'package:immoplus_pro/features/home_v2/home_page_v2.dart';
import 'package:immoplus_pro/modules/files_uploader.dart/file_uploader_controller.dart';
import 'package:immoplus_pro/services/navigation_service.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/features/home_page/home_page.dart';

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
      FileDataModel file = await fileUploaderController.upladFile();
      log(file.toString(), name: 'FIle Uploaded');
      final body = enterpriseRegistrationBody.copyWith(
          registreCommerceId: file.data!.id.toString());
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
          ..emailEntreprise = response.data.user.additionalData.emailEntreprise,
      );
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
      FileDataModel photoIdentite =
          await fileUploaderControllerPhotoIdentite.upladFile();
      log(photoIdentite.toString(), name: 'FIle Uploaded');
      FileDataModel pieceIdentite =
          await fileUploaderControllerPieceIdentite.upladFile();
      log(pieceIdentite.toString(), name: 'FIle Uploaded');
      // FileDataModel pieceIdentiteVerso =
      //     await fileUploaderControllerPieceIdentiteVerso.upladFile();
      // log(pieceIdentiteVerso.toString(), name: 'FIle Uploaded');

      final body = particulierRegistrationBody.copyWith(
        pieceIdentiteId: pieceIdentite.data!.id,
        // pieceIdentiteVersoId: pieceIdentiteVerso.data!.id,
        photoIdentiteId: photoIdentite.data!.id,
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
          ..emailEntreprise = response.data.user.additionalData.emailEntreprise,
      );
      emit(const RegistrationCubitState.initial());
      NavigationService.navigatorKey.currentContext!.goNamed(HomePageV2.name);
    } catch (e) {
      log(e.toString(), name: "ERROR BLOC");

      emit(const RegistrationCubitState.initial());
    }
  }
}
