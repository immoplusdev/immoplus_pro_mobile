import 'package:dio/dio.dart' hide Headers;
import 'package:immoplus_pro/data/models/auth/withdraw_booking_history_dto.dart';
import 'package:immoplus_pro/data/models/reservations/reservation_response.dart';
import 'package:immoplus_pro/data/models/reservations/reservations_collection.dart';
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

  @GET("/reservations/data/historique-retrait/residence/owner/{id}")
  Future<WithdrawBookingHistoryDto> withDrawHistory(@Path() String id);

  //@GET("https://api.npoint.io/5298d4a42fc8b74cf43e")
  @GET("/reservations")
  Future<ReservationsCollection> getBookings(
      @Query("_page") int page,
      @Queries() Map<String, dynamic>? where,
      @Query("_per_page") int perPage,
      @Query("_order_by") String? orderBy,
      @Query("_order_dir") String? orderDir);

  @GET("/reservations/data/residence/owner/{id}")
  Future<ReservationsCollection> getBookingsOwner(
      @Path() String id,
      @Queries() Map<String, dynamic>? where,
      @Query("_page") int page,
      @Query("_per_page") int perPage,
      @Query("_order_by") String? orderBy,
      @Query("_order_dir") String? orderDir);

  @POST("/reservations/action/annuler/{id}")
  Future<ReservationResponse> annulerBookings(@Path() String id);

  @GET("/reservations/data/en-attente-reponse/owner/{ownerId}")
  Future<ReservationsCollection> getReservationsEnAttenteReponse(
      @Path('ownerId') String ownerId,
      {@Query('_per_page') int? perPage,
      @Query('_page') int? page,
      @Query("_order_by") String? orderBy,
      @Query("_order_dir") String? orderDir});

  @POST("/reservations/action/accepter/{id}")
  Future<ReservationResponse> accepterReservation(
    @Path('id') String id,
  );

  @POST("/reservations/action/refuser/{id}")
  Future<ReservationResponse> refuserReservation(
    @Path('id') String id, {
    @Field() String? notes,
  });

  @POST("/reservations/action/valider-presence")
  Future<dynamic> validerPresence(@Body() Map<String, dynamic> body);
}
