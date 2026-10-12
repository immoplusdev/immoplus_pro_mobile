import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationActifService {
  static const String _key = 'actif_notif_status';

  static const String notAsked = 'not_asked';
  static const String maybeLater = 'maybe_later';
  static const String accepted = 'accepted';

  static Future<String> getStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) ?? notAsked;
  }

  static Future<void> setStatus(String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, status);
  }

  /// Retourne true si le bottom sheet doit être affiché.
  /// Vérifie d'abord la permission OS, puis le statut stocké.
  static Future<bool> shouldShow() async {
    final status = await Permission.notification.status;
    if (status.isGranted) {
      await setStatus(accepted);
      return false;
    }

    final currentStatus = await getStatus();
    return currentStatus == notAsked || currentStatus == maybeLater;
  }
}
