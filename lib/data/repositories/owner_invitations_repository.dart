import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/data/models/reservations/owner_invitation_model.dart';

/// Wrapper API pour le flux "reverse search" côté propriétaire : la liste
/// des invitations en attente et les deux actions (confirmer/décliner),
/// une résidence à la fois.
class OwnerInvitationsRepository {
  static const String _baseUrl = '/reverse-searches';

  static Future<List<OwnerInvitationItem>> getOwnerInvitations() async {
    try {
      final response =
          await DioClient().dio.get('$_baseUrl/data/invitations/owner');
      final data = (response.data as Map<String, dynamic>)['data']
              as List<dynamic>? ??
          [];
      return OwnerInvitationItem.listFromJson(data);
    } on DioException catch (e) {
      log('DioError in OwnerInvitationsRepository: ${e.message}');
      throw Exception('Failed to load owner invitations: ${e.message}');
    } catch (e) {
      log('Error in OwnerInvitationsRepository: $e');
      throw Exception('Failed to load owner invitations: $e');
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
