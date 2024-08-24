import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/modules/logment_creation/components/amenities_page.dart';
import 'package:immoplus_pro/modules/logment_creation/components/description_editor_page.dart';
import 'package:immoplus_pro/modules/logment_creation/components/home_rules_page.dart';
import 'package:immoplus_pro/modules/logment_creation/components/logement_location_page.dart';
import 'package:immoplus_pro/modules/logment_creation/components/logment_price_page.dart';
import 'package:immoplus_pro/modules/logment_creation/components/pictures_logment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/components/rules_page.dart';
import 'package:immoplus_pro/modules/logment_creation/components/type_logment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/components/video_logment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/components/wellcome_page.dart';

class CreateLogmentRouter {
  static late GoRouter router;
  static ValueNotifier<String> pageStateNotifier =
      ValueNotifier<String>(WellcommePage.name);
  static void setup() {
    router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          name: WellcommePage.name,
          builder: (BuildContext context, GoRouterState state) =>
              WellcommePage(),
        ),
        GoRoute(
          path: '/logment_rules',
          name: RulesPage.name,
          builder: (BuildContext context, GoRouterState state) => RulesPage(),
        ),
        GoRoute(
          path: '/type_logment_page',
          name: TypeLogmentPage.name,
          builder: (BuildContext context, GoRouterState state) =>
              TypeLogmentPage(),
        ),
        GoRoute(
          path: '/pictures_logment_page',
          name: PicturesLogmentPage.name,
          builder: (BuildContext context, GoRouterState state) =>
              PicturesLogmentPage(),
        ),
        GoRoute(
          path: '/video',
          name: VideoLogmentPage.name,
          builder: (BuildContext context, GoRouterState state) =>
              VideoLogmentPage(),
        ),
        GoRoute(
          path: '/amentities',
          name: AmentitiesPage.name,
          builder: (BuildContext context, GoRouterState state) =>
              AmentitiesPage(),
        ),
        GoRoute(
          path: '/location',
          name: LogmentLocationPage.name,
          builder: (BuildContext context, GoRouterState state) =>
              LogmentLocationPage(),
        ),
        GoRoute(
          path: '/description',
          name: DescriptionEditorPage.name,
          builder: (BuildContext context, GoRouterState state) =>
              DescriptionEditorPage(),
        ),
        GoRoute(
          path: '/logment_price',
          name: LogmentPricePage.name,
          builder: (BuildContext context, GoRouterState state) =>
              LogmentPricePage(),
        ),
        GoRoute(
          path: '/home_rules',
          name: HomeRulesPage.name,
          builder: (BuildContext context, GoRouterState state) =>
              HomeRulesPage(),
        ),
        // GoRoute(
        //   path: '/number',
        //   name: OrangePhoneNumberPage.name,
        //   builder: (BuildContext context, GoRouterState state) =>
        //       OrangePhoneNumberPage(),
        // ),
        // GoRoute(
        //   path: '/otp',
        //   name: OrangeOptValidatorPage.name,
        //   builder: (BuildContext context, GoRouterState state) =>
        //       OrangeOptValidatorPage(
        //     paymentIntentModel: state.extra as PaymentIntentModel,
        //   ),
        // ),
      ],
    );
  }
}
