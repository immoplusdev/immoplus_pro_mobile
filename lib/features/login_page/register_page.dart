import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/features/authentification/custom_page_immo.dart';
import 'package:immoplus_pro/features/authentification/registration_content.dart';
import 'package:immoplus_pro/features/registration/models/data_router_registration.dart';
import 'package:immoplus_pro/features/registration/pages/enterprise_registration.dart';
import 'package:immoplus_pro/features/registration/pages/particulier_registration.dart';
import 'package:immoplus_pro/features/registration/pages/send_email_opt_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static String name = "REGISTER_PAGE";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late PageController _pageController;
  late ValueNotifier<int> _currentPageNotifier;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentPageNotifier = ValueNotifier<int>(0);

    // Écouter les changements de page
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (_currentPageNotifier.value != page) {
        _currentPageNotifier.value = page;
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPageNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPageImmo(
      title: "S'inscrire",
      content: SingleChildScrollView(
        child: RegistrationContent(
          entrepriseOnTap: () {
            context.pushNamed(
              SendEmailOptPage.name,
              extra: {
                "onSuccess": (DataRouterRegistration dataRouterRegistration) {
                  context.pushReplacementNamed(
                    EnterpriseRegistrationPage.name,
                    extra: dataRouterRegistration,
                  );
                },
              },
            );
          },
          particulierOnTap: () {
            context.pushNamed(SendEmailOptPage.name, extra: {
              "onSuccess": (DataRouterRegistration dataRouterRegistration) {
                context.pushReplacementNamed(
                  ParticulierRegistration.name,
                  extra: dataRouterRegistration,
                );
              }
            });
          },
        ),
      ),
    );
  }
}
