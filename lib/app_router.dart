import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/modules/logment_creation/create_lodgment_page.dart';
import 'package:immoplus_pro/services/navigation_service.dart';
import 'package:immoplus_pro/splash_screen.dart';
import 'package:immoplus_pro/views/account/widgets/edit_account.dart';
import 'package:immoplus_pro/views/estates/estates_page.dart';
import 'package:immoplus_pro/views/home_page/home_page.dart';
import 'package:immoplus_pro/views/onboarding/onboarding_page.dart';
import 'package:immoplus_pro/views/place/pages/create_place_page.dart';
import 'package:immoplus_pro/views/place/place_page.dart';
import 'package:immoplus_pro/views/registration/pages/enterprise_registration.dart';
import 'package:immoplus_pro/views/registration/pages/particulier_registration.dart';
import 'package:immoplus_pro/views/registration/registration_main_screen.dart';
import 'package:immoplus_pro/views/residence/residences_page.dart';
import 'package:immoplus_pro/views/residence_detail/residence_page.dart';

import 'views/login_page/login_page.dart';

class AppRouter {
  static bool userIs = false;
  static bool alreadyOpened = false;
  static GoRouter router = GoRouter(
    navigatorKey: NavigationService.navigatorKey,
    initialLocation: '/',
    redirect: (context, state) => null,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/home',
        name: HomePage.name,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/create_plage',
        builder: (context, state) => const CreatePlace(),
        name: CreatePlace.name,
      ),
      GoRoute(
        path: '/registration',
        builder: (context, state) => RegistrationMainScreean(),
        name: RegistrationMainScreean.name,
      ),
      GoRoute(
        path: '/enterprise_registration',
        builder: (context, state) => const EnterpriseRegistrationPage(),
        name: EnterpriseRegistrationPage.name,
      ),
      GoRoute(
        path: '/particulier_registration',
        builder: (context, state) => const ParticulierRegistration(),
        name: ParticulierRegistration.name,
      ),
      GoRoute(
        path: '/create_lodgment',
        builder: (context, state) => CreateLodgmentPage(),
        name: CreateLodgmentPage.name,
      ),
      GoRoute(
        path: '/plage_page',
        builder: (context, state) => PlacePage(),
        name: PlacePage.name,
      ),
      GoRoute(
        path: '/logments',
        name: ResidencesPage.name,
        builder: (context, state) => ResidencesPage(),
      ),
      GoRoute(
        path: '/estates',
        name: EstatesPage.name,
        builder: (context, state) => const EstatesPage(),
      ),
      GoRoute(
        path: '/logment_page/:id',
        builder: (context, state) => ResidencePage(
          idProduct: state.pathParameters['id'].toString(),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => OnBoardingPage(),
      ),
      GoRoute(
        path: '/editAccount',
        name: EditAccount.name,
        builder: (context, state) => EditAccount(),
      ),
      GoRoute(
        path: '/splash',
        name: SplashScreen.name,
        builder: (context, state) => const SplashScreen(),
      ),
      // GoRoute(
      //     path: '/order/:idProduct',
      //     builder: (BuildContext context, GoRouterState state) {
      //       String? _type = null;
      //       try {
      //         _type = state.uri.queryParameters['type'];
      //       } catch (e) {
      //         //log(e.toString(), name: 'ERROR TYPE');
      //       }
      //       return (_type == ProductType.to_order.name)
      //           ? OrderDetailOrderPage(id: state.pathParameters['idProduct']!)
      //           : OrderDetailPage(
      //               id: state.pathParameters['idProduct']!,
      //             );
      //     }),
      GoRoute(
          path: '/login',
          name: LoginPage.name,
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          },
          routes: []),
    ],
  );
}
