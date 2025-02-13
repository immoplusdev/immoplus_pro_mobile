import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:immoplus_pro/app_router.dart';
import 'package:immoplus_pro/configs/theme_config.dart';
import 'package:immoplus_pro/constantes/list_bloc.dart';
import 'package:immoplus_pro/supported_locales.dart';
import 'package:toastification/toastification.dart';

class MyApp extends StatefulWidget {
  MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  chekUser() async {}

  @override
  Widget build(BuildContext context) {
    //inspect(UserModel());
    return MultiBlocProvider(
      providers: BlocsManager.listBlocProviders,
      child: ToastificationWrapper(
        child: MaterialApp.router(
          localizationsDelegates: const [
            CountryLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate, // This is required
          ],
          supportedLocales: immoPlusSupportedLocales,
          debugShowCheckedModeBanner: false,
          theme: ThemeConfig.lightTheme(context: context),
          //darkTheme: ThemeConfig.darkTheme(context: context),
          //routerConfig: Constantes.appRouter,
          routeInformationParser: AppRouter.router.routeInformationParser,
          routeInformationProvider: AppRouter.router.routeInformationProvider,
          routerDelegate: AppRouter.router.routerDelegate,
          backButtonDispatcher: AppRouter.router.backButtonDispatcher,
          builder: EasyLoading.init(),
        ),
      ),
    );
  }
}
