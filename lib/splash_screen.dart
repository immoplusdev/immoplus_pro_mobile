import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:immoplus_pro/app_router.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/features/home_page/home_page.dart';
import 'package:immoplus_pro/features/onboarding/onboarding_new_page.dart';
import 'package:immoplus_pro/features/shared_widgets/loading_page.dart';
import 'package:immoplus_pro/services/permission_services.dart';
import 'package:immoplus_pro/utils/session_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static String name = "SPLASH_SCREEN";
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _getData({required BuildContext context}) async {
    log("TOTO");
    bool isAlreadyOpend = await SessionManager().appIsAlreadyOpened();
    log(isAlreadyOpend.toString());
    if (isAlreadyOpend) {
      PermissionServices.requestNotificationPermissions();

      await SessionManager().getCurrentUser();

      if (SessionManager().currentUser == null) {
        AppRouter.router.goNamed(LoadingPage.name);
      } else {
        DioClient.token = SessionManager().currentUser!.accessToken;
        DioClient().dio.options.headers['Authorization'] =
            'Bearer ${SessionManager().currentUser!.accessToken}';
        AppRouter.router.goNamed(HomePage.name);
      }
    } else {
      AppRouter.router.goNamed(OnboardingNewPage.name);
    }
  }

  @override
  void initState() {
    log("TOTO");
    _getData(context: context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const LoadingPage();
  }
}
