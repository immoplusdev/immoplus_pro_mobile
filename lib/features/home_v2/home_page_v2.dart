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
import 'package:immoplus_pro/features/home_v2/pages/booking_page_v2.dart';
import 'package:immoplus_pro/features/home_v2/pages/visit_page_v2.dart';
import 'package:immoplus_pro/features/payments/logic/wallet_cubit.dart';
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
import 'package:immoplus_pro/features/pin_code/views/pin_code_page_v2.dart';
import 'package:immoplus_pro/features/payments/payments_page_v2.dart';
import 'package:immoplus_pro/app_states/request_state.dart';

class HomePageV2 extends StatefulWidget {
  final String? paiementId;
  const HomePageV2({super.key, this.paiementId});
  static String name = 'HOME_PAGE';

  @override
  State<HomePageV2> createState() => _HomePageV2State();
}

class _HomePageV2State extends State<HomePageV2>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final _remoteConfig = getIt<RemoteConfigService>();
  late TabController _tabController;

  UserModelSchema? currentUser;
  bool _isUnlocked = false;

  final ValueNotifier<BookingFilterV2> _bookingFilterNotifier =
      ValueNotifier(BookingFilterV2.all);
  final ValueNotifier<VisitFilterV2> _visitFilterNotifier =
      ValueNotifier(VisitFilterV2.all);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {}); // Rafraîchir pour mettre à jour les filtres affichés
      }
    });
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
    context.pushNamed(
      PinCodePageV2.name,
      extra: () {
        setState(() {
          _isUnlocked = true;
        });
        context.pop();
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _bookingFilterNotifier.dispose();
    _visitFilterNotifier.dispose();
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
              // L'en-tête bleu (fixed au scroll car pinned: true)
              SliverAppBar(
                pinned: true,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0,
                toolbarHeight: 260,
                flexibleSpace: Stack(
                  children: [
                    FlexibleSpaceBar(
                      background: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Fond bleu avec coins arrondis prononcés
                          Container(
                            height: _Constants.blueHeaderHeight,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(
                                    _Constants.radiusExtraLarge),
                                bottomRight: Radius.circular(
                                    _Constants.radiusExtraLarge),
                              ),
                            ),
                          ),

                          // Barre de statut et d'infos utilisateur
                          SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: _Constants.paddingStandard,
                                vertical: _Constants.paddingMedium,
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: _Constants.avatarRadius,
                                    backgroundColor: Colors.white,
                                    backgroundImage:
                                        (currentUser?.avatar != null)
                                            ? CachedNetworkImageProvider(
                                                Utils.getImagePath(
                                                    id: currentUser!.avatar!))
                                            : const NetworkImage(
                                                    _Constants.defaultAvatarUrl)
                                                as ImageProvider,
                                  ),
                                  const Gap(_Constants.gapMedium),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Bonjour, ${currentUser?.firstName ?? 'Yao'} 👋",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text(
                                          "Bienvenue dans votre dashboard",
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Iconsax.notification,
                                      color: Colors.white,
                                      size: _Constants.iconSizeLarge,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Wallet superposé (bien à l'intérieur du Stack pour le clic)
                    Positioned(
                      left: _Constants.paddingStandard,
                      right: _Constants.paddingStandard,
                      bottom: 15,
                      child: _isUnlocked
                          ? _buildUnlockedWalletBanner()
                          : _buildLockedWalletBanner(),
                    ),
                  ],
                ),
              ),

              // Contenu du haut : Wallet + Tableau de bord
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: _Constants.paddingStandard,
                    right: _Constants.paddingStandard,
                    bottom: _Constants.paddingStandard,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tableau de board",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Gap(_Constants.gapLarge),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildDashboardAction(
                            iconWidget: const Icon(FontAwesomeIcons.treeCity,
                                color: _Constants.primaryAccent, size: 24),
                            label: "Bien immobilier",
                            onTap: () => context.pushNamed(EstatesPageV2.name),
                          ),
                          _buildDashboardAction(
                            iconWidget: const Icon(FontAwesomeIcons.couch,
                                color: _Constants.primaryAccent, size: 24),
                            label: "Mes meubles",
                            onTap: () =>
                                context.pushNamed(FurnituresPageV2.name),
                          ),
                          _buildDashboardAction(
                            iconWidget: const ImmoIcon(ImmoIcons.resi,
                                color: _Constants.primaryAccent),
                            label: "Mes résidences",
                            onTap: () =>
                                context.pushNamed(ResidencesPageV2.name),
                          ),
                          _buildDashboardAction(
                            iconWidget: const Icon(Iconsax.play,
                                color: _Constants.primaryAccent, size: 24),
                            label: "Mon feed",
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Onglets et Filtres épinglés (pinned)
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                  Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Custom Tab Design (Button style)
                        Container(
                          height: _Constants.tabHeight,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.shade200, width: 1),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => _tabController.animateTo(0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _tabController.index == 0
                                          ? AppColors.primary
                                          : Colors.white,
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Historique de réservation",
                                      style: TextStyle(
                                        color: _tabController.index == 0
                                            ? Colors.white
                                            : AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () => _tabController.animateTo(1),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _tabController.index == 1
                                          ? AppColors.primary
                                          : Colors.white,
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Historique de visite",
                                      style: TextStyle(
                                        color: _tabController.index == 1
                                            ? Colors.white
                                            : AppColors.primary,
                                        fontWeight: _tabController.index == 1
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Filtres statiques
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(
                              left: 5, right: 5, top: 15, bottom: 5),
                          child: Row(
                            children: _buildCurrentFilters(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              BookingPageV2(filterNotifier: _bookingFilterNotifier),
              VisitPageV2(filterNotifier: _visitFilterNotifier),
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
      child: Column(
        children: [
          Container(
            width: _Constants.actionCircleSize,
            height: _Constants.actionCircleSize,
            decoration: BoxDecoration(
              color: _Constants.primaryAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(child: iconWidget),
          ),
          const Gap(_Constants.gapSmall),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildCurrentFilters() {
    if (_tabController.index == 0) {
      return [
        _buildFilterChip(
            "Tous",
            _bookingFilterNotifier.value == BookingFilterV2.all,
            () => setState(
                () => _bookingFilterNotifier.value = BookingFilterV2.all)),
        _buildFilterChip(
          "Attente pro",
          _bookingFilterNotifier.value == BookingFilterV2.attentePro,
          () => setState(
              () => _bookingFilterNotifier.value = BookingFilterV2.attentePro),
        ),
        _buildFilterChip(
          "Attente paiement",
          _bookingFilterNotifier.value == BookingFilterV2.attentePaiement,
          () => setState(() =>
              _bookingFilterNotifier.value = BookingFilterV2.attentePaiement),
        ),
        _buildFilterChip(
            "Payées",
            _bookingFilterNotifier.value == BookingFilterV2.paid,
            () => setState(
                () => _bookingFilterNotifier.value = BookingFilterV2.paid)),
      ];
    } else {
      return [
        _buildFilterChip(
            "Tous",
            _visitFilterNotifier.value == VisitFilterV2.all,
            () =>
                setState(() => _visitFilterNotifier.value = VisitFilterV2.all)),
        _buildFilterChip(
            "Demande Express",
            _visitFilterNotifier.value == VisitFilterV2.express,
            () => setState(
                () => _visitFilterNotifier.value = VisitFilterV2.express)),
        _buildFilterChip(
            "Demande normal",
            _visitFilterNotifier.value == VisitFilterV2.normal,
            () => setState(
                () => _visitFilterNotifier.value = VisitFilterV2.normal)),
      ];
    }
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          border: Border.all(
              color: isSelected ? AppColors.primary : Colors.blue.shade100),
          borderRadius: BorderRadius.circular(_Constants.radiusLarge),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.primary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLockedWalletBanner() {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _showPaiementDialog,
          child: Container(
            height: _Constants.walletBannerHeight,
            padding: const EdgeInsets.all(_Constants.paddingLarge),
            decoration: _Constants.bannerDecoration,
            child: UnconstrainedBox(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                decoration: BoxDecoration(
                  color: _Constants.primaryAccent,
                  borderRadius:
                      BorderRadius.circular(_Constants.radiusCircular),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline, color: Colors.white, size: 18),
                    Gap(_Constants.gapMedium),
                    Text(
                      "Cliquez ici pour déverrouiller votre coffre",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Gap(15),
      ],
    );
  }

  Widget _buildUnlockedWalletBanner() {
    return BlocBuilder<WalletCubit, RequestState>(
      builder: (context, state) {
        if (state is WALLET) {
          final wallet = state.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: _Constants.walletBannerHeight,
                padding: const EdgeInsets.all(_Constants.paddingStandard),
                decoration: _Constants.bannerDecoration.copyWith(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => context.pushNamed(PaymentsPageV2.name),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 5),
                        decoration: BoxDecoration(
                          color: _Constants.primaryAccent,
                          borderRadius:
                              BorderRadius.circular(_Constants.radiusCircular),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.monetization_on_outlined,
                                color: Colors.white, size: 18),
                            Gap(_Constants.gapSmall),
                            Text(
                              "Retrait",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Gap(_Constants.gapMedium),
                    Row(
                      children: [
                        Expanded(
                          child: _buildBalanceColumnFixed(
                            label: "Solde disponible",
                            amount: wallet.availableBalance.toString(),
                            dotColor: Color(0xff1CA53F),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey.shade200,
                        ),
                        Expanded(
                          child: _buildBalanceColumnFixed(
                            label: "Solde en cours",
                            amount: wallet.pendingBalance.toString(),
                            dotColor: const Color(0xffF59E0B),
                            crossAxisAlignment: CrossAxisAlignment.end,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(5),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Color(0xffFF4CD8),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Gap(_Constants.gapMedium),
                  const Text(
                    "Seul le solde disponible peut etre retiré.",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              const Gap(8),
            ],
          );
        }
        return const Center(child: CupertinoActivityIndicator());
      },
    );
  }

  Widget _buildBalanceColumnFixed({
    required String label,
    required String amount,
    required Color dotColor,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (crossAxisAlignment == CrossAxisAlignment.start) ...[
              Container(
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(color: dotColor, shape: BoxShape.circle),
                // child: Icon(Icons.money),
              ),
              const Gap(_Constants.gapSmall),
            ],
            Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600)),
            if (crossAxisAlignment == CrossAxisAlignment.end) ...[
              const Gap(_Constants.gapSmall),
              Container(
                  width: 8,
                  height: 8,
                  decoration:
                      BoxDecoration(color: dotColor, shape: BoxShape.circle)),
            ],
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              Utils.formatCurrency(double.parse(amount)),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Gap(_Constants.gapSmall),
            const Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text("fcfa",
                  style: TextStyle(fontSize: 14, color: Colors.black54)),
            ),
          ],
        ),
      ],
    );
  }
}

/// Constants internal to the file to avoid magic values
class _Constants {
  // Heights
  static const double blueHeaderHeight = 180.0;
  static const double walletBannerHeight = 130.0;

  static const double stickyHeaderHeight = 105.0;
  static const double tabHeight = 35.0;
  static const double actionCircleSize = 55.0;

  // Padding & Spacing
  static const double paddingStandard = 20.0;
  static const double paddingMedium = 15.0;
  static const double paddingLarge = 25.0;
  static const double gapSmall = 8.0;
  static const double gapMedium = 10.0;
  static const double gapLarge = 25.0;

  // BorderRadius
  static const double radiusExtraLarge = 40.0;
  static const double radiusLarge = 25.0;
  static const double radiusMedium = 20.0;
  static const double radiusCircular = 30.0;

  // Icons & Avatar
  static const double avatarRadius = 32.0;
  static const double iconSizeLarge = 28.0;

  // Colors
  static const Color primaryAccent = Color(0xFF2744DE);

  // Common UI assets
  static const String defaultAvatarUrl =
      "https://static.vecteezy.com/system/resources/previews/005/129/844/non_2x/profile-user-icon-isolated-on-white-background-eps10-free-vector.jpg";

  // Reusable Decorations
  static final BoxDecoration bannerDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radiusMedium),
    border: Border.all(color: AppColors.customBlue.withOpacity(.2)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 15,
        offset: const Offset(0, 10),
      )
    ],
  );
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._child);
  final Widget _child;
  @override
  double get minExtent => _Constants.stickyHeaderHeight;
  @override
  double get maxExtent => _Constants.stickyHeaderHeight;
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: _child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => true;
}
