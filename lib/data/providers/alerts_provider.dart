import 'package:dio/dio.dart' hide Headers;
import 'package:immoplus_pro/data/models/demandes/alert_marketplace_model.dart';
import 'package:retrofit/retrofit.dart';

part 'alerts_provider.g.dart';

@RestApi(
  baseUrl: null,
)
abstract class AlertsProvider {
  factory AlertsProvider(Dio dio, {String baseUrl}) = _AlertsProvider;

  @GET("/alerts")
  Future<AlertMarketplaceResponse> getAlerts(
    @Query("scope") String scope,
    @Query("view") String view,
    @Query("page") int page,
    @Query("limit") int limit,
    @Query("sortBy") String sortBy,
  );

  @GET("/alerts/badge-count")
  Future<AlertBadgeCountModel> getBadgeCount();

  @GET("/alerts/{alertId}")
  Future<AlertDetailModel> getAlertDetail(
    @Path("alertId") String alertId,
  );

  @GET("/alerts/{alertId}/matches-pro")
  Future<AlertProMatchesResponse> getMatchesPro(
    @Path("alertId") String alertId,
  );

  @POST("/alerts/{alertId}/proposals")
  Future<AlertProposalResponse> sendProposal(
    @Path("alertId") String alertId,
    @Body() Map<String, dynamic> body,
  );

  @PATCH("/alerts/{alertId}/view")
  Future<dynamic> markAsViewed(
    @Path("alertId") String alertId,
    @Body() Map<String, dynamic> body,
  );
}
