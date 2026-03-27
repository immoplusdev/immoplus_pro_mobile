import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/features/account/widgets/edit_account.dart';
import 'package:immoplus_pro/features/authentification/authentification_page.dart';
import 'package:immoplus_pro/features/authentification/choose_account_type_page.dart';
import 'package:immoplus_pro/features/booking/booking_history_page.dart';
import 'package:immoplus_pro/features/create_estate/create_estate_page.dart';
import 'package:immoplus_pro/features/create_residence/create_lodgment_page.dart';
import 'package:immoplus_pro/features/estate_detail/estate_details_page.dart';
import 'package:immoplus_pro/features/estates/estates_page.dart';
import 'package:immoplus_pro/features/home_page/home_page.dart';
import 'package:immoplus_pro/features/location_module/location_map_page.dart';
import 'package:immoplus_pro/features/login_page/register_page.dart';
import 'package:immoplus_pro/features/onboarding/onboarding_new_page.dart';
import 'package:immoplus_pro/features/payment_module/operators_selector_page.dart';
import 'package:immoplus_pro/features/payment_module/utils/payment_adapter.dart';
import 'package:immoplus_pro/features/payments/payments_page.dart';
import 'package:immoplus_pro/features/pin_code/views/pin_code_page.dart';
import 'package:immoplus_pro/features/place/place_page.dart';
import 'package:immoplus_pro/features/profil/update_password_page.dart';
import 'package:immoplus_pro/features/registration/models/data_router_registration.dart';
import 'package:immoplus_pro/features/registration/pages/enterprise_registration.dart';
import 'package:immoplus_pro/features/registration/pages/particulier_registration.dart';
import 'package:immoplus_pro/features/registration/pages/send_email_opt_page.dart';
import 'package:immoplus_pro/features/registration/pages/verify_email_otp_page.dart';
import 'package:immoplus_pro/features/reset_password/pages/reset_password_page.dart';
import 'package:immoplus_pro/features/residence/residences_page.dart';
import 'package:immoplus_pro/features/residence_detail/residence_details_page.dart';
import 'package:immoplus_pro/features/visits/visit_history_page.dart';
import 'package:immoplus_pro/force_update_required_page.dart';
import 'package:immoplus_pro/services/navigation_service.dart';
import 'package:immoplus_pro/splash_screen.dart';

import 'features/login_page/login_page.dart';

// ── Contract module ──
import 'package:immoplus_pro/features/contract/logic/contract_mode.dart';
import 'package:immoplus_pro/features/contract/screens/contract_page.dart';

// ── Pending reservations ──
import 'package:immoplus_pro/features/reservations/pending/pending_reservations_page.dart';

// ── Contact change ──
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/data/enums/contact_change_type.dart';
import 'package:immoplus_pro/features/contact_change/cubit/contact_change_cubit.dart';
import 'package:immoplus_pro/features/contact_change/view/change_credentials_page.dart';
import 'package:immoplus_pro/features/contact_change/view/confirm_contact_change_page.dart';
import 'package:immoplus_pro/features/contact_change/view/request_contact_change_page.dart';

// ── Furniture module ──
import 'package:immoplus_pro/features/furnitures/furnitures_page.dart';
import 'package:immoplus_pro/features/furniture_detail/furniture_detail_page.dart';
import 'package:immoplus_pro/features/create_furniture/create_furniture_page.dart';

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

      GoRoute(
        path: '/${RegisterPage.name}',
        name: RegisterPage.name,
        builder: (BuildContext context, GoRouterState state) {
          return const RegisterPage();
        },
      ),
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
      GoRoute(
        path: ChooseAccountTypePage.routePath(),
        name: ChooseAccountTypePage.name,
        builder: (BuildContext context, GoRouterState state) {
          final data = state.extra as DataRouterRegistration;
          return ChooseAccountTypePage(
            dataRouterRegistration: data,
          );
        },
      ),
      GoRoute(
        path: ForceUpdateRequiredPage.routePath(),
        name: ForceUpdateRequiredPage.name,
        builder: (context, state) {
          final onUpdateTap = state.extra as Function()?;
          return ForceUpdateRequiredPage(
            onUpdateTap: onUpdateTap,
          );
        },
      ),

      // ── Contract module ──
      GoRoute(
        path: ContractPage.routePath,
        name: ContractPage.routeName,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ContractPage(
            isSigned: extra?['isSigned'] as bool? ?? false,
            mode: extra?['mode'] as ContractMode? ?? ContractMode.sign,
            onSigned: extra?['onSigned'] as VoidCallback?,
          );
        },
      ),

      // ── Pending reservations ──
      GoRoute(
        path: PendingReservationsPage.routePath(),
        name: PendingReservationsPage.name,
        builder: (context, state) => const PendingReservationsPage(),
      ),

      // ── Contact change ──
      GoRoute(
        path: '/settings/credentials',
        name: ChangeCredentialsPage.name,
        builder: (context, state) => const ChangeCredentialsPage(),
      ),
      GoRoute(
        path: '/settings/change-contact',
        name: RequestContactChangePage.name,
        builder: (context, state) {
          final type = state.extra as ContactChangeType;
          return BlocProvider(
            create: (_) => ContactChangeCubit(),
            child: RequestContactChangePage(type: type),
          );
        },
        routes: [
          GoRoute(
            path: 'confirm',
            name: ConfirmContactChangePage.name,
            builder: (context, state) {
              final type = state.extra as ContactChangeType;
              return BlocProvider(
                create: (_) => ContactChangeCubit(),
                child: ConfirmContactChangePage(type: type),
              );
            },
          ),
        ],
      ),

      // ── Furniture module ──
      GoRoute(
        path: '/furnitures',
        name: FurnituresPage.name,
        builder: (context, state) => const FurnituresPage(),
      ),
      GoRoute(
        path: '/furnitures/detail/:id',
        name: FurnitureDetailPage.name,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return FurnitureDetailPage(furnitureId: id);
        },
      ),
      GoRoute(
        path: '/create_furniture',
        name: CreateFurniturePage.name,
        builder: (context, state) => const CreateFurniturePage(),
      ),
    ],
  );
}


// class ExtraVerifyEmailPage {
//   final Function(DataRouterRegistration dataRouterRegistration) onSuccess;
//   final String email;
//   ExtraVerifyEmailPage({required this.onSuccess, required this.email});
// }