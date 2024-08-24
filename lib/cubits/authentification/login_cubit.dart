import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/cubits/authentification/login_cubit_state.dart';
import 'package:immoplus_pro/data/models/auth/account_creation_response.dart';
import 'package:immoplus_pro/data/models/auth/login_body_model.dart';
import 'package:immoplus_pro/data/repositories/auth_repository.dart';
import 'package:immoplus_pro/data/schemas/user_model_schema.dart';
import 'package:immoplus_pro/services/navigation_service.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/views/home_page/home_page.dart';

class LoginCubit extends Cubit<LoginCubitState> {
  LoginCubit() : super(const LoginCubitState.initial());

  onSendData({required LoginBodyModel body}) async {
    emit(const LOGIN_LOADING());
    try {
      AccountCreationResponse response = await AuthRepository.login(body: body);

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
          ..photoIdentite = response.data.user.additionalData.photoIdentiteId
          ..pieceIdentite = response.data.user.additionalData.pieceIdentiteId
          ..emailEntreprise = response.data.user.additionalData.emailEntreprise,
      );
      emit(const LoginCubitState.success());
      NavigationService.navigatorKey.currentContext!.goNamed(HomePage.name);
    } catch (e) {
      emit(LoginCubitState.initial());
    }
  }
}
