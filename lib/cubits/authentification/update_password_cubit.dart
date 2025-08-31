import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/cubits/authentification/update_password_cubit_state.dart';
import 'package:immoplus_pro/data/models/auth/update_password_body.dart';
import 'package:immoplus_pro/data/repositories/auth_repository.dart';

class UpdatePasswordCubit extends Cubit<UpdatePasswordCubitState> {
  UpdatePasswordCubit() : super(const UpdatePasswordCubitState.initial());

  Future<void> updatePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(const UpdatePasswordCubitState.submitting());

    try {
      final body = UpdatePasswordBody(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      await AuthRepository.updatePassword(body: body);

      emit(const UpdatePasswordCubitState.success(
        message: "Mot de passe mis à jour avec succès.",
      ));
      log('Password updated', name: 'UPDATE_PASSWORD_CUBIT');
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      emit(UpdatePasswordCubitState.error(errorMessage: msg));
      log('Update password failed: $msg', name: 'UPDATE_PASSWORD_CUBIT');
    }
  }

  void resetState() => emit(const UpdatePasswordCubitState.initial());
}
