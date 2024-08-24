import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_response.dart';
import 'package:immoplus_pro/data/models/reservations/reservations_response.dart';

part 'booking_request_state.freezed.dart';

@freezed
class BookingRequestState with _$BookingRequestState {
  const factory BookingRequestState.initial() = INITIAL_BOOKING;
  const factory BookingRequestState.loading() = LOADING_BOOKING;
  const factory BookingRequestState.loadingList() = LOADING_BOOKING_LIST;
  const factory BookingRequestState.receive(
      ReservationsResponse reservationResponse) = RECEIVE_BOOKINGS;
  const factory BookingRequestState.receiveId(
      ReservationResponse reservationResponse) = RECEIVE_BOOKING;
  const factory BookingRequestState.error(String message) = Error_BOOKINGS;
}
