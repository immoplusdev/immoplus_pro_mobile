import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:immoplus_pro/firebase_options.dart';
import 'package:immoplus_pro/services/push/push_message.dart';
import 'package:immoplus_pro/services/push/push_provider.dart';
import 'package:injectable/injectable.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  } catch (_) {}
  log('Handling background message: ${message.messageId}', name: 'FCM_BG');
}

@LazySingleton(as: PushProvider)
class FirebasePushProvider implements PushProvider {
  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
    'immoplus_pro_high_importance_channel',
    'Notifications ImmoPlus Pro',
    description: 'Canal pour les notifications push ImmoPlus Pro',
    importance: Importance.max,
    playSound: true,
  );

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  final StreamController<PushMessage> _foregroundMessageController =
      StreamController<PushMessage>.broadcast();
  final StreamController<PushMessage> _notificationOpenedAppController =
      StreamController<PushMessage>.broadcast();

  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    } catch (_) {}

    // 1. Initialiser le plugin de notifications locales
    const androidInit = AndroidInitializationSettings('@drawable/ic_notification');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null && response.payload!.isNotEmpty) {
          try {
            final data = jsonDecode(response.payload!) as Map<String, dynamic>;
            final message = PushMessage(
              messageId: data['id']?.toString() ?? data['messageId']?.toString(),
              title: data['title']?.toString(),
              body: data['body']?.toString(),
              data: data,
            );
            _notificationOpenedAppController.add(message);
          } catch (e) {
            log('Error parsing local notification payload: $e', name: 'FCM_PROVIDER');
          }
        }
      },
    );

    // 2. Créer le canal Android
    if (Platform.isAndroid) {
      final androidPlugin = _localNotifications.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(_androidChannel);
    }

    // 3. Demander la permission système
    await requestPermission();

    // 4. Configuration d'affichage Foreground sur iOS
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 5. Écouteurs des messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('🔔 FCM onMessage received: ${message.messageId}', name: 'FCM_PROVIDER');
      final pushMessage = _mapRemoteMessage(message);
      _foregroundMessageController.add(pushMessage);

      // Sur Android, afficher une bannière locale au premier plan
      if (Platform.isAndroid) {
        final title = message.notification?.title ?? message.data['title']?.toString();
        final body = message.notification?.body ?? message.data['body']?.toString();

        if (title != null || body != null) {
          final notifId = message.messageId != null
              ? message.messageId.hashCode
              : message.hashCode;
          _localNotifications.show(
            id: notifId,
            title: title,
            body: body,
            notificationDetails: NotificationDetails(
              android: AndroidNotificationDetails(
                _androidChannel.id,
                _androidChannel.name,
                channelDescription: _androidChannel.description,
                icon: '@drawable/ic_notification',
                importance: Importance.max,
                priority: Priority.high,
                color: const Color(0xFF2172CB),
              ),
            ),
            payload: jsonEncode(message.data),
          );
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('🔔 FCM onMessageOpenedApp received: ${message.messageId}', name: 'FCM_PROVIDER');
      _notificationOpenedAppController.add(_mapRemoteMessage(message));
    });

    _isInitialized = true;
    log('✅ FirebasePushProvider initialized', name: 'FCM_PROVIDER');
  }

  @override
  Future<bool> requestPermission() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (e) {
      log('Error requesting permission: $e', name: 'FCM_PROVIDER');
      return false;
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      // Sur iOS, attendre que le token APNs natif soit disponible
      if (Platform.isIOS) {
        String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        int retries = 0;
        while (apnsToken == null && retries < 5) {
          await Future.delayed(const Duration(milliseconds: 500));
          apnsToken = await FirebaseMessaging.instance.getAPNSToken();
          retries++;
        }
        log("APNs token: $apnsToken", name: 'FCM_PROVIDER');
      }
      final token = await FirebaseMessaging.instance.getToken();
      log("token FirebaseMessaging: $token", name: 'FCM_PROVIDER');
      return token;
    } catch (e) {
      log('Error getting FCM token: $e', name: 'FCM_PROVIDER');
      return null;
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      await FirebaseMessaging.instance.deleteToken();
    } catch (e) {
      log('Error deleting FCM token: $e', name: 'FCM_PROVIDER');
    }
  }

  @override
  Stream<String> get onTokenRefresh => FirebaseMessaging.instance.onTokenRefresh;

  @override
  Stream<PushMessage> get onForegroundMessage => _foregroundMessageController.stream;

  @override
  Stream<PushMessage> get onNotificationOpenedApp => _notificationOpenedAppController.stream;

  @override
  Future<PushMessage?> getInitialMessage() async {
    try {
      final message = await FirebaseMessaging.instance.getInitialMessage();
      return message != null ? _mapRemoteMessage(message) : null;
    } catch (e) {
      log('Error getting initial message: $e', name: 'FCM_PROVIDER');
      return null;
    }
  }

  PushMessage _mapRemoteMessage(RemoteMessage message) {
    return PushMessage(
      messageId: message.messageId,
      title: message.notification?.title ?? message.data['title']?.toString(),
      body: message.notification?.body ?? message.data['body']?.toString(),
      data: Map<String, dynamic>.from(message.data),
    );
  }
}
