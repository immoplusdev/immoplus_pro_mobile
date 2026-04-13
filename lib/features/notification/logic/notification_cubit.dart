import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/features/notification/data/notification_repository.dart';
import 'package:immoplus_pro/features/notification/logic/notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  Future<void> loadNotifications() async {
    emit(NotificationLoading());
    try {
      final response = await NotificationRepository.getNotifications();
      emit(NotificationLoaded(
        notifications: response.data,
        unreadCount: response.unreadCount,
      ));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> markAsRead(String id) async {
    await NotificationRepository.markAsRead(id);
    final current = state;
    if (current is NotificationLoaded) {
      final updated = current.notifications.map((n) {
        if (n.id == id) return n.copyWith(isRead: true);
        return n;
      }).toList();
      final unread = updated.where((n) => !n.isRead).length;
      emit(NotificationLoaded(notifications: updated, unreadCount: unread));
    }
  }

  Future<void> markAllAsRead() async {
    await NotificationRepository.markAllAsRead();
    final current = state;
    if (current is NotificationLoaded) {
      final updated =
          current.notifications.map((n) => n.copyWith(isRead: true)).toList();
      emit(NotificationLoaded(notifications: updated, unreadCount: 0));
    }
  }
}
