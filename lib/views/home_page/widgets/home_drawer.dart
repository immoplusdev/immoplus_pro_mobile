import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit.dart';
import 'package:immoplus_pro/data/schemas/user_model_schema.dart';
import 'package:immoplus_pro/main.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:immoplus_pro/views/account/widgets/edit_account.dart';
import 'package:immoplus_pro/views/estates/estates_page.dart';
import 'package:immoplus_pro/views/home_page/pages/general_condition_page.dart';
import 'package:immoplus_pro/views/login_page/login_page.dart';
import 'package:immoplus_pro/views/residence/residences_page.dart';
import 'package:shimmer/shimmer.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.scafold,
      child: Column(
        children: [
          DrawerHeader(
            // decoration: BoxDecoration(
            //   color: Colors.blue,
            // ),
            child: Column(
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://www.strasys.uk/wp-content/uploads/2022/02/Depositphotos_484354208_S.jpg",

                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade400,
                        period: const Duration(milliseconds: 500),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit
                          .cover, // or other BoxFit values as per your design
                    ),
                  ),
                ),
                const Gap(5),
                AutoSizeText(
                  '${SessionManager().currentUser?.firstName} ${SessionManager().currentUser?.lastName}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                //Text('test@gmail.com'),
                AutoSizeText("+${SessionManager().currentUser?.phoneNumber}"),
                AutoSizeText(
                  SessionManager().currentUser?.email ?? "",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Divider(
            height: 0,
            thickness: 1,
          ),
          ListTile(
            onTap: () {
              context.pushNamed(ResidencesPage.name);
            },
            horizontalTitleGap: 0,
            leading: Icon(
              FontAwesomeIcons.key,
              color: AppColors.primary,
              size: 20,
            ),
            title: const Text('Mes résidences'),
          ),
          const Divider(
            height: 0,
            thickness: 1,
          ),
          ListTile(
            onTap: () {
              context.pushNamed(EstatesPage.name);
            },
            horizontalTitleGap: 0,
            leading: Icon(
              FontAwesomeIcons.buildingUser,
              color: AppColors.primary,
              size: 20,
            ),
            title: const Text('Biens immobilier'),
          ),
          const Divider(
            height: 0,
            thickness: 1,
          ),
          ListTile(
            onTap: () {
              context.pushNamed(EditAccount.name);
            },
            horizontalTitleGap: 0,
            leading: Icon(
              FontAwesomeIcons.userPen,
              color: AppColors.primary,
              size: 20,
            ),
            title: const Text('Modifier mes informations'),
          ),
          const Divider(
            height: 0,
            thickness: 1,
          ),
          ListTile(
            horizontalTitleGap: 0,
            leading: Icon(
              FontAwesomeIcons.userShield,
              color: AppColors.primary,
              size: 20,
            ),
            title: const Text('Modifier mot de passe'),
          ),
          const Divider(
            height: 0,
            thickness: 1,
          ),
          const ListTile(
            horizontalTitleGap: 0,
            leading: Icon(
              FontAwesomeIcons.coins,
              color: Colors.orangeAccent,
              size: 20,
            ),
            title: Text('Paiements'),
          ),
          const Divider(
            height: 0,
            thickness: 1,
          ),
          const Divider(
            height: 0,
            thickness: 1,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const GeneralConditionPage(),
              ));
            },
            horizontalTitleGap: 0,
            leading: Icon(
              FontAwesomeIcons.fileContract,
              color: AppColors.primary,
              size: 20,
            ),
            title: const Text("Condition général d'utilisation"),
          ),
          const Divider(
            height: 0,
            thickness: 1,
          ),
          const Expanded(child: SizedBox()),
          ListTile(
            horizontalTitleGap: 0,
            leading: const Icon(
              FontAwesomeIcons.arrowRightFromBracket,
              color: Colors.redAccent,
              size: 20,
            ),
            title: const Text(
              "Se déconnecter",
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
            onTap: () {
              showCupertinoDialog(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: const Text('Déconnexion'),
                    content: const Text(
                        'Êtes-vous sûr de vouloir vous déconnecter ?'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        isDefaultAction: true,
                        onPressed: () {
                          Navigator.of(context)
                              .pop(); // Ferme la pop-up sans se déconnecter
                        },
                        child: const Text('Annuler'),
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        onPressed: () {
                          isarInstance.writeTxnSync(
                            () {
                              final result =
                                  isarInstance.userModelSchemas.deleteSync(1);
                              if (result) {
                                context.goNamed(LoginPage.name);
                              } else {
                                context.pop();
                              }
                            },
                          );
                        },
                        child: const Text('Déconnexion'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const Gap(50),
        ],
      ),
    );
  }
}
