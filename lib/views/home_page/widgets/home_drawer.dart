import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/views/account/widgets/edit_account.dart';
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
                          "https://pbs.twimg.com/profile_banners/1444928438331224069/1633448972/600x200", //https://pbs.twimg.com/profile_banners/1444928438331224069/1633448972/600x200

                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade400,
                        period: Duration(milliseconds: 500),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit
                          .cover, // or other BoxFit values as per your design
                    ),
                  ),
                ),
                Gap(5),
                Text(
                  '${SessionManager().currentUser?.firstName} ${SessionManager().currentUser?.lastName}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                //Text('test@gmail.com'),
                Text("+${SessionManager().currentUser?.phoneNumber}"),
                Text(
                  SessionManager().currentUser?.email ?? "",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              context.pushNamed(residencesPage.name);
            },
            horizontalTitleGap: 0,
            tileColor: Colors.white,
            leading: const Icon(FontAwesomeIcons.buildingUser),
            title: Text('Mes logements'),
          ),
          Gap(5),
          ListTile(
            onTap: () {
              context.pushNamed(EditAccount.name);
            },
            horizontalTitleGap: 0,
            tileColor: Colors.white,
            leading: const Icon(FontAwesomeIcons.user),
            title: const Text('Modifier mes informations'),
          ),
          const Gap(5),
          const ListTile(
            horizontalTitleGap: 0,
            tileColor: Colors.white,
            leading: Icon(FontAwesomeIcons.moneyBill1Wave),
            title: Text('Paiements'),
          ),
          Gap(5),
          ListTile(
            horizontalTitleGap: 0,
            tileColor: Colors.white,
            leading: Icon(FontAwesomeIcons.lockOpen),
            title: Text('Modifier mot de passe'),
          ),
          Gap(5),
          ListTile(
            horizontalTitleGap: 0,
            tileColor: Colors.white,
            leading: Icon(FontAwesomeIcons.fileContract),
            title: Text("Condition général d'utilisation"),
          ),
          Gap(20),
          ListTile(
            horizontalTitleGap: 0,
            tileColor: Colors.white,
            leading: Icon(FontAwesomeIcons.arrowRightFromBracket),
            title: Text("Se déconnecter"),
            onTap: () {
              context.goNamed(LoginPage.name);
            },
          ),
        ],
      ),
    );
  }
}
