import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/common/order_dir.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';
import 'package:immoplus_pro/data/models/reservations/status_reservation.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/services/pending_reservation_overlay_service.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:immoplus_pro/services/analytics_service.dart';

enum PendingReservationFilter {
  enAttenteReponse('En attente de réponse'),
  enAttentePaiement('En attente de paiement');

  final String label;
  const PendingReservationFilter(this.label);
}

class PendingReservationsCubit extends Cubit<RequestState> {
  PendingReservationsCubit() : super(const RequestState.initial());

  final PagingController<int, ReservationModel> pagingController =
      PagingController(firstPageKey: 1);

  PendingReservationFilter _currentFilter =
      PendingReservationFilter.enAttenteReponse;

  PendingReservationFilter get currentFilter => _currentFilter;

  void init() {
    pagingController.addPageRequestListener(_fetchPage);
  }

  void setFilter(PendingReservationFilter filter) {
    if (_currentFilter == filter) return;
    _currentFilter = filter;
    pagingController.refresh();
  }

  Future<void> _fetchPage(int page) async {
    try {
      final ownerId = SessionManager().currentUser!.userId!;

      switch (_currentFilter) {
        case PendingReservationFilter.enAttenteReponse:
          final result =
              await LogmentRepository.getReservationsEnAttenteReponse(
            ownerId: ownerId,
            page: page,
            perPage: 10,
            orderBy: OrderByField.createdAt.value,
            orderDir: OrderDir.desc.value,
          );
          result.hasNext == true
              ? pagingController.appendPage(result.data, page + 1)
              : pagingController.appendLastPage(result.data);
          break;

        case PendingReservationFilter.enAttentePaiement:
          final result = await LogmentRepository.getReservationsOwner(
            id: ownerId,
            page: page,
            perPage: 10,
            orderBy: OrderByField.createdAt.value,
            orderDir: OrderDir.desc.value,
            where: {
              '_where': [
                '{"_field": "statusFacture", "_op": "eq", "_val": "non_paye"}',
                '{"_field": "statusReservation", "_op": "eq", "_val": "${StatusReservation.enAttentePaiementClient.backendValue}"}',
              ],
            },
          );
          result.hasNext == true
              ? pagingController.appendPage(result.data, page + 1)
              : pagingController.appendLastPage(result.data);
          break;
      }
    } catch (e) {
      pagingController.error = e.toString();
    }
  }

  Future<void> accepter(String reservationId) async {
    emit(const RequestState.loading());
    try {
      await LogmentRepository.accepterReservation(reservationId);
      getIt<AnalyticsService>().logBookingAccepted(idReservation: reservationId);
      pagingController.refresh();
      getIt<PendingReservationOverlayService>().refreshPendingReservation();
      emit(const RequestState.success());
    } catch (e) {
      emit(RequestState.error(error: e.toString()));
    }
  }

  Future<void> refuser(String reservationId, {String? notes}) async {
    emit(const RequestState.loading());
    try {
      await LogmentRepository.refuserReservation(reservationId, notes: notes);
      getIt<AnalyticsService>().logBookingRefused(idReservation: reservationId);
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
