import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/network/utils/constants.dart';
import 'package:immoplus_pro/features/authentification/registration_content.dart';
import 'package:immoplus_pro/features/registration/models/data_router_registration.dart';
import 'package:immoplus_pro/features/registration/pages/enterprise_registration.dart';
import 'package:immoplus_pro/features/registration/pages/particulier_registration.dart';

class ChooseAccountTypePage extends StatefulWidget {
  final DataRouterRegistration dataRouterRegistration;
  const ChooseAccountTypePage(
      {super.key, required this.dataRouterRegistration});

  static const String name = 'choose-account-type';
  static String routePath() => '/choose-account-type';

  @override
  State<ChooseAccountTypePage> createState() => _ChooseAccountTypePageState();
}

class _ChooseAccountTypePageState extends State<ChooseAccountTypePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: appPadding),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 31,
                      height: 31,
                      decoration: BoxDecoration(
                          color: AppColors.primary, shape: BoxShape.circle),
                      child: Center(
                          child: Icon(Iconsax.arrow_left_2,
                              size: 16, color: Colors.black87)),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Création de compte",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 31, height: 31),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: RegistrationContent(
                  entrepriseOnTap: () {
                    context.pushReplacementNamed(
                      EnterpriseRegistrationPage.name,
                      extra: widget.dataRouterRegistration,
                    );
                  },
                  particulierOnTap: () {
                    context.pushReplacementNamed(
                      ParticulierRegistration.name,
                      extra: widget.dataRouterRegistration,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
