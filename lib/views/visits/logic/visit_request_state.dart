import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_response.dart';

part 'visit_request_state.freezed.dart';

@freezed
class VisitRequestState with _$VisitRequestState {
  const factory VisitRequestState.initial() = INITIAL_VISITS;
  const factory VisitRequestState.loading() = LOADING_VISITS;
  const factory VisitRequestState.loadingList() = LOADING_VISITS_LIST;
  const factory VisitRequestState.receive(ReservationModel reservationModel) =
      RECEIVE_VISITS;
  const factory VisitRequestState.receiveId(
      ReservationResponse reservationModelId) = RECEIVE_VISIT;
  const factory VisitRequestState.error(String message) = Error_VISITSS;
}
