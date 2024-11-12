import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_single.dart';
import 'package:immoplus_pro/data/repositories/bien_immobilier_repository.dart';

class EstateCubit extends Cubit<RequestState> {
  EstateCubit() : super(const REQUEST_INITIAL());

  getEstate({required String id}) async {
    emit(const REQUEST_LOADING());
    try {
      BienImmobilierSingle residenceResponse =
          await BienImmobilierRepository.getBiensImmobilier(id);

      if (residenceResponse.data != null) {
        emit(RequestState.bienImmobilier(data: residenceResponse.data!));
      } else {
        emit(const REQUEST_INITIAL());
      }
    } catch (e) {
      emit(RequestState.error(error: e.toString()));
    }
  }

  updateEstate({required String id, required Map<String, dynamic> data}) async {
    emit(const REQUEST_LOADING());
    try {
      BienImmobilierSingle residenceResponse =
          await BienImmobilierRepository.update(id: id, fields: data);

      if (residenceResponse.data != null) {
        emit(RequestState.bienImmobilier(data: residenceResponse.data!));
      } else {
        emit(const REQUEST_INITIAL());
      }
    } catch (e) {
      emit(RequestState.error(error: e.toString()));
    }
  }
}
