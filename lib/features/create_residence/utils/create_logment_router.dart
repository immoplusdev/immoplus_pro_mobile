// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:immoplus_pro/modules/logment_creation/screens/amenities_page.dart';
// import 'package:immoplus_pro/modules/logment_creation/screens/description_editor_page.dart';
// import 'package:immoplus_pro/modules/logment_creation/screens/home_rules_page.dart';
// import 'package:immoplus_pro/modules/logment_creation/screens/logement_location_page.dart';
// import 'package:immoplus_pro/modules/logment_creation/screens/logment_price_page.dart';
// import 'package:immoplus_pro/modules/logment_creation/screens/pictures_logment_page.dart';
// import 'package:immoplus_pro/modules/logment_creation/screens/rules_page.dart';
// import 'package:immoplus_pro/modules/logment_creation/screens/type_logment_page.dart';
// import 'package:immoplus_pro/modules/logment_creation/screens/video_logment_page.dart';
// import 'package:immoplus_pro/modules/logment_creation/screens/wellcome_page.dart';

// class CreateLogmentRouter {
//   static ValueNotifier<String> pageStateNotifier =
//       ValueNotifier<String>(WellcommePage.name);
//   static GoRouter router = GoRouter(
//     initialLocation: '/',
//     routes: [
//       GoRoute(
//         path: '/',
//         name: WellcommePage.name,
//         builder: (BuildContext context, GoRouterState state) =>
//             const WellcommePage(),
//       ),
//       GoRoute(
//         path: '/logment_rules',
//         name: RulesPage.name,
//         builder: (BuildContext context, GoRouterState state) =>
//             const RulesPage(),
//       ),
//       GoRoute(
//         path: '/type_logment_page',
//         name: TypeLogmentPage.name,
//         builder: (BuildContext context, GoRouterState state) =>
//             const TypeLogmentPage(),
//       ),
//       GoRoute(
//         path: '/pictures_logment_page',
//         name: PicturesLogmentPage.name,
//         builder: (BuildContext context, GoRouterState state) =>
//             const PicturesLogmentPage(),
//       ),
//       GoRoute(
//         path: '/video',
//         name: VideoLogmentPage.name,
//         builder: (BuildContext context, GoRouterState state) =>
//             const VideoLogmentPage(),
//       ),
//       GoRoute(
//         path: '/amentities',
//         name: AmentitiesPage.name,
//         builder: (BuildContext context, GoRouterState state) =>
//             const AmentitiesPage(),
//       ),
//       GoRoute(
//         path: '/location',
//         name: LogmentLocationPage.name,
//         builder: (BuildContext context, GoRouterState state) =>
//             const LogmentLocationPage(),
//       ),
//       GoRoute(
//         path: '/description',
//         name: DescriptionEditorPage.name,
//         builder: (BuildContext context, GoRouterState state) =>
//             const DescriptionEditorPage(),
//       ),
//       GoRoute(
//         path: '/logment_price',
//         name: LogmentPricePage.name,
//         builder: (BuildContext context, GoRouterState state) =>
//             const LogmentPricePage(),
//       ),
//       GoRoute(
//         path: '/home_rules',
//         name: HomeRulesPage.name,
//         builder: (BuildContext context, GoRouterState state) =>
//             const HomeRulesPage(),
//       ),
//       // GoRoute(
//       //   path: '/number',
//       //   name: OrangePhoneNumberPage.name,
//       //   builder: (BuildContext context, GoRouterState state) =>
//       //       OrangePhoneNumberPage(),
//       // ),
//       // GoRoute(
//       //   path: '/otp',
//       //   name: OrangeOptValidatorPage.name,
//       //   builder: (BuildContext context, GoRouterState state) =>
//       //       OrangeOptValidatorPage(
//       //     paymentIntentModel: state.extra as PaymentIntentModel,
//       //   ),
//       // ),
//     ],
//   );
// }
