import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/constantes/immo_icons.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/features/home_page/pages/booking_page.dart';
import 'package:immoplus_pro/features/home_page/pages/visit_page.dart';
import 'package:immoplus_pro/features/payments/logic/wallet_cubit.dart';
import 'package:immoplus_pro/features/payments/payments_page.dart';
import 'package:immoplus_pro/features/pin_code/views/pin_code_page.dart';
import 'package:immoplus_pro/features/my_feed/presentation/pages/my_feed_page.dart';
import 'package:immoplus_pro/features/notification/notification_page.dart';
import 'package:immoplus_pro/services/notification_service.dart';
import 'package:immoplus_pro/services/remote_config_service.dart';
import 'package:immoplus_pro/services/version_update_service.dart';
import 'package:immoplus_pro/widgets/config_env.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:immoplus_pro/data/schemas/user_model_schema.dart';
import 'package:immoplus_pro/features/estates/estates_page_v2.dart';
import 'package:immoplus_pro/features/furnitures/furnitures_page_v2.dart';
import 'package:immoplus_pro/features/residence/residences_page_v2.dart';

class HomePageV2 extends StatefulWidget {
  final String? paiementId;
  const HomePageV2({super.key, this.paiementId});
  static String name = 'HOME_PAGE_V2';

  @override
  State<HomePageV2> createState() => _HomePageV2State();
}

class _HomePageV2State extends State<HomePageV2>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final _remoteConfig = getIt<RemoteConfigService>();
  late TabController _tabController;

  UserModelSchema? currentUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    currentUser = SessionManager().currentUser;

    context.read<WalletCubit>().onGetWallet();
    final notificationService = getIt<NotificationService>();
    notificationService.setupNotificationListener();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.paiementId != null) {
        _showPaiementDialog();
      }
      await UpdateService()
          .checkForUpdate(context, forceUpdate: _remoteConfig.forceUpgradeApp);
    });
  }

  void _showPaiementDialog() {
    showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        context: context,
        builder: (context) => FractionallySizedBox(
              heightFactor: 0.93,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: PinCodePage(
                      onSuccess: () {
                        _pageController.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      },
                    ),
                  ),
                  const PaymentsPage(),
                ],
              ),
            ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EnvironmentsBadge(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // L'en-tête bleu épinglé (fixed)
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.primary,
                elevation: 0,
                toolbarHeight: 165,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                flexibleSpace: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.white,
                              backgroundImage: (currentUser?.avatar != null)
                                  ? CachedNetworkImageProvider(
                                      Utils.getImagePath(
                                          id: currentUser!.avatar!))
                                  : const NetworkImage(
                                          "https://static.vecteezy.com/system/resources/previews/005/129/844/non_2x/profile-user-icon-isolated-on-white-background-eps10-free-vector.jpg")
                                      as ImageProvider,
                            ),
                            const Gap(15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Bonjour, ${currentUser?.firstName ?? 'Yao'} 👋",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    "Bienvenue dans votre dashboard",
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => context.push(NotificationPage.routePath()),
                              icon: const Icon(Iconsax.notification,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        const Gap(15),
                        // Bannière Wallet
                        InkWell(
                          onTap: _showPaiementDialog,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  )
                                ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.lock_person,
                                          color: Colors.white, size: 16),
                                      const Gap(8),
                                      const Text(
                                        "Cliquez ici pour déverrouiller votre coffre",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),

              // Le tableau de bord dans un SliverToBoxAdapter pour qu'il scrolle (disparait vers le haut sous le header bleu)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tableau de board",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Gap(15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDashboardAction(
                            iconWidget: Icon(FontAwesomeIcons.treeCity,
                                color: AppColors.primary, size: 22),
                            label: "Bien immobilier",
                            onTap: () => context.pushNamed(EstatesPageV2.name),
                          ),
                          _buildDashboardAction(
                            iconWidget: Icon(FontAwesomeIcons.couch,
                                color: AppColors.primary, size: 22),
                            label: "Mes meubles",
                            onTap: () => context.pushNamed(FurnituresPageV2.name),
                          ),
                          _buildDashboardAction(
                            iconWidget: ImmoIcon(ImmoIcons.resi,
                                color: AppColors.primary),
                            label: "Mes résidences",
                            onTap: () => context.pushNamed(ResidencesPageV2.name),
                          ),
                          // _buildDashboardAction(
                          //   iconWidget: Icon(Iconsax.play,
                          //       color: AppColors.primary, size: 22),
                          //   label: "Mon feed",
                          //   onTap: () => context.push(MyFeedPage.routePath()),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Delegate pour le TabBar et les Filtres statiques afin qu'ils "collent" (pinned)
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // TabBar avec un design respectant fidèlement l'UI demandée
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: TabBar(
                            controller: _tabController,
                            labelColor: Colors.white,
                            unselectedLabelColor: AppColors.primary,
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelPadding: EdgeInsets.zero,
                            padding: EdgeInsets.zero,
                            indicatorPadding: EdgeInsets.zero,
                            indicator: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            labelStyle: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14),
                            unselectedLabelStyle: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14),
                            tabs: const [
                              Tab(text: "Historique de visite"),
                              Tab(text: "Historique de réservation"),
                            ],
                          ),
                        ),
                        // Filtres statiques (visuels uniquement)
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          child: Row(
                            children: [
                              _buildFilterChip("Tous", true),
                              _buildFilterChip("En attente", false),
                              _buildFilterChip("Entrée", false),
                              _buildFilterChip("Échoué", false),
                              _buildFilterChip("Payé", false),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: const [
              VisitPage(),
              BookingPage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardAction(
      {required Widget iconWidget,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: iconWidget,
              ),
            ),
            const Gap(8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.primary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._child);

  final Widget _child;

  @override
  double get minExtent => 116;

  @override
  double get maxExtent => 116;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: _child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return true;
  }
}
