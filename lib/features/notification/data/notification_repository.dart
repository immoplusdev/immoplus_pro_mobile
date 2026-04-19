import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/features/notification/data/models/notification_dto.dart';

class NotificationRepository {
  static Future<NotificationResponse> getNotifications() async {
    try {
      final response = await DioClient().dio.get('/notifications');
      return NotificationResponse.fromJson(response.data);
    } on DioException catch (e) {
      log('DioError notifications: ${e.message}');
      throw Exception('Erreur chargement notifications: ${e.message}');
    } catch (e) {
      log('Error notifications: $e');
      throw Exception('Erreur chargement notifications: $e');
    }
  }

  static Future<void> markAsRead(String notificationId) async {
    await DioClient().dio.patch('/notifications/$notificationId/read');
  }

  static Future<void> markAllAsRead() async {
    await DioClient().dio.patch('/notifications/read-all');
  }
}
