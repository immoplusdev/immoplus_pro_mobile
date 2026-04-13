import 'package:immoplus_pro/features/notification/data/models/notification_dto.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationDto> notifications;
  final int unreadCount;

  NotificationLoaded({
    required this.notifications,
    required this.unreadCount,
  });
}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
}
