import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:immoplus_pro/data/schemas/user_model_schema.dart';
import 'package:immoplus_pro/services/deep_link_services.dart';
import 'package:immoplus_pro/views/appli/my_app.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

late Isar isarInstance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  // await Firebase.initializeApp(
  //   name: 'ImmoPlus',
  //   options: DefaultFireabaseOptions.currentPlatform,
  // );
  // Initialize the LocationMarker plugin
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..backgroundColor = Colors.blue.shade300 // Couleur du fond
    ..textColor = Colors.black // Couleur du texte
    ..indicatorColor = CupertinoColors.black
    ..radius = 20
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom; // Utiliser le style personnalisé
  final dir = await getApplicationDocumentsDirectory();

  isarInstance = await Isar.open(
    [
      UserModelSchemaSchema,
    ],
    directory: dir.path,
  );
  DeepLinkServices.initUniLinks();
  return runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MyApp();
  }
}
