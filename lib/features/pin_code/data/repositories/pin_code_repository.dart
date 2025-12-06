import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:immoplus_pro/features/pin_code/data/models/prin_code_dto.dart';
import 'package:immoplus_pro/features/pin_code/data/provider/prin_code_provider.dart';

import 'package:injectable/injectable.dart';

import 'package:immoplus_pro/core/network/dio_client.dart';

@injectable
class PinCodeRepository {
  late final PrinCodeProvider _provider;
  final FlutterSecureStorage _storage;

  PinCodeRepository() : _storage = const FlutterSecureStorage() {
    _provider = PrinCodeProvider(DioClient().dio);
  }

  static const String _biometricPreferenceKey = 'biometric_enabled';
  static const String _localPinKey = 'local_pin';

  Future<void> setPin(String pin) async {
    await _provider.setPin(PrinCodeDto(pin: pin));
    await saveLocalPin(pin);
  }

  Future<void> verifyPin(String pin) async {
    final response = await _provider.verifyPin(PrinCodeDto(pin: pin));
    if (!response.data.isValid) {
      throw Exception("Code PIN incorrect");
    }
  }

  Future<void> saveLocalPin(String pin) async {
    await _storage.write(key: _localPinKey, value: pin);
  }

  Future<bool> hasPin() async {
    try {
      final response = await _provider.hasPin();
      return response.data.hasPin;
    } catch (e) {
      // If API fails, check local storage as fallback?
      // Or maybe we shouldn't allow access if we can't verify with server?
      // Requirement: "Vérifier que le user à un code opt déjà créé /wallet/has-pin"
      // If offline, maybe we rely on local pin existence?
      final localPin = await _storage.read(key: _localPinKey);
      return localPin != null;
    }
  }

  Future<void> setBiometricPreference(bool enabled) async {
    await _storage.write(
        key: _biometricPreferenceKey, value: enabled.toString());
  }

  Future<bool> getBiometricPreference() async {
    final value = await _storage.read(key: _biometricPreferenceKey);
    return value == 'true';
  }

  Future<String?> getLocalPin() async {
    return await _storage.read(key: _localPinKey);
  }

  Future<void> clearLocalPin() async {
    await _storage.delete(key: _localPinKey);
    await _storage.delete(key: _biometricPreferenceKey);
  }
}
