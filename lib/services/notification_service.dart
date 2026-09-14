import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:immoplus_pro/app_router.dart';
import 'package:immoplus_pro/core/enum/push_notification_type.dart';
import 'package:immoplus_pro/core/extensions/go_router_extensions.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/features/messaging/logic/inbox_cubit.dart';
import 'package:immoplus_pro/services/pending_reservation_overlay_service.dart';
import 'package:immoplus_pro/firebase_options.dart';
import 'package:immoplus_pro/utils/session_manager.dart';

import 'package:injectable/injectable.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:immoplus_pro/services/analytics_service.dart';

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
  }

  void setupNotificationListener() {
    /// Notification reçue pendant que l'app est ouverte
    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      final data = event.notification.additionalData;

      getIt<AnalyticsService>().logPushNotificationReceived(
        idNotification: event.notification.notificationId,
        typeNotification: data?['type'] as String? ?? 'unknown',
      );

      if (data != null) {
        final typeString = data['type'] as String?;
        final type = PushNotificationType.fromString(typeString);

        if (type == PushNotificationType.newReservationWaiting) {
          log(
            '🔔 New pending reservation received → refresh pending reservation banner',
            name: 'NOTIFICATION',
          );

          getIt<PendingReservationOverlayService>().refreshPendingReservation();
        }

        if (type == PushNotificationType.newMessage) {
          log(
            '🔔 New message push received → refresh unread messages badge',
            name: 'NOTIFICATION',
          );

          getIt<InboxCubit>().refreshBadgeOnly();
        }
      }

      event.preventDefault();
      event.notification.display();
    });

    /// Notification cliquée
    OneSignal.Notifications.addClickListener((event) {
      final data = event.notification.additionalData;

      getIt<AnalyticsService>().logPushNotificationTapped(
        idNotification: event.notification.notificationId,
        typeNotification: data?['type'] as String? ?? 'unknown',
      );

      if (data != null) {
        final typeString = data['type'] as String?;
        final id = data['id'] as String? ??
            data['referenceId'] as String? ??
            data['reservationId'] as String? ??
            data['conversationId'] as String?;

        final type = PushNotificationType.fromString(typeString);
        final sessionManager = getIt<SessionManager>();
        if (sessionManager.currentUser == null) {
          log('🔔 Notification received but no user logged in',
              name: 'NOTIFICATION');
          return;
        }

        if (type != null) {
          final code = data['code'] as String?;
          final route = type.getRoute(id, code: code);

          if (route != null) {
            log('🔔 Navigation: ${AppRouter.router.currentLocation} → $route',
                name: 'NOTIFICATION');
            AppRouter.router.navigateNotificationRoute(route);
          } else {
            log('⚠️ Pas de route pour type: $typeString', name: 'NOTIFICATION');
          }

          if (type == PushNotificationType.newReservationWaiting) {
            getIt<PendingReservationOverlayService>()
                .refreshPendingReservation();
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
