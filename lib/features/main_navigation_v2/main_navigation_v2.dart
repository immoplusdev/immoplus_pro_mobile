import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/constantes/constantes.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/data/repositories/messaging_repository.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: Container(
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
          currentIndex: widget.navigationShell.currentIndex,
          onTap: _onTap,
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          unselectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.normal, fontSize: 11),
          items: [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.trend_up),
            activeIcon: Icon(Iconsax.trend_up),
            label: 'Accueil',
          ),
          const BottomNavigationBarItem(
            icon: _MessagesNavIcon(),
            activeIcon: _MessagesNavIcon(),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.add_square),
            activeIcon: Icon(Iconsax.add_square5),
            label: 'Publier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.calendar_1),
            activeIcon: Icon(Iconsax.calendar_1),
            label: 'Calendrier',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Iconsax.user),
            activeIcon: Icon(Iconsax.user),
            label: 'Compte',
          ),
        ],
      ),
      ),
    );
  }
}

/// Icône "Messages" de la bottom nav, avec pastille de compteur non-lu
/// mise à jour en direct via [Constantes.unreadMessagesCount].
class _MessagesNavIcon extends StatelessWidget {
  const _MessagesNavIcon();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: Constantes.unreadMessagesCount,
      builder: (context, count, _) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Iconsax.message),
            if (count > 0)
              Positioned(
                right: -6,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    count > 99 ? '99+' : '$count',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
