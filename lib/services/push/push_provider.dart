import 'package:immoplus_pro/services/push/push_message.dart';

abstract class PushProvider {
  Future<void> initialize();
  Future<bool> requestPermission();
  Future<String?> getToken();
  Future<void> deleteToken();

  Stream<String> get onTokenRefresh;
  Stream<PushMessage> get onForegroundMessage;
  Stream<PushMessage> get onNotificationOpenedApp;
  Future<PushMessage?> getInitialMessage();
}
