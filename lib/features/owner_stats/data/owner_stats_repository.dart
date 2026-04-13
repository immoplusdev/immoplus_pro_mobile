import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/features/owner_stats/data/models/owner_stats_dto.dart';

class OwnerStatsRepository {
  static Future<OwnerStatsDto> getStats({required String period}) async {
    try {
      final response = await DioClient().dio.get(
        '/v1/statistics/owner',
        queryParameters: {'period': period},
      );
      final rawData = response.data;
      final Map<String, dynamic> statsJson;

      if (rawData is Map<String, dynamic> && rawData['data'] is Map) {
        statsJson = Map<String, dynamic>.from(rawData['data'] as Map);
      } else if (rawData is Map<String, dynamic>) {
        statsJson = rawData;
      } else {
        throw Exception('Format de réponse invalide pour les statistiques');
      }

      return OwnerStatsDto.fromJson(statsJson);
    } on DioException catch (e) {
      log('DioError stats: ${e.message}');
      throw Exception('Erreur lors du chargement des statistiques: ${e.message}');
    } catch (e) {
      log('Error stats: $e');
      throw Exception('Erreur lors du chargement des statistiques: $e');
    }
  }
}
