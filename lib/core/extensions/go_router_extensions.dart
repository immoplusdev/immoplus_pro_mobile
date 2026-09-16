import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/features/account_v2/account_page_v2.dart';
import 'package:immoplus_pro/features/calendar/calendar_page_v2.dart';
import 'package:immoplus_pro/features/creations_v2/creations_page_v2.dart';
import 'package:immoplus_pro/features/home_v2/home_page_v2.dart';
import 'package:immoplus_pro/features/messaging/pages/messages_inbox_page.dart';

extension GoRouterExtension on GoRouter {
  /// Obtenir la route actuelle
  String get currentLocation {
    return routeInformationProvider.value.uri.path;
  }

  /// Push seulement si différent
  void pushIfDifferent(String route) {
    if (!route.startsWith(currentLocation)) {
      push(route);
    }
  }

  /// Go seulement si différent (met à jour les branches du StatefulShellRoute)
  void goIfDifferent(String route) {
    if (currentLocation != route) {
      go(route);
    }
  }

  /// Navigate en utilisant `go` pour les ShellRoutes et `push` pour les autres pages
  void navigateNotificationRoute(String route) {
    final shellRoutes = [
      HomePageV2.routePath,
      CalendarPageV2.routePath,
      CreationsPageV2.routePath,
      MessagesInboxPage.routePath,
      AccountPageV2.routePath,
    ];

    if (shellRoutes.contains(route)) {
      goIfDifferent(route);
    } else {
      pushIfDifferent(route);
    }
  }

  /// Pop [count] fois si possible.
  void mayPop(BuildContext context, {int count = 1}) {
    for (var i = 0; i < count; i++) {
      if (!context.canPop()) break;
      context.pop();
    }
  }

  /// Pop les pages jusqu'à ce que la route nommée [name] soit au sommet.
  /// Si [name] n'est pas dans la stack, pop toutes les pages.
  void popUntilNamed(BuildContext context, String name) {
    while (context.canPop()) {
      final matches = routerDelegate.currentConfiguration.matches;
      if (matches.isNotEmpty && matches.last.route is GoRoute) {
        final currentName = (matches.last.route as GoRoute).name;
        if (currentName == name) break;
      }
      context.pop();
    }
  }
}
