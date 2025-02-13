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
// import 'package:immoplus_pro/views/estate_creation/components/estate_amenities_page.dart';
// import 'package:immoplus_pro/views/estate_creation/components/estate_logement_location_page.dart';
// import 'package:immoplus_pro/views/estate_creation/components/estate_logment_price_page.dart';
// import 'package:immoplus_pro/views/estate_creation/components/estate_pictures_logment_page.dart';
// import 'package:immoplus_pro/views/estate_creation/components/estate_type_logment_page.dart';
// import 'package:immoplus_pro/views/estate_creation/components/estate_video_logment_page.dart';
// import 'package:immoplus_pro/views/estate_creation/components/estate_wellcome_page.dart';
// import 'package:immoplus_pro/views/estate_creation/components/estatedescription_editor_page.dart';

// class CreateEstateRouter {
//   static late GoRouter router;
//   static ValueNotifier<String> pageStateNotifier =
//       ValueNotifier<String>(EstateWellcommePage.name);
//   static void setup() {
//     router = GoRouter(
//       initialLocation: '/',
//       routes: [
//         GoRoute(
//           path: '/',
//           name: EstateWellcommePage.name,
//           builder: (BuildContext context, GoRouterState state) =>
//               const EstateWellcommePage(),
//         ),
//         GoRoute(
//           path: '/type_logment_page',
//           name: EstateTypePage.name,
//           builder: (BuildContext context, GoRouterState state) =>
//               const EstateTypePage(),
//         ),
//         GoRoute(
//           path: '/pictures_logment_page',
//           name: EstatePicturesLogmentPage.name,
//           builder: (BuildContext context, GoRouterState state) =>
//               const EstatePicturesLogmentPage(),
//         ),
//         GoRoute(
//           path: '/video',
//           name: EstateVideoLogmentPage.name,
//           builder: (BuildContext context, GoRouterState state) =>
//               const EstateVideoLogmentPage(),
//         ),
//         GoRoute(
//           path: '/amentities',
//           name: EstateAmentitiesPage.name,
//           builder: (BuildContext context, GoRouterState state) =>
//               const EstateAmentitiesPage(),
//         ),
//         GoRoute(
//           path: '/location',
//           name: EstateLogmentLocationPage.name,
//           builder: (BuildContext context, GoRouterState state) =>
//               const EstateLogmentLocationPage(),
//         ),
//         GoRoute(
//           path: '/description',
//           name: EstateDescriptionEditorPage.name,
//           builder: (BuildContext context, GoRouterState state) =>
//               const EstateDescriptionEditorPage(),
//         ),
//         GoRoute(
//           path: '/logment_price',
//           name: EstateLogmentPricePage.name,
//           builder: (BuildContext context, GoRouterState state) =>
//               const EstateLogmentPricePage(),
//         ),
//       ],
//     );
//   }
// }
