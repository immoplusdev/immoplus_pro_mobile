import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:immoplus_pro/firebase_options.dart';
import 'package:immoplus_pro/services/deep_link_services.dart';
import 'package:immoplus_pro/services/notification_service.dart';
import 'package:immoplus_pro/services/remote_config_service.dart';
import 'package:immoplus_pro/utils/easy_loading_handler.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    log('⚠️ Firebase.initializeApp() error: $e', name: 'INJECTION');
  }

  getIt.init();
  await getIt<DeepLinkServices>().initUniLinks();
  await getIt<EasyLoadingHandler>().init();
  await getIt<RemoteConfigService>().initialize();

  try {
    await getIt<NotificationService>()
        .initConfig()
        .timeout(const Duration(seconds: 10));
    getIt<NotificationService>().setupNotificationListener();
  } catch (e) {
    log('⚠️ NotificationService init failed: $e', name: 'INJECTION');
  }
}

