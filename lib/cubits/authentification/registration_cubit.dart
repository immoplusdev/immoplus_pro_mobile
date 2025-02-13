import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit_state.dart';
import 'package:immoplus_pro/data/models/auth/account_creation_response.dart';
import 'package:immoplus_pro/data/models/auth/enterprise_registration_body.dart';
import 'package:immoplus_pro/data/models/auth/particulier_registration_body.dart';
import 'package:immoplus_pro/data/models/files/file_data_model.dart';
import 'package:immoplus_pro/data/repositories/auth_repository.dart';
import 'package:immoplus_pro/data/schemas/user_model_schema.dart';
import 'package:immoplus_pro/modules/files_uploader.dart/file_uploader_controller.dart';
import 'package:immoplus_pro/services/navigation_service.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/features/home_page/home_page.dart';

class RgistrationCubitCubit extends Cubit<RegistrationCubitState> {
  RgistrationCubitCubit() : super(const RegistrationCubitState.initial());

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
          ..accessToken = response.data.accessToken
          ..refreshToken = response.data.refreshToken
          ..roleName = response.data.user.role.name
          ..activite = response.data.user.additionalData.activite
          ..nomEntreprise = response.data.user.additionalData.nomEntreprise
          ..emailEntreprise = response.data.user.additionalData.emailEntreprise,
      );
      EasyLoading.instance.backgroundColor = Colors.green.shade400;
      EasyLoading.showInfo("vous êtes inscript", dismissOnTap: true);
      emit(const RegistrationCubitState.initial());
      NavigationService.navigatorKey.currentContext!.goNamed(HomePage.name);
    } catch (e) {
      log(e.toString(), name: "ERROR BLOC");

      emit(const RegistrationCubitState.initial());
    }
  }

  createParticulierAccount(
      {required ParticulierRegistrationBody particulierRegistrationBody,
      required FileUploaderController fileUploaderControllerPhotoIdentite,
      required FileUploaderController
          fileUploaderControllerPieceIdentite}) async {
    emit(const RegistrationCubitState.loading());
    try {
      FileDataModel photoIdentite =
          await fileUploaderControllerPhotoIdentite.upladFile();
      log(photoIdentite.toString(), name: 'FIle Uploaded');
      FileDataModel pieceIdentite =
          await fileUploaderControllerPieceIdentite.upladFile();
      log(pieceIdentite.toString(), name: 'FIle Uploaded');

      final body = particulierRegistrationBody.copyWith(
        pieceIdentiteId: pieceIdentite.data!.id,
        photoIdentiteId: photoIdentite.data!.id,
      );
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
          ..accessToken = response.data.accessToken
          ..refreshToken = response.data.refreshToken
          ..roleName = response.data.user.role.name
          ..activite = response.data.user.additionalData.activite
          ..nomEntreprise = response.data.user.additionalData.nomEntreprise
          ..photoIdentite = response.data.user.additionalData.photoIdentiteId
          ..pieceIdentite = response.data.user.additionalData.pieceIdentiteId
          ..emailEntreprise = response.data.user.additionalData.emailEntreprise,
      );
      emit(const RegistrationCubitState.initial());
      NavigationService.navigatorKey.currentContext!.goNamed(HomePage.name);
    } catch (e) {
      log(e.toString(), name: "ERROR BLOC");

      emit(const RegistrationCubitState.initial());
    }
  }
}
