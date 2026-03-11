import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:immoplus_pro/app_router.dart';
import 'package:immoplus_pro/core/enum/push_notification_type.dart';
import 'package:immoplus_pro/core/extensions/go_router_extensions.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/services/navigation_service.dart';
import 'package:immoplus_pro/services/pending_reservation_overlay_service.dart';
import 'package:immoplus_pro/firebase_options.dart';
import 'package:immoplus_pro/utils/session_manager.dart';

import 'package:injectable/injectable.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

@lazySingleton
class NotificationService {
  // SessionManager sessionManager;
  NotificationService();

  initConfig() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    //Remove this method to stop OneSignal Debugging
    if (kDebugMode) {
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    }
    OneSignal.initialize(
        dotenv.env['ONE_SIGNAL_KEY'] ?? '7eb65c1b-a1c3-4bd2-9a3c-955743582362');
    // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.Notifications.requestPermission(true);
  }

  void setupNotificationListener() {
    OneSignal.Notifications.addClickListener((event) {
      final data = event.notification.additionalData;
      if (data != null) {
        final typeString = data['type'] as String?;
        final id = data['id'] as String?;

        final type = PushNotificationType.fromString(typeString);
        final sessionManager = getIt<SessionManager>();
        if (sessionManager.currentUser == null) {
          log('🔔 Notification received but no user logged in',
              name: 'NOTIFICATION');
          return;
        }

        if (type != null) {
          final route = type.getRoute(id);

          if (route != null) {
            log('🔔 Navigation: ${AppRouter.router.currentLocation} → $route',
                name: 'NOTIFICATION');
            AppRouter.router.pushIfDifferent(route);
          } else {
            log('⚠️ Pas de route pour type: $typeString', name: 'NOTIFICATION');
          }

          if (type == PushNotificationType.newReservationWaiting) {
            final ctx = NavigationService.navigatorKey.currentContext;
            if (ctx != null) {
              getIt<PendingReservationOverlayService>()
                  .checkAndShowOverlay(ctx);
            }
          }
        }
      }
    });
  }

  suscribeCurrentUser() async {
    try {
      if (SessionManager().currentUser != null) {
        await OneSignal.login(SessionManager().currentUser!.userId ?? '');

        if (kDebugMode) {
          log(SessionManager().currentUser!.userId.toString(),
              name: 'SUSCRIPTION SUCCESS');
        }
      } else {
        log('SUBSCRIPTION FAILD NO USER');
      }
    } catch (e) {
      log('SUBSCRIPTION  ${e.toString()}');
    }
  }
}
