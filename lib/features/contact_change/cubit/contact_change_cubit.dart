import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/data/enums/contact_change_type.dart';
import 'package:immoplus_pro/data/models/auth/contact_change_models.dart';
import 'package:immoplus_pro/data/repositories/auth_repository.dart';
import 'package:immoplus_pro/data/schemas/user_model_schema.dart';
import 'package:immoplus_pro/features/contact_change/cubit/contact_change_state.dart';
import 'package:immoplus_pro/utils/phone_number_handler.dart';
import 'package:immoplus_pro/utils/session_manager.dart';

class ContactChangeCubit extends Cubit<ContactChangeState> {
  ContactChangeCubit() : super(ContactChangeInitial());

  /// Étape 1 — Demande OTP
  Future<void> requestChange({
    required ContactChangeType type,
    String? phoneNumber,
    String? email,
  }) async {
    emit(ContactChangeRequestLoading());
    try {
      final cleanPhone = phoneNumber != null
          ? PhoneNumberHandler.formatPhoneNumber(phoneNumber)
          : null;

      final body = RequestContactChangeBody(
        type: type.toJson,
        phoneNumber: type == ContactChangeType.phone ? cleanPhone : null,
        email: type == ContactChangeType.email ? email : null,
      );

      await AuthRepository.requestContactChange(body: body);
      emit(ContactChangeRequestSuccess(type));
    } catch (e) {
      log('ContactChangeCubit.requestChange error: $e');
      emit(ContactChangeRequestError(e.toString()));
    }
  }

  /// Étape 2 — Confirmation OTP
  Future<void> confirmChange({
    required ContactChangeType type,
    required String otp,
  }) async {
    emit(ContactChangeConfirmLoading());
    try {
      final body = ConfirmContactChangeBody(
        type: type.toJson,
        otp: otp,
      );
      final response = await AuthRepository.confirmContactChange(body: body);

      // Mise à jour de la session locale (même pattern que updateUserData dans LoginCubit)
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
      await SessionManager().getCurrentUser();

      emit(ContactChangeConfirmSuccess('Modification effectuée avec succès'));
    } catch (e) {
      log('ContactChangeCubit.confirmChange error: $e');
      emit(ContactChangeConfirmError(e.toString()));
    }
  }
}
