import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/enums/contact_change_type.dart';
import 'package:immoplus_pro/features/contact_change/view/request_contact_change_page.dart';
import 'package:immoplus_pro/features/profil/update_password_page.dart';

class ChangeCredentialsPage extends StatelessWidget {
  static const String name = 'CHANGE_CREDENTIALS';

  const ChangeCredentialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identifiants de connexion'),
        backgroundColor: AppColors.whiteBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 30),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
      ),
      // backgroundColor: AppColors.scafold,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  children: [
                    ListTile(
                      tileColor: Colors.white,
                      horizontalTitleGap: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      leading: Icon(
                        FontAwesomeIcons.userShield,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      title: const Text('Modifier mon mot de passe'),
                      trailing: Icon(
                        FontAwesomeIcons.circleChevronRight,
                        size: 15,
                        color: AppColors.primary,
                      ),
                      onTap: () => context.pushNamed(UpdatePasswordPage.name),
                    ),
                    const Divider(height: 0, thickness: 0.8),
                    ListTile(
                      tileColor: Colors.white,
                      horizontalTitleGap: 0,
                      leading: Icon(
                        FontAwesomeIcons.phone,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      title: const Text('Changer mon numéro de téléphone'),
                      trailing: Icon(
                        FontAwesomeIcons.circleChevronRight,
                        size: 15,
                        color: AppColors.primary,
                      ),
                      onTap: () => context.pushNamed(
                        RequestContactChangePage.name,
                        extra: ContactChangeType.phone,
                      ),
                    ),
                    const Divider(height: 0, thickness: 0.8),
                    ListTile(
                      tileColor: Colors.white,
                      horizontalTitleGap: 0,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                      ),
                      leading: Icon(
                        FontAwesomeIcons.envelope,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      title: const Text('Changer mon email'),
                      trailing: Icon(
                        FontAwesomeIcons.circleChevronRight,
                        size: 15,
                        color: AppColors.primary,
                      ),
                      onTap: () => context.pushNamed(
                        RequestContactChangePage.name,
                        extra: ContactChangeType.email,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
