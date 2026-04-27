import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/core/request_response_exeption.dart';
import 'package:immoplus_pro/features/notification/data/models/notification_dto.dart';
import 'package:immoplus_pro/features/notification/data/notification_provider.dart';
import 'package:retrofit/retrofit.dart';

class NotificationRepository {
  static NotificationProvider get _provider =>
      NotificationProvider(DioClient().dio);

  // ── Get paginated notifications ──────────────────────────────────────────

  static Future<NotificationResponse> getNotifications({
    int page = 1,
    int pageSize = 20,
    String orderBy = 'createdAt',
    String orderDir = 'desc',
  }) async {
    try {
      return await _provider.getNotifications(
        page: page,
        pageSize: pageSize,
        // orderBy: orderBy,
        // orderDir: orderDir,
      );
    } on DioException catch (e) {
      log('DioError getNotifications: ${e.message}');
      throw Exception('Erreur chargement notifications: ${e.message}');
    } on RequestResponseExeption catch (e) {
      EasyLoading.showError(e.toString());
      throw Exception('Erreur chargement notifications: $e');
    } catch (e) {
      log('Error getNotifications: $e');
      throw Exception('Erreur chargement notifications: $e');
    }
  }

  // ── Get single notification ───────────────────────────────────────────────

  static Future<NotificationDto?> getNotificationById(String id) async {
    try {
      final response = await _provider.getNotificationById(id);
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return NotificationDto.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      log('DioError getNotificationById: ${e.message}');
      throw Exception('Erreur chargement notification: ${e.message}');
    } catch (e) {
      log('Error getNotificationById: $e');
      throw Exception('Erreur chargement notification: $e');
    }
  }

  // ── Unread count ─────────────────────────────────────────────────────────

  static Future<int> getUnreadCount() async {
    try {
      final HttpResponse<dynamic> response = await _provider.getUnreadCount();
      final data = response.data;
      if (data is Map) {
        return (data['count'] ??
            data['unread_count'] ??
            data['unreadCount'] ??
            0) as int;
      }
      return 0;
    } on DioException catch (e) {
      log('DioError getUnreadCount: ${e.message}');
      throw Exception('Erreur comptage non-lus: ${e.message}');
    } catch (e) {
      log('Error getUnreadCount: $e');
      throw Exception('Erreur comptage non-lus: $e');
    }
  }

  // ── Mark single as read ───────────────────────────────────────────────────

  static Future<void> markAsRead(String notificationId) async {
    try {
      await _provider.markAsRead(notificationId);
    } on DioException catch (e) {
      log('DioError markAsRead: ${e.message}');
      throw Exception('Erreur marquage notification: ${e.message}');
    } catch (e) {
      log('Error markAsRead: $e');
      throw Exception('Erreur marquage notification: $e');
    }
  }

  // ── Mark all as read ─────────────────────────────────────────────────────

  static Future<void> markAllAsRead() async {
    try {
      await _provider.markAllAsRead();
    } on DioException catch (e) {
      log('DioError markAllAsRead: ${e.message}');
      throw Exception('Erreur marquage toutes notifications: ${e.message}');
    } catch (e) {
      log('Error markAllAsRead: $e');
      throw Exception('Erreur marquage toutes notifications: $e');
    }
  }

  // ── Delete my notification ────────────────────────────────────────────────

  static Future<void> deleteNotification(String notificationId) async {
    try {
      await _provider.deleteNotification(notificationId);
    } on DioException catch (e) {
      log('DioError deleteNotification: ${e.message}');
      throw Exception('Erreur suppression notification: ${e.message}');
    } catch (e) {
      log('Error deleteNotification: $e');
      throw Exception('Erreur suppression notification: $e');
    }
  }
}
