// Widget pour le contenu de l'inscription
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:immoplus_pro/features/registration/widgets/main_registration_button.dart';
import 'package:immoplus_pro/features/shared_widgets/bottom_immoplus.dart';

class RegistrationContent extends StatelessWidget {
  final VoidCallback? entrepriseOnTap;
  final VoidCallback? particulierOnTap;
  const RegistrationContent(
      {super.key, this.entrepriseOnTap, this.particulierOnTap});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(40),
        // Logo
        Center(
          child: SvgPicture.asset(
            'assets/icons/logo_immo.svg',
            color: HexColor('#2072ca'),
            width: 80,
          ),
        ),
        const Gap(20),
        // Titre inscription
        AutoSizeText(
          "Inscription professionnel ImmoPlus",
          textAlign: TextAlign.center,
          maxLines: 2,
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const Gap(10),

        // Sous-titre
        Text(
          "Choisissez votre type de compte",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const Gap(60),

        // Boutons Entreprise et Indépendant
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 1,
              child: MainRegistrationButton(
                icon: FontAwesomeIcons.treeCity,
                title: "Entreprise",
                onTap: entrepriseOnTap,
              ),
            ),
            const Gap(15),
            Flexible(
              flex: 1,
              child: MainRegistrationButton(
                icon: FontAwesomeIcons.userTie,
                title: "Indépendant",
                onTap: particulierOnTap,
              ),
            ),
          ],
        ),

        const Gap(40),
        // Copyright
        BottomImmoPlus(),
        const Gap(20),
      ],
    );
  }
}
