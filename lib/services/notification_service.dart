import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:immoplus_pro/app_router.dart';
import 'package:immoplus_pro/core/enum/push_notification_type.dart';
import 'package:immoplus_pro/core/extensions/go_router_extensions.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/data/enums/account_source.dart';
import 'package:immoplus_pro/data/repositories/notification_repository.dart';
import 'package:immoplus_pro/features/messaging/logic/inbox_cubit.dart';
import 'package:immoplus_pro/services/analytics_service.dart';
import 'package:immoplus_pro/services/app_version_service.dart';
import 'package:immoplus_pro/services/pending_reservation_overlay_service.dart';
import 'package:immoplus_pro/services/push/push_installation_service.dart';
import 'package:immoplus_pro/services/push/push_message.dart';
import 'package:immoplus_pro/services/push/push_provider.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NotificationService {
  final PushProvider pushProvider;
  final SessionManager sessionManager;
  final NotificationRepository notificationRepository;
  final AnalyticsService analyticsService;
  final PushInstallationService pushInstallationService;

  bool _listenersConfigured = false;

  NotificationService(
    this.pushProvider,
    this.sessionManager,
    this.notificationRepository,
    this.analyticsService,
    this.pushInstallationService,
  );

  Future<String> getPushInstallationId() =>
      pushInstallationService.getInstallationId();

  /// Initialise la configuration et l'écoute du renouvellement de token
  Future<void> initConfig() async {
    await pushProvider.initialize();

    pushProvider.onTokenRefresh.listen((token) {
      log('🔔 Push token refreshed: $token', name: 'NOTIFICATION_SERVICE');
      suscribeCurrentUser(token: token);
    });

    await suscribeCurrentUser();
  }

  /// Configure les listeners globaux (Foreground, Background, Terminated)
  void setupNotificationListener() {
    if (_listenersConfigured) {
      log('🔔 Listeners already configured, skipping duplicate',
          name: 'NOTIFICATION_SERVICE');
      return;
    }
    _listenersConfigured = true;

    // 1. Premier plan
    pushProvider.onForegroundMessage.listen((PushMessage message) {
      final typeString = message.data['type']?.toString();
      log('🔔 Push received in foreground: ${message.messageId}, type: $typeString',
          name: 'NOTIFICATION_SERVICE');
      analyticsService.logPushNotificationReceived(
        idNotification: message.messageId ?? 'unknown',
        typeNotification: typeString ?? 'unknown',
      );

      final type = PushNotificationType.fromString(typeString);
      if (type == PushNotificationType.newReservationWaiting) {
        log('🔔 New pending reservation received → refresh banner',
            name: 'NOTIFICATION_SERVICE');
        getIt<PendingReservationOverlayService>().refreshPendingReservation();
      } else if (type == PushNotificationType.newMessage) {
        log('🔔 New message push received → refresh inbox badge',
            name: 'NOTIFICATION_SERVICE');
        getIt<InboxCubit>().refreshBadgeOnly();
      }
    });

    // 2. Clic depuis l'arrière-plan
    pushProvider.onNotificationOpenedApp.listen((PushMessage message) {
      final typeString = message.data['type']?.toString() ?? 'unknown';
      log('🔔 Push clicked from background: ${message.messageId}',
          name: 'NOTIFICATION_SERVICE');
      analyticsService.logPushNotificationTapped(
        idNotification: message.messageId ?? 'unknown',
        typeNotification: typeString,
      );
      handleNotificationData(message.data);
    });

    // 3. Clic à froid (Terminated)
    pushProvider.getInitialMessage().then((PushMessage? message) {
      if (message != null) {
        final typeString = message.data['type']?.toString() ?? 'unknown';
        log('🔔 Initial push from terminated state: ${message.messageId}',
            name: 'NOTIFICATION_SERVICE');
        analyticsService.logPushNotificationTapped(
          idNotification: message.messageId ?? 'unknown',
          typeNotification: typeString,
        );
        handleNotificationData(message.data);
      }
    });
  }

  /// Routage après clic sur notification
  void handleNotificationData(Map<String, dynamic> data) {
    log("handleNotificationData: $data", name: 'NOTIFICATION_SERVICE');
    final typeString = data['type']?.toString();
    final id = data['id']?.toString() ??
        data['alertId']?.toString() ??
        data['reservationId']?.toString() ??
        data['conversationId']?.toString() ??
        data['referenceId']?.toString();

    final type = PushNotificationType.fromString(typeString);

    if (sessionManager.currentUser == null) {
      log('🔔 Notification received but no user logged in',
          name: 'NOTIFICATION_SERVICE');
      return;
    }

    if (type != null) {
      final code = data['code']?.toString();
      final route = type.getRoute(id, code: code);

      if (route != null) {
        log('🔔 Navigation: ${AppRouter.router.currentLocation} → $route',
            name: 'NOTIFICATION_SERVICE');
        AppRouter.router.navigateNotificationRoute(route);
      }

      if (type == PushNotificationType.newReservationWaiting) {
        getIt<PendingReservationOverlayService>().refreshPendingReservation();
      } else if (type == PushNotificationType.newMessage) {
        getIt<InboxCubit>().refreshBadgeOnly();
      }
    }
  }

  /// Enregistre l'appareil auprès du backend (`PUT /me/push-installations/:id`)
  Future<void> suscribeCurrentUser({String? token}) async {
    try {
      final user = sessionManager.currentUser;
      if (user == null) {
        log('🔔 Push registration skipped: no authenticated user',
            name: 'NOTIFICATION_SERVICE');
        return;
      }

      final pushToken = token ?? await pushProvider.getToken();
      if (pushToken == null || pushToken.isEmpty) {
        log('⚠️ Push token is null or empty', name: 'NOTIFICATION_SERVICE');
        return;
      }

      final installationId = await getPushInstallationId();
      final appVersion = await AppVersionService.getFullVersion();
      final platform = PushPlatform.current.value;
      final locale = Platform.localeName.replaceAll('_', '-');

      final body = <String, dynamic>{
        'app': PushApp.pro.value, // 'pro'
        'platform': platform,
        'token': pushToken,
        'appVersion': appVersion,
        'locale': locale,
      };

      log('Registering push installation: $installationId (platform: $platform, app: pro)',
          name: 'NOTIFICATION_SERVICE');

      await notificationRepository.registerPushInstallation(
        installationId: installationId,
        body: body,
      );

      log('✅ Push installation successfully registered',
          name: 'NOTIFICATION_SERVICE');
    } catch (e) {
      log('⚠️ Error in suscribeCurrentUser: $e', name: 'NOTIFICATION_SERVICE');
    }
  }

  /// Détache l'appareil du compte lors de la déconnexion (`DELETE /me/push-installations/:id`)
  Future<void> unsubcribeCurrentUser() async {
    try {
      final user = sessionManager.currentUser;
      if (user != null) {
        final installationId = await getPushInstallationId();
        log('Deleting push installation: $installationId',
            name: 'NOTIFICATION_SERVICE');
        try {
          await notificationRepository.deletePushInstallation(installationId);
        } catch (e) {
          log('⚠️ Error calling deletePushInstallation API: $e',
              name: 'NOTIFICATION_SERVICE');
        }
      }
      try {
        await pushProvider.deleteToken();
        log('✅ Push token deleted', name: 'NOTIFICATION_SERVICE');
      } catch (e) {
        log('⚠️ Error deleting push token: $e', name: 'NOTIFICATION_SERVICE');
      }
    } catch (e) {
      log('⚠️ Error in unsubcribeCurrentUser: $e',
          name: 'NOTIFICATION_SERVICE');
    }
  }
}
