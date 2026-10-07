import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'notification_provider.g.dart';

@RestApi(
  baseUrl: null,
)
abstract class NotificationProvider {
  factory NotificationProvider(Dio dio, {String baseUrl}) =
      _NotificationProvider;

  /// Enregistre ou actualise l'appareil auprès du backend
  @PUT('/me/push-installations/{installationId}')
  Future<dynamic> registerPushInstallation(
    @Path('installationId') String installationId,
    @Body() Map<String, dynamic> body,
  );

  /// Détache l'appareil du compte lors de la déconnexion
  @DELETE('/me/push-installations/{installationId}')
  Future<dynamic> deletePushInstallation(
    @Path('installationId') String installationId,
  );
}
