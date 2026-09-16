import 'package:cupertino_native/components/tab_bar.dart';
import 'package:cupertino_native/style/sf_symbol.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';

class ImmoplusBottomNavItem {
  /// Label affiché sous l'icône
  final String label;

  /// Nom de l'icône (SF Symbol système OU image dans Xcode Assets)
  final String iosIconName;

  /// Nom de l'icône quand sélectionnée (iOS)
  final String? iosIconNameSelected;

  /// Icône Material / Widget (Android / autres plateformes)
  final Widget androidIcon;

  /// Icône Material / Widget quand sélectionnée (Android)
  final Widget androidIconSelected;

  const ImmoplusBottomNavItem({
    required this.label,
    required this.iosIconName,
    this.iosIconNameSelected,
    required this.androidIcon,
    required this.androidIconSelected,
  });
}

class ImmoplusBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<ImmoplusBottomNavItem> items;

  const ImmoplusBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;

    // Liquid Glass (CNTabBar natif) uniquement sur iOS 26+.
    // Sur iOS < 26 (ex: iOS 18), on utilise le rendu Flutter Material
    // pour éviter les bugs de rendu de la platform view UITabBar.
    if (isIOS && _isIOS26OrLater()) {
      return _buildIOSLiquidGlass();
    }
    return _buildAndroid(context);
  }

  /// Cache statique pour ne pas réinterroger DeviceInfoPlugin à chaque build.
  static int? _cachedIOSMajor;

  /// Retourne le major de la version iOS via device_info_plus (ex: 18, 26).
  /// Premier appel async → met en cache. Appels suivants → instantané.
  /// No-op silencieux sur Android/autres plateformes.
  static Future<void> precacheIOSVersion() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) return;
    if (_cachedIOSMajor != null) return;
    try {
      final info = await DeviceInfoPlugin().iosInfo;
      final parts = info.systemVersion.split('.');
      _cachedIOSMajor = int.tryParse(parts.first) ?? 0;
    } catch (_) {
      _cachedIOSMajor = 0;
    }
    debugPrint("=========> _cachedIOSMajor: $_cachedIOSMajor");
  }

  static bool _isIOS26OrLater() {
    return (_cachedIOSMajor ?? 0) >= 26;
  }

  // ── iOS 26+ : CNTabBar natif Liquid Glass avec SF Symbols ──────────────────

  Widget _buildIOSLiquidGlass() {
    return CNTabBar(
      tint: AppColors.primary,
      currentIndex: selectedIndex,
      onTap: onDestinationSelected,
      items: items
          .map((item) => CNTabBarItem(
                label: item.label,
                icon: CNSymbol(item.iosIconName),
                selectedIcon: item.iosIconNameSelected != null
                    ? CNSymbol(item.iosIconNameSelected!)
                    : null,
              ))
          .toList(),
    );
  }

  // ── iOS < 26 & Android : BottomNavigationBar classique ────────────────────

  Widget _buildAndroid(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
            width: 0.5,
          ),
        ),
      ),
      child: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        iconSize: 22,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: selectedIndex,
        onTap: onDestinationSelected,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.normal, fontSize: 11),
        items: items
            .map((item) => BottomNavigationBarItem(
                  icon: item.androidIcon,
                  activeIcon: item.androidIconSelected,
                  label: item.label,
                ))
            .toList(),
      ),
    );
  }
}
