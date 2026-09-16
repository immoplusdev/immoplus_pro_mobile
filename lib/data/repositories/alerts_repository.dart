import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/data/enums/alert_enums.dart';
import 'package:immoplus_pro/data/models/demandes/alert_marketplace_model.dart';
import 'package:immoplus_pro/data/providers/alerts_provider.dart';

/// Repository pour les alertes et demandes clients côté professionnel (iMatch Pro).
class AlertsRepository {
  /// 1. Lister les demandes marketplace selon la vue sélectionnée
  static Future<AlertMarketplaceResponse> getMarketplaceAlerts({
    AlertViewFilter view = AlertViewFilter.all,
    int page = 1,
    int limit = 10,
    AlertSortBy sortBy = AlertSortBy.recent,
  }) async {
    try {
      final response = await AlertsProvider(DioClient().dio).getAlerts(
        AlertScope.marketplace.value,
        view.value,
        page,
        limit,
        sortBy.value,
      );
      log('GET /alerts view: ${view.value}, page: $page', name: 'ALERTS_API');
      return response;
    } on DioException catch (dioError) {
      log('DioError in AlertsRepository.getMarketplaceAlerts: ${dioError.message}',
          name: 'ALERTS_API');
      throw Exception('Failed to load marketplace alerts: ${dioError.message}');
    } catch (error) {
      log('Error in AlertsRepository.getMarketplaceAlerts: $error',
          name: 'ALERTS_API');
      throw Exception('Failed to load marketplace alerts: $error');
    }
  }

  /// 2. Obtenir le badge de nouvelles demandes
  static Future<AlertBadgeCountModel> getBadgeCount() async {
    try {
      final response = await AlertsProvider(DioClient().dio).getBadgeCount();
      log('GET /alerts/badge-count success', name: 'ALERTS_API');
      return response;
    } on DioException catch (dioError) {
      log('DioError in AlertsRepository.getBadgeCount: ${dioError.message}',
          name: 'ALERTS_API');
      throw Exception('Failed to load badge count: ${dioError.message}');
    } catch (error) {
      log('Error in AlertsRepository.getBadgeCount: $error',
          name: 'ALERTS_API');
      throw Exception('Failed to load badge count: $error');
    }
  }

  /// 3. Voir le détail d'une alerte
  static Future<AlertDetailModel> getAlertDetail({
    required String alertId,
  }) async {
    try {
      final response =
          await AlertsProvider(DioClient().dio).getAlertDetail(alertId);
      return response;
    } on DioException catch (dioError) {
      log('DioError in AlertsRepository.getAlertDetail: ${dioError.message}',
          name: 'ALERTS_API');
      throw Exception('Failed to load alert detail: ${dioError.message}');
    } catch (error) {
      log('Error in AlertsRepository.getAlertDetail: $error',
          name: 'ALERTS_API');
      throw Exception('Failed to load alert detail: $error');
    }
  }

  /// 4. Voir les biens du Pro compatibles avec score de matching
  static Future<AlertProMatchesResponse> getMatchesPro({
    required String alertId,
  }) async {
    try {
      final response =
          await AlertsProvider(DioClient().dio).getMatchesPro(alertId);
      return response;
    } on DioException catch (dioError) {
      log('DioError in AlertsRepository.getMatchesPro: ${dioError.message}',
          name: 'ALERTS_API');
      throw Exception('Failed to load matches: ${dioError.message}');
    } catch (error) {
      log('Error in AlertsRepository.getMatchesPro: $error',
          name: 'ALERTS_API');
      throw Exception('Failed to load matches: $error');
    }
  }

  /// 5. Proposer un bien pour une demande
  static Future<AlertProposalResponse> sendProposal({
    required String alertId,
    required String propertyId,
    String? message,
  }) async {
    try {
      final body = <String, dynamic>{
        'propertyId': propertyId,
        if (message != null && message.isNotEmpty) 'message': message,
      };
      final response =
          await AlertsProvider(DioClient().dio).sendProposal(alertId, body);
      return response;
    } on DioException catch (dioError) {
      log('DioError in AlertsRepository.sendProposal: ${dioError.message}',
          name: 'ALERTS_API');
      if (dioError.response?.data is Map<String, dynamic>) {
        final errMap = dioError.response!.data as Map<String, dynamic>;
        throw Exception(
            errMap['message'] ?? 'Erreur lors de l\'envoi de la proposition');
      }
      throw Exception('Failed to send proposal: ${dioError.message}');
    } catch (error) {
      log('Error in AlertsRepository.sendProposal: $error', name: 'ALERTS_API');
      throw Exception('Failed to send proposal: $error');
    }
  }

  /// 6. Marquer une demande comme consultée
  static Future<void> markAsViewed({required String alertId}) async {
    try {
      await AlertsProvider(DioClient().dio).markAsViewed(alertId, {});
      log('Alert $alertId marked as viewed via AlertsProvider',
          name: 'ALERTS_API');
    } on DioException catch (dioError) {
      log('DioError in AlertsRepository.markAsViewed: ${dioError.message}',
          name: 'ALERTS_API');
      throw Exception('Failed to mark alert as viewed: ${dioError.message}');
    } catch (e) {
      log('Error marking alert as viewed: $e', name: 'ALERTS_API');
      throw Exception('Failed to mark alert as viewed: $e');
    }
  }
}
