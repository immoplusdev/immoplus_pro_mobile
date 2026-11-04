import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/configs/app_flavor.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/data/schemas/user_model_schema.dart';
import 'package:adaptive_liquid_bottom_nav_bar/adaptive_liquid_bottom_nav_bar.dart';
import 'package:immoplus_pro/features/appli/my_app.dart';
import 'package:immoplus_pro/features/onboarding/data/onboarding_entity.dart';
import 'package:immoplus_pro/firebase_options.dart';
import 'package:immoplus_pro/services/push/firebase_push_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

late Isar isarInstance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    debugPrint('⚠️ Firebase.initializeApp() error in main: $e');
  }

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Gestionnaire global d'erreurs Flutter (layout, rendering, widgets)
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    if (Firebase.apps.isNotEmpty) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    }
  };

  // Gestionnaire global d'erreurs asynchrones non interceptées (Dart engine)
  PlatformDispatcher.instance.onError = (error, stack) {
    if (Firebase.apps.isNotEmpty) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
    return true;
  };

  // Vue de repli élégante pour éviter l'écran rouge de crash en production
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: AppColors.whiteBackground,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: AppColors.redFF0000,
                size: 40,
              ),
              const SizedBox(height: 12),
              Text(
                "Une erreur inattendue est survenue",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                "Veuillez rafraîchir l'écran ou réessayer ultérieurement.",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  };

  await dotenv.load(fileName: AppFlavor.envFileName);
  await initializeDateFormatting('fr_FR');
  await configureDependencies();
  await preload();
  await AdaptiveLiquidBottomNavigationBar.precacheIOSVersion();

  final dir = await getApplicationDocumentsDirectory();

  isarInstance = await Isar.open(
    [
      UserModelSchemaSchema,
      OnboardingEntitySchema,
    ],
    directory: dir.path,
  );
  return runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MyApp();
  }
}

Future<void> preload() => GoogleFonts.pendingFonts([
      GoogleFonts.sen(
        fontSize: 42,
        fontWeight: FontWeight.w800,
        color: const Color(0xFF001B3D),
        height: 1.1,
      )
    ]);
