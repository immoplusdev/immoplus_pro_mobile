import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_response.dart';
import 'package:immoplus_pro/data/models/reservations/reservations_response.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/views/booking/logic/booking_request_state.dart';

class BookingCubit extends Cubit<BookingRequestState> {
  BookingCubit() : super(const BookingRequestState.initial());

  getBookings() async {
    emit(const LOADING_BOOKING_LIST());
    try {
      ReservationsResponse reservationModel =
          await LogmentRepository.getReservationsOwner(
              id: SessionManager().currentUser!.userId.toString());
      inspect(reservationModel);
      emit(BookingRequestState.receive(reservationModel));
    } catch (e) {
      emit(BookingRequestState.error(e.toString()));
    }
  }

  getBooking({required String id}) async {
    emit(const LOADING_BOOKING());
    try {
      ReservationResponse reservationModel =
          await LogmentRepository.getReservation(id: id);
      emit(BookingRequestState.receiveId(reservationModel));
    } catch (e) {
      emit(BookingRequestState.error(e.toString()));
    }
  }
}
