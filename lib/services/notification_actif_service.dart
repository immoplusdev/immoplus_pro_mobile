import 'package:onesignal_flutter/onesignal_flutter.dart';
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
    // Utiliser OneSignal pour une vérification fiable
    final hasPermission = OneSignal.Notifications.permission;

    if (hasPermission) {
      await setStatus(accepted);
      return false;
    }

    final status = await getStatus();
    return status == notAsked || status == maybeLater;
  }
}
