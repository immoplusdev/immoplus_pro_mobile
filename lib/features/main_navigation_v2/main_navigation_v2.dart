import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/constantes/constantes.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/data/repositories/messaging_repository.dart';
import 'package:adaptive_liquid_bottom_nav_bar/adaptive_liquid_bottom_nav_bar.dart';
import 'package:immoplus_pro/services/messaging_socket_service.dart';
import 'package:immoplus_pro/utils/session_manager.dart';

class MainNavigationV2 extends StatefulWidget {
  const MainNavigationV2({
    super.key,
    required this.navigationShell,
  });

  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  @override
  State<MainNavigationV2> createState() => _MainNavigationV2State();
}

class _MainNavigationV2State extends State<MainNavigationV2>
    with WidgetsBindingObserver {
  StreamSubscription? _messagingNotificationSub;

  void _fetchUnreadMessagesCount() {
    if (SessionManager().currentUser == null) return;
    MessagingRepository.getTotalUnreadCount().then((count) {
      if (mounted) Constantes.unreadMessagesCount.value = count;
    });
  }

  /// Incrément local immédiat sur `notification_new`, pour que le badge
  /// bouge partout dans l'app, pas seulement pendant que l'onglet Messages
  /// (et son `InboxCubit`) est ouvert. Le socket est déjà connecté dès la
  /// session ouverte (voir `session_manager.dart`), donc ce listener suffit
  /// sans reconnecter quoi que ce soit ici.
  void _listenForUnreadMessages() {
    _messagingNotificationSub?.cancel();
    _messagingNotificationSub =
        getIt<MessagingSocketService>().onNotificationNew.listen((_) {
      Constantes.unreadMessagesCount.value += 1;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchUnreadMessagesCount();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AdaptiveLiquidBottomNavigationBar.precacheIOSVersion();
    _fetchUnreadMessagesCount();
    _listenForUnreadMessages();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messagingNotificationSub?.cancel();
    super.dispose();
  }

  void _onTap(int index) {
    // When navigating to a new branch, it's recommended to use the goBranch
    // method, as doing so makes sure the last navigation state of the
    // Navigator for the branch is restored.
    widget.navigationShell.goBranch(
      index,
      // A common pattern when tapping on the current tab is to
      // navigate to the initial location of that branch.
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  List<AdaptiveBottomNavItem> get _navItems => [
        AdaptiveBottomNavItem(
          label: 'Accueil',
          iosIconName: 'immo_home',
          iosIconNameSelected: 'immo_home_fill',
          androidIcon: Icon(
            Iconsax.trend_up,
            color: Colors.grey.shade600,
            size: 22,
          ),
          androidIconSelected: Icon(
            Iconsax.trend_up,
            color: AppColors.primary,
            size: 22,
          ),
        ),
        const AdaptiveBottomNavItem(
          label: 'Messages',
          iosIconName: 'immo_message',
          iosIconNameSelected: 'immo_message_fill',
          androidIcon: _MessagesNavIcon(isSelected: false),
          androidIconSelected: _MessagesNavIcon(isSelected: true),
        ),
        AdaptiveBottomNavItem(
          label: 'Publier',
          iosIconName: 'immo_add',
          iosIconNameSelected: 'immo_add_fill',
          androidIcon: Icon(
            Iconsax.add_square,
            color: Colors.grey.shade600,
            size: 22,
          ),
          androidIconSelected: Icon(
            Iconsax.add_square5,
            color: AppColors.primary,
            size: 22,
          ),
        ),
        AdaptiveBottomNavItem(
          label: 'Calendrier',
          iosIconName: 'immo_calendar',
          iosIconNameSelected: 'immo_calendar_fill',
          androidIcon: Icon(
            Iconsax.calendar_1,
            color: Colors.grey.shade600,
            size: 22,
          ),
          androidIconSelected: Icon(
            Iconsax.calendar_1,
            color: AppColors.primary,
            size: 22,
          ),
        ),
        AdaptiveBottomNavItem(
          label: 'Compte',
          iosIconName: 'immo_user',
          iosIconNameSelected: 'immo_user_fill',
          androidIcon: Icon(
            Iconsax.user,
            color: Colors.grey.shade600,
            size: 22,
          ),
          androidIconSelected: Icon(
            Iconsax.user,
            color: AppColors.primary,
            size: 22,
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: widget.navigationShell,
      bottomNavigationBar: AdaptiveLiquidBottomNavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: _onTap,
        tint: AppColors.primary,
        items: _navItems,
      ),
    );
  }
}

/// Icône "Messages" de la bottom nav, avec pastille de compteur non-lu
/// mise à jour en direct via [Constantes.unreadMessagesCount].
class _MessagesNavIcon extends StatelessWidget {
  final bool isSelected;
  const _MessagesNavIcon({this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: Constantes.unreadMessagesCount,
      builder: (context, count, _) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              Iconsax.message,
              color: isSelected ? AppColors.primary : Colors.grey.shade600,
              size: 22,
            ),
            if (count > 0)
              Positioned(
                right: -6,
                top: -4,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  constraints:
                      const BoxConstraints(minWidth: 14, minHeight: 14),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    count > 99 ? '99+' : '$count',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 9,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
