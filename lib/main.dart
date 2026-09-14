import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/configs/app_flavor.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/data/schemas/user_model_schema.dart';
import 'package:immoplus_pro/features/appli/my_app.dart';
import 'package:immoplus_pro/features/onboarding/data/onboarding_entity.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

late Isar isarInstance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: AppFlavor.envFileName);
  await initializeDateFormatting('fr_FR');
  await configureDependencies();
  await preload();

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
