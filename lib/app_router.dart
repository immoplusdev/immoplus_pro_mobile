import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/features/account/widgets/edit_account.dart';
import 'package:immoplus_pro/features/authentification/authentification_page.dart';
import 'package:immoplus_pro/features/booking/booking_history_page.dart';
import 'package:immoplus_pro/features/create_estate/create_estate_page.dart';
import 'package:immoplus_pro/features/create_residence/create_lodgment_page.dart';
import 'package:immoplus_pro/features/estate_detail/estate_details_page.dart';
import 'package:immoplus_pro/features/estates/estates_page.dart';
import 'package:immoplus_pro/features/home_page/home_page.dart';
import 'package:immoplus_pro/features/location_module/location_map_page.dart';
import 'package:immoplus_pro/features/onboarding/onboarding_new_page.dart';
import 'package:immoplus_pro/features/payment_module/operators_selector_page.dart';
import 'package:immoplus_pro/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus_pro/features/payments/payments_page.dart';
import 'package:immoplus_pro/features/pin_code/views/pin_code_page.dart';
import 'package:immoplus_pro/features/place/place_page.dart';
import 'package:immoplus_pro/features/profil/update_password_page.dart';
import 'package:immoplus_pro/features/registration/pages/enterprise_registration.dart';
import 'package:immoplus_pro/features/registration/pages/particulier_registration.dart';
import 'package:immoplus_pro/features/registration/pages/send_email_opt_page.dart';
import 'package:immoplus_pro/features/registration/pages/verify_email_otp_page.dart';
import 'package:immoplus_pro/features/reset_password/pages/reset_password_page.dart';
import 'package:immoplus_pro/features/residence/residences_page.dart';
import 'package:immoplus_pro/features/residence_detail/residence_details_page.dart';
import 'package:immoplus_pro/features/visits/visit_history_page.dart';
import 'package:immoplus_pro/services/navigation_service.dart';
import 'package:immoplus_pro/splash_screen.dart';

import 'features/login_page/login_page.dart';

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
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: HomePage.routePath(),
        name: HomePage.name,
        builder: (context, state) => HomePage(
          paiementId: state.extra as String?,
        ),
      ),
      GoRoute(
        path: '/pin_code',
        name: PinCodePage.name,
        builder: (context, state) => PinCodePage(
          onSuccess: () {
            context.goNamed(HomePage.name);
          },
        ),
      ),
      GoRoute(
        path: '/onboarding',
        name: OnboardingNewPage.name,
        builder: (context, state) => OnboardingNewPage(),
      ),
      GoRoute(
        path: '/create_estate',
        builder: (context, state) => const CreateEstatePage(),
        name: CreateEstatePage.name,
      ),
      GoRoute(
        path: '/payments',
        builder: (context, state) => const PaymentsPage(),
        name: PaymentsPage.name,
      ),
      // GoRoute(
      //   path: '/registration',
      //   builder: (context, state) => const RegistrationMainScreean(),
      //   name: RegistrationMainScreean.name,
      // ),
      GoRoute(
        path: '/${AuthenticationPage.name}',
        name: AuthenticationPage.name,
        builder: (context, state) => const AuthenticationPage(),
      ),
      GoRoute(
        path: '/enterprise_registration',
        builder: (context, state) => EnterpriseRegistrationPage(
          dataRouterRegistration: state.extra as DataRouterRegistration,
        ),
        name: EnterpriseRegistrationPage.name,
      ),
      GoRoute(
        path: '/LocationMapPage',
        name: LocationMapPage.name,
        builder: (context, state) => LocationMapPage(),
      ),
      GoRoute(
        path: '/particulier_registration',
        builder: (context, state) => ParticulierRegistration(
          dataRouterRegistration: state.extra as DataRouterRegistration,
        ),
        name: ParticulierRegistration.name,
      ),
      GoRoute(
        path: '/create_lodgment',
        builder: (context, state) => const CreateLodgmentPage(),
        name: CreateLodgmentPage.name,
      ),
      GoRoute(
        path: '/plage_page',
        builder: (context, state) => const PlacePage(),
        name: PlacePage.name,
      ),
      GoRoute(
        path: ResidencesPage.routePath(),
        name: ResidencesPage.name,
        builder: (context, state) => const ResidencesPage(),
      ),
      GoRoute(
        path: EstatesPage.routePath(),
        name: EstatesPage.name,
        builder: (context, state) => const EstatesPage(),
      ),
      GoRoute(
        path: EstateDetailsPage.routePath(),
        builder: (context, state) => EstateDetailsPage(
          idProduct: state.pathParameters['id'].toString(),
        ),
      ),
      GoRoute(
        path: ResidenceDetailsPage.routePath(),
        builder: (context, state) => ResidenceDetailsPage(
          idProduct: state.pathParameters['id'].toString(),
        ),
      ),

      GoRoute(
        path: '/editAccount',
        name: EditAccount.name,
        builder: (context, state) => const EditAccount(),
      ),
      GoRoute(
        path: '/splash',
        name: SplashScreen.name,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/operetors_selector',
        name: OperatorsSelectorPage.name,
        builder: (context, state) => OperatorsSelectorPage(
          paymentPageAdapter: state.extra as PaymentPageAdapter,
        ),
      ),
      GoRoute(
        path: BookingHistoryPage.routePath(),
        name: BookingHistoryPage.name,
        builder: (context, state) => const BookingHistoryPage(),
      ),
      GoRoute(
        path: VisitHistoryPage.routePath(),
        name: VisitHistoryPage.name,
        builder: (context, state) => const VisitHistoryPage(),
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
        routes: const [],
      ),
      GoRoute(
        path: '/reset-password',
        name: ResetPasswordPage.name,
        builder: (BuildContext context, GoRouterState state) {
          return const ResetPasswordPage();
        },
      ),
      GoRoute(
        path: '/update-password',
        name: UpdatePasswordPage.name,
        builder: (BuildContext context, GoRouterState state) {
          return const UpdatePasswordPage();
        },
      ),
      GoRoute(
        path: '/send-email-otp',
        name: SendEmailOptPage.name,
        builder: (BuildContext context, GoRouterState state) {
          final data = state.extra as Map<String, dynamic>;
          final callOnSuccess = data['onSuccess'] as Function(
              DataRouterRegistration dataRouterRegistration);
          return SendEmailOptPage(
            onSuccess: callOnSuccess,
          );
        },
      ),
      GoRoute(
        path: '/verify-email-otp',
        name: VerifyEmailOtpPage.name,
        builder: (BuildContext context, GoRouterState state) {
          final data = state.extra as Map<String, dynamic>;
          final email = data['email'] as String;
          final callOnSuccess = data['onSuccess'] as Function(
              DataRouterRegistration dataRouterRegistration);
          return VerifyEmailOtpPage(
            email: email,
            onSuccess: callOnSuccess,
          );
        },
      ),
    ],
  );
}


// class ExtraVerifyEmailPage {
//   final Function(DataRouterRegistration dataRouterRegistration) onSuccess;
//   final String email;
//   ExtraVerifyEmailPage({required this.onSuccess, required this.email});
// }