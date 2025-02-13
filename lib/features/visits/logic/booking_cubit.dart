import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/demande_visit_response.dart';
import 'package:immoplus_pro/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus_pro/features/visits/logic/visit_request_state.dart';

class VisitCubit extends Cubit<VisitRequestState> {
  VisitCubit() : super(const VisitRequestState.initial());

  getVisits() async {
    emit(const LOADING_VISITS_LIST());
    // try {
    //   ReservationModel reservationModel =
    //       await LogmentRepository.getReservations(
    //           id: UserModel.singleton.id.toString());
    //   emit(VisitRequestState.receive(reservationModel));
    // } catch (e) {
    //   emit(VisitRequestState.error(e.toString()));
    // }
  }

  getVisit({required String id}) async {
    emit(const LOADING_VISITS());
    try {
      DemandeVisitResponse reservationModel =
          await BienImmobilierRepository.getVisit(id: id);
      emit(VisitRequestState.receiveId(reservationModel));
    } catch (e) {
      emit(VisitRequestState.error(e.toString()));
    }
  }
}
