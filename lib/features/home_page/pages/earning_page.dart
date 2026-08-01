import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:immoplus_pro/features/home_page/widgets/earning_card.dart';

class EarningPage extends StatefulWidget {
  const EarningPage({super.key});
  static String name = 'EARNING_PAGE';
  @override
  State<EarningPage> createState() => _EarningPageState();
}

class _EarningPageState extends State<EarningPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scafold,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // SliverPersistentHeader(
            //   delegate:
            //       MyPersistentHeaderDelegate(), // Utilisez votre propre délégué
            //   pinned:
            //       true, // Pour que l'en-tête reste épinglé en haut lors du défilement
            // ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              sliver: SliverToBoxAdapter(
                child: ListTile(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  tileColor: Colors.white,
                  title: const Text('Montant total des gains'),
                  subtitle: Text(
                    Utils.formatCurrency(500000),
                  ),
                  subtitleTextStyle: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .copyWith(color: Colors.green.shade500),
                  titleTextStyle: Theme.of(context).textTheme.bodyMedium,
                  trailing: IconButton(
                    icon: const FaIcon(FontAwesomeIcons.eye,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
            const SliverGap(2),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              sliver: SliverToBoxAdapter(
                child: ListTile(
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  tileColor: Colors.white,
                  subtitle: Text(
                    Utils.formatCurrency(300000),
                  ),
                  title: const Text('Total des gains retirable'),
                  subtitleTextStyle: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.green.shade500),
                  titleTextStyle: Theme.of(context).textTheme.bodySmall,
                  trailing: IconButton(
                    icon: const FaIcon(FontAwesomeIcons.eye,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              sliver: SliverToBoxAdapter(
                child: ListTile(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  visualDensity:
                      const VisualDensity(horizontal: 0, vertical: -4),
                  // leading: CircleAvatar(child: Icon(Icons.lock_clock)),
                  tileColor: Colors.white,
                  horizontalTitleGap: 5,
                  title: const Text('Total gains pas encore retirable'),
                  subtitle: Text(
                    Utils.formatCurrency(200000),
                  ),

                  subtitleTextStyle: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.red.shade200),
                  titleTextStyle: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.red.shade200),
                  trailing: IconButton(
                    icon: const FaIcon(FontAwesomeIcons.eyeSlash,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
            const SliverGap(10),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                  (context, index) => EarningCard(
                        available: index % 2 == 0,
                      ),
                  childCount: 6),
            ),
          ],
        ),
      ),
    );
  }
}
