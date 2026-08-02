import 'package:shared_preferences/shared_preferences.dart';

class CertificationAnnouncementService {
  static const String _key = 'certification_announcement_seen';

  static Future<bool> shouldShow() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_key) ?? false);
  }

  static Future<void> markSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }
}
