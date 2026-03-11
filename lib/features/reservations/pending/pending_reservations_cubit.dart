import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PendingReservationsCubit extends Cubit<RequestState> {
  PendingReservationsCubit() : super(const RequestState.initial());

  final PagingController<int, ReservationModel> pagingController =
      PagingController(firstPageKey: 1);

  void init() {
    pagingController.addPageRequestListener(_fetchPage);
  }

  Future<void> _fetchPage(int page) async {
    try {
      final ownerId = SessionManager().currentUser!.userId!;
      final result = await LogmentRepository.getReservationsEnAttenteReponse(
        ownerId: ownerId,
        page: page,
        perPage: 10,
      );
      result.hasNext == true
          ? pagingController.appendPage(result.data, page + 1)
          : pagingController.appendLastPage(result.data);
    } catch (e) {
      pagingController.error = e.toString();
    }
  }

  Future<void> accepter(String reservationId) async {
    emit(const RequestState.loading());
    try {
      await LogmentRepository.accepterReservation(reservationId);
      pagingController.refresh();
      emit(const RequestState.success());
    } catch (e) {
      emit(RequestState.error(error: e.toString()));
    }
  }

  Future<void> refuser(String reservationId, {String? notes}) async {
    emit(const RequestState.loading());
    try {
      await LogmentRepository.refuserReservation(reservationId, notes: notes);
      pagingController.refresh();
      emit(const RequestState.success());
    } catch (e) {
      emit(RequestState.error(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    pagingController.dispose();
    return super.close();
  }
}
