import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/data/models/configs/commune_collection.dart';
import 'package:immoplus_pro/data/models/configs/ville_collection.dart';
import 'package:immoplus_pro/data/repositories/config_repository.dart';

class PlaceSelectorCubit extends Cubit<RequestState> {
  PlaceSelectorCubit() : super(const REQUEST_INITIAL());

  getVilles({required int page, required int perPage}) async {
    try {
      emit(const REQUEST_LOADING());
      VilleCollection villeCollection =
          await ConfigRepository.getVilles(page: page, perPage: perPage);
      emit(RequestState.villes(data: villeCollection.data ?? []));
    } catch (e) {
      emit(const REQUEST_INITIAL());
    }
  }

  getCommunes({required int page, required int perPage}) async {
    try {
      emit(const REQUEST_LOADING());
      CommuneCollection communeCollection =
          await ConfigRepository.getCommunes(page: page, perPage: perPage);

      emit(RequestState.communes(data: communeCollection.data));
    } catch (e) {
      emit(const REQUEST_INITIAL());
    }
  }
}
