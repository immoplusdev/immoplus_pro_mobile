import 'package:dio/dio.dart';
import 'package:immoplus_pro/features/notification/data/models/notification_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'notification_provider.g.dart';

@RestApi()
abstract class NotificationProvider {
  factory NotificationProvider(Dio dio, {String? baseUrl}) =
      _NotificationProvider;

  /// Liste paginée des notifications de l'utilisateur connecté
  @GET('/notifications/me')
  Future<NotificationResponse> getNotifications({
    @Query('pushType') String? pushType,
    @Query('onlyUnread') bool? onlyUnread,
    @Query('_page') int page = 1,
    @Query('_per_page') int pageSize = 20,
  });

  /// Nombre de notifications non lues
  @GET('/notifications/me/unread-count')
  Future<HttpResponse<dynamic>> getUnreadCount();

  /// Détail d'une notification
  @GET('/notifications/{id}')
  Future<HttpResponse<dynamic>> getNotificationById(
    @Path('id') String id,
  );

  /// Marquer une notification comme lue
  @PATCH('/notifications/{id}/read')
  Future<HttpResponse<dynamic>> markAsRead(
    @Path('id') String id,
  );

  /// Marquer toutes les notifications comme lues
  @PATCH('/notifications/me/read-all')
  Future<HttpResponse<dynamic>> markAllAsRead();

  /// Supprimer une notification de l'utilisateur
  @DELETE('/notifications/me/{id}')
  Future<HttpResponse<dynamic>> deleteNotification(
    @Path('id') String id,
  );
}
