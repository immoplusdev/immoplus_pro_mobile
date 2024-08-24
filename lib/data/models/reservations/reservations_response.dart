import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_model.dart';

part 'reservations_response.freezed.dart';
part 'reservations_response.g.dart';

@freezed
class ReservationsResponse with _$ReservationsResponse {
  factory ReservationsResponse({
    @Default([]) List<ReservationModel> data,
    @Default(1) int currentPage,
    @Default(1) int totalPages,
    @Default(10) int pageSize,
    @Default(0) int totalCount,
    @Default(false) bool hasNext,
    @Default(false) bool hasPrevious,
  }) = _ReservationsResponse;

  factory ReservationsResponse.fromJson(Map<String, dynamic> json) =>
      _$ReservationsResponseFromJson(json);
}
