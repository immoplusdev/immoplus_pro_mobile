import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/utils/hex_color.dart';
import 'package:immoplus_pro/views/registration/pages/enterprise_registration.dart';
import 'package:immoplus_pro/views/registration/pages/particulier_registration.dart';
import 'package:immoplus_pro/views/registration/widgets/main_registration_button.dart';

class RegistrationMainScreean extends StatelessWidget {
  const RegistrationMainScreean({super.key});
  static String name = 'REGISTRATION_MAIN_SCREEN';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scafold,
      body: CustomScrollView(slivers: [
        SliverAppBar(),
        SliverSafeArea(
          sliver: SliverToBoxAdapter(
            child: SvgPicture.asset(
              'assets/icons/logo_immo.svg',
              color: HexColor.fromHex('#2072ca'),
              width: 100,
            ),
          ),
        ),
        SliverSafeArea(
          sliver: SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Inscription professionel ImmoPlus",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
        ),
        const SliverGap(100),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: MainRegistrationButton(
                      icon: FontAwesomeIcons.treeCity,
                      title: "Entreprise",
                      onTap: () {
                        context.goNamed(EnterpriseRegistrationPage.name);
                      },
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: MainRegistrationButton(
                      icon: FontAwesomeIcons.userTie,
                      title: "Indépendant",
                      onTap: () {
                        context.goNamed(ParticulierRegistration.name);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
      bottomNavigationBar: const SizedBox(
          height: 100,
          child: Center(
            child: Text(
              '©AfriqueSolus',
              style: TextStyle(color: Color.fromARGB(255, 182, 181, 181)),
            ),
          )),
    );
  }
}
