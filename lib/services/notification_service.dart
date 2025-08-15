import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    OneSignal.initialize(dotenv.env['ONE_SIGNAL_KEY'] ?? '');
    // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
    OneSignal.Notifications.requestPermission(true);
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
