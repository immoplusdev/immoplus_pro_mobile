import 'package:flutter/foundation.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/utils/session_manager.dart';

class AddressRepository {
  static Future<void> updateAddress({
    required String address,
    required String city,
  }) async {
    try {
      final userId = SessionManager().currentUser!.userId!;
      await DioClient().dio.patch(
        '/users/$userId',
        data: {
          'address': address,
          'city': city,
        },
      );
    } catch (e) {
      debugPrint('❌ Address PATCH API Error: $e');
      rethrow;
    }
  }
}
