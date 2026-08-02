import 'package:flutter/foundation.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/features/certification/models/certification_model.dart';

class CertificationRepository {
  static const String _baseUrl = '/pro/certification';

  static Future<CertificationModel> getMyCertification() async {
    try {
      final response = await DioClient().dio.get('$_baseUrl/me');
      return CertificationModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      debugPrint('❌ Certification API Error: $e');
      rethrow;
    }
  }
}
