import 'package:dio/dio.dart' hide Headers;
import 'package:immoplus_pro/data/models/reservations/reservation_response.dart';
import 'package:immoplus_pro/data/models/reservations/reservations_response.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

part 'reservation_provider.g.dart';

@RestApi(
  baseUrl: null,
)
abstract class ReservationProvider {
  factory ReservationProvider(Dio dio, {String baseUrl}) = _ReservationProvider;

  //@GET("https://api.npoint.io/d9bca4bd7f02db43cbde")
  @GET("/reservations/{id}")
  Future<ReservationResponse> getBooking(@Path() String id);

  //@GET("https://api.npoint.io/5298d4a42fc8b74cf43e")
  @GET("/reservations")
  Future<ReservationsResponse> getBookings(
      @Query("_page") int page, @Query("_per_page") int perPage);

  //@GET("/reservations/data/residence-owner/{id}")
  @GET("https://api.npoint.io/5298d4a42fc8b74cf43e")
  Future<ReservationsResponse> getBookingsOwner(@Path() String id);
}
