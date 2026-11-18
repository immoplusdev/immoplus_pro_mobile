import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus_pro/core/error/app_error_mapper.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/features/boost/models/residence_share_link_model.dart';

/// Repository dédié aux actions de mise en avant / partage (« Boost »).
class BoostRepository {
  /// Crée ou récupère le lien de partage actif d'une résidence validée.
  static Future<ResidenceShareLinkModel> generateOrGetShareLink({
    required String residenceId,
  }) async {
    try {
      final response = await DioClient().dio.post<Map<String, dynamic>>(
        '/pro/residences/$residenceId/share-link',
      );
      final rawData = response.data;
      if (rawData == null) {
        throw const FormatException('Réponse vide pour le lien de partage');
      }
      final Map<String, dynamic> payload = rawData['data'] is Map
          ? Map<String, dynamic>.from(rawData['data'] as Map)
          : rawData;

      return ResidenceShareLinkModel.fromJson(payload);
    } on DioException catch (e) {
      log('DioError generateOrGetShareLink: ${e.message}');
      throw AppErrorMapper.from(e);
    } catch (e) {
      log('Error generateOrGetShareLink: $e');
      throw AppErrorMapper.from(e);
    }
  }
}
