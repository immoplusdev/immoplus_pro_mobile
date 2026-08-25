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

  /// Le corps de réponse du POST n'est pas garanti (peut être vide ou ne pas
  /// suivre l'enveloppe `{ data: ... }` du GET) — on ne le parse donc pas,
  /// seul le succès de la requête (statut 2xx) importe ici.
  static Future<void> updateMoyenPaiement({
    required String type,
    required String numero,
  }) async {
    try {
      await DioClient().dio.post(
        _baseUrl,
        data: {
          'moyenPaiementType': type,
          'moyenPaiementNumero': numero,
        },
      );
    } catch (e) {
      debugPrint('❌ PaymentMethod POST API Error: $e');
      rethrow;
    }
  }
}
