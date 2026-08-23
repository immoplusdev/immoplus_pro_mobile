import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/data/models/reservations/owner_invitation_model.dart';
import 'package:immoplus_pro/utils/session_manager.dart';

/// Wrapper API pour le flux "reverse search" côté propriétaire : la liste
/// des invitations en attente et les deux actions (confirmer/décliner),
/// une résidence à la fois.
class OwnerInvitationsRepository {
  static const String _baseUrl = '/reverse-searches';

  static Future<List<OwnerInvitationItem>> getOwnerInvitations() async {
    try {
      final currentUser = SessionManager().currentUser;
      log(
        'Appel avec userId=${currentUser?.userId}, '
        'role=${currentUser?.roleName} (à comparer avec le compte qui a '
        'reçu la notif push)',
        name: 'OWNER_INVITATIONS',
      );
      final response =
          await DioClient().dio.get('$_baseUrl/data/invitations/owner');
      log(
        'GET $_baseUrl/data/invitations/owner → status ${response.statusCode}, '
        'raw body: ${response.data}',
        name: 'OWNER_INVITATIONS',
      );
      final data = (response.data as Map<String, dynamic>)['data']
              as List<dynamic>? ??
          [];
      final items = OwnerInvitationItem.listFromJson(data);
      log('Parsed ${items.length} invitation item(s)', name: 'OWNER_INVITATIONS');
      return items;
    } on DioException catch (e) {
      log(
        'DioError in OwnerInvitationsRepository: ${e.message}, '
        'status: ${e.response?.statusCode}, body: ${e.response?.data}',
        name: 'OWNER_INVITATIONS',
      );
      // En cas d'erreur serveur (ex: HTTP 500 côté backend), on retourne une liste
      // vide de manière sécurisée pour ne pas faire planter la liste principale.
      return [];
    } catch (e) {
      log('Error in OwnerInvitationsRepository: $e', name: 'OWNER_INVITATIONS');
      return [];
    }
  }

  static Future<void> confirmProposal({
    required String reverseSearchId,
    required String residenceId,
  }) async {
    try {
      await DioClient().dio.post(
        '$_baseUrl/action/confirm/$reverseSearchId',
        data: {'residenceId': residenceId},
      );
    } on DioException catch (e) {
      log('DioError confirming invitation: ${e.message}');
      throw Exception('Failed to confirm invitation: ${e.message}');
    } catch (e) {
      log('Error confirming invitation: $e');
      throw Exception('Failed to confirm invitation: $e');
    }
  }

  static Future<void> declineProposal({
    required String reverseSearchId,
    required String residenceId,
    String? motif,
  }) async {
    try {
      await DioClient().dio.post(
        '$_baseUrl/action/decline/$reverseSearchId',
        data: {
          'residenceId': residenceId,
          if (motif != null && motif.isNotEmpty) 'motif': motif,
        },
      );
    } on DioException catch (e) {
      log('DioError declining invitation: ${e.message}');
      throw Exception('Failed to decline invitation: ${e.message}');
    } catch (e) {
      log('Error declining invitation: $e');
      throw Exception('Failed to decline invitation: $e');
    }
  }
}
