import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/network/utils/constants.dart';
import 'package:immoplus_pro/cubits/authentification/login_cubit.dart';
// import 'package:gap/gap.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:immoplus_pro/features/login_page/pages/login_with_email_screen.dart';
// import 'package:immoplus_pro/widgets/custom_tab_selector.dart';
import 'package:immoplus_pro/features/otp_login/otp_login_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String name = "LOGIN_PAGE";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Onglets Email / Numéro désactivés : seule la connexion par numéro reste
  // active, donc plus besoin de PageController ni de sélecteur d'onglets.
  // late PageController _pageController;
  // late ValueNotifier<int> _currentPageNotifier;

  // @override
  // void initState() {
  //   super.initState();
  //   _pageController = PageController();
  //   _currentPageNotifier = ValueNotifier<int>(0);

  //   // Écouter les changements de page
  //   _pageController.addListener(() {
  //     final page = _pageController.page?.round() ?? 0;
  //     if (_currentPageNotifier.value != page) {
  //       _currentPageNotifier.value = page;
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   _pageController.dispose();
  //   _currentPageNotifier.dispose();
  //   super.dispose();
  // }

  // void _onTabSelected(int index) {
  //   _pageController.animateToPage(
  //     index,
  //     duration: const Duration(milliseconds: 300),
  //     curve: Curves.easeInOut,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 64,
          leading: Padding(
            padding: const EdgeInsets.only(left: 24),
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: const Icon(
                  Iconsax.arrow_left_2,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(appPadding),
            child: OTPLoginPage(
              onSwitchMode: () {},
            ),
            // child: PageView(
            //   controller: _pageController,
            //   physics: const NeverScrollableScrollPhysics(),
            //   children: [
            //     LoginWithEmailScreen(
            //       onSwitchMode: () => _onTabSelected(1),
            //     ),
            //     OTPLoginPage(
            //       onSwitchMode: () => _onTabSelected(0),
            //     ),
            //   ],
            // ),
          ),
        ),
      ),
    );
  }
}
