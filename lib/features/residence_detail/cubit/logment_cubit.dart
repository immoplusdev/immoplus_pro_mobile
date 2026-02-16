import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/data/models/residence/residence_response.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';

class LogmentCubit extends Cubit<RequestState> {
  LogmentCubit() : super(const REQUEST_INITIAL());

  getResidence({required String id}) async {
    emit(const REQUEST_LOADING());
    try {
      ResidenceResponse residenceResponse =
          await LogmentRepository.getResidence(id);

      emit(RequestState.residence(data: residenceResponse.data));
    } catch (e) {
      emit(RequestState.error(error: e.toString()));
    }
  }

  updateResidence(
      {required String id, required Map<String, dynamic> datas}) async {
    emit(const REQUEST_LOADING());
    try {
      ResidenceResponse residenceResponse =
          await LogmentRepository.updateResidence(id: id, fields: datas);

      emit(RequestState.residence(data: residenceResponse.data));
    } catch (e) {
      emit(RequestState.error(error: e.toString()));
    }
  }

  deleteResidence({required String id}) async {
    emit(const RequestState.loading());
    try {
      bool isDeleted = await LogmentRepository.deleteResidence(id: id);

      if (isDeleted) {
        emit(const RequestState.success(
            message: "Résidence supprimée avec succès"));
      } else {
        emit(const RequestState.error(
            error: "Échec de la suppression de la résidence"));
      }
    } catch (e) {
      emit(RequestState.error(error: e.toString()));
    }
  }

  addUnavailabilityDates({
    required String id,
    required List<String> dates,
  }) async {
    emit(const REQUEST_LOADING());
    try {
      ResidenceResponse residenceResponse =
          await LogmentRepository.addUnavailabilityDates(
        id: id,
        dates: dates,
      );
      emit(RequestState.success(
          message: "Dates d'indisponibilité ajoutées avec succès"));
      emit(RequestState.residence(data: residenceResponse.data));
    } catch (e) {
      emit(RequestState.error(error: e.toString()));
    }
  }

  removeUnavailabilityDates({
    required String id,
    required List<String> dates,
  }) async {
    emit(const REQUEST_LOADING());
    try {
      ResidenceResponse residenceResponse =
          await LogmentRepository.removeUnavailabilityDates(
        id: id,
        dates: dates,
      );
      emit(RequestState.success(
          message: "Dates d'indisponibilité supprimées avec succès"));
      emit(RequestState.residence(data: residenceResponse.data));
    } catch (e) {
      emit(RequestState.error(error: e.toString()));
    }
  }

  updateUnavailabilityDates({
    required String id,
    required List<String> dates,
  }) async {
    emit(const REQUEST_LOADING());
    try {
      ResidenceResponse residenceResponse =
          await LogmentRepository.updateUnavailabilityDates(
        id: id,
        dates: dates,
      );
      emit(RequestState.success(
          message: "Dates d'indisponibilité mises à jour avec succès"));
      emit(RequestState.residence(data: residenceResponse.data));
    } catch (e) {
      emit(RequestState.error(error: e.toString()));
    }
  }
}
