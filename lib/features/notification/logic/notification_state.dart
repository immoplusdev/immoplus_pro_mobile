import 'package:immoplus_pro/features/notification/data/models/notification_dto.dart';

/// Base class for all notification states
abstract class NotificationState {
  const NotificationState();
}

/// Waiting for first load
class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

/// Loading first page
class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

/// Data available (with optional load-more in progress)
class NotificationLoaded extends NotificationState {
  final NotificationResponse notifications;
  final bool isLoadingMore;

  const NotificationLoaded({
    required this.notifications,
    this.isLoadingMore = false,
  });

  /// Convenience accessor for unread count
  int get unreadCount => notifications.unreadCount;

  NotificationLoaded copyWith({
    NotificationResponse? notifications,
    bool? isLoadingMore,
  }) {
    return NotificationLoaded(
      notifications: notifications ?? this.notifications,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Error state
class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message);
}
