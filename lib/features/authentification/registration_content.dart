// Widget pour le contenu de l'inscription
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/core/network/utils/constants.dart';
import 'package:immoplus_pro/features/registration/widgets/main_registration_button.dart';
import 'package:immoplus_pro/gen/assets.gen.dart';

class RegistrationContent extends StatelessWidget {
  final VoidCallback? entrepriseOnTap;
  final VoidCallback? particulierOnTap;
  const RegistrationContent(
      {super.key, this.entrepriseOnTap, this.particulierOnTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(appPadding),
      child: Column(
        children: [
          const Gap(40),

          // Titre inscription
          AutoSizeText(
            "Créez votre compte professionnel Immo Plus",
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              fontSize: 20,
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
                  assetPath: Assets.img.immeubleDeBureaux.path,
                  title: "Entreprise",
                  onTap: entrepriseOnTap,
                ),
              ),
              const Gap(5),
              Flexible(
                flex: 1,
                child: MainRegistrationButton(
                  assetPath: Assets.img.utilisateur.path,
                  title: "Indépendant",
                  onTap: particulierOnTap,
                ),
              ),
            ],
          ),

          const Gap(40),
        ],
      ),
    );
  }
}
