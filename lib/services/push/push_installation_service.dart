import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

@lazySingleton
class PushInstallationService {
  static const String _pushInstallationIdKey = 'push_installation_id';
  String? _cachedInstallationId;

  Future<String> getInstallationId() async {
    if (_cachedInstallationId != null) return _cachedInstallationId!;
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString(_pushInstallationIdKey);
    if (id == null || id.isEmpty) {
      id = const Uuid().v4();
      await prefs.setString(_pushInstallationIdKey, id);
    }
    _cachedInstallationId = id;
    return id;
  }
}
