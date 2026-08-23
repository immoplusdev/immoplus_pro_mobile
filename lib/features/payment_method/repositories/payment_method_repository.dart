import 'package:flutter/foundation.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/features/payment_method/models/payment_method_model.dart';

class PaymentMethodRepository {
  static const String _baseUrl = '/payments/proprietaire/moyen-paiement';

  static Future<PaymentMethodModel> getMoyenPaiement() async {
    try {
      final response = await DioClient().dio.get(_baseUrl);
      final data = response.data['data'] as Map<String, dynamic>;
      return PaymentMethodModel.fromJson(data);
    } catch (e) {
      debugPrint('❌ PaymentMethod GET API Error: $e');
      rethrow;
    }
  }

  static Future<PaymentMethodModel> updateMoyenPaiement({
    required String type,
    required String numero,
  }) async {
    try {
      final response = await DioClient().dio.post(
        _baseUrl,
        data: {
          'moyenPaiementType': type,
          'moyenPaiementNumero': numero,
        },
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return PaymentMethodModel.fromJson(data);
    } catch (e) {
      debugPrint('❌ PaymentMethod POST API Error: $e');
      rethrow;
    }
  }
}
