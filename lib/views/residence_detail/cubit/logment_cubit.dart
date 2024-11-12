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
}
