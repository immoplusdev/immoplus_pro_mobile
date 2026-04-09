import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

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
