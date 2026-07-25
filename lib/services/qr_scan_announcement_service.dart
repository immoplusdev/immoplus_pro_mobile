import 'package:shared_preferences/shared_preferences.dart';

/// Contrôle l'affichage de l'annonce "scanner le QR code du client pour
/// valider un dépôt" (voir QrScanDepositSheet) — montrée une seule fois,
/// jamais revue une fois vue.
class QrScanAnnouncementService {
  static const String _key = 'qr_scan_deposit_announcement_seen';

  static Future<bool> shouldShow() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_key) ?? false);
  }

  static Future<void> markSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }
}
