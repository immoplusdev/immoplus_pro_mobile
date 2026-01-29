import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/core/network/utils/constants.dart';
import 'package:immoplus_pro/features/home_page/pages/booking_page.dart';
import 'package:immoplus_pro/features/home_page/pages/visit_page.dart';
import 'package:immoplus_pro/features/home_page/utils/home_router.dart';
import 'package:immoplus_pro/features/home_page/widgets/home_drawer.dart';
import 'package:immoplus_pro/features/payments/logic/wallet_cubit.dart';
import 'package:immoplus_pro/features/payments/payments_page.dart';
import 'package:immoplus_pro/features/pin_code/views/pin_code_page.dart';
import 'package:immoplus_pro/services/notification_service.dart';
import 'package:immoplus_pro/services/remote_config_service.dart';
import 'package:immoplus_pro/services/version_update_service.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/widgets/config_env.dart';

class HomePage extends StatefulWidget {
  final String? paiementId;
  const HomePage({super.key, this.paiementId});
  static String name = 'HOME_PAGE';
  static String routePath() => '/home';

  static String route() => '/home';

  static ValueNotifier<BookingSection> selectedSection =
      ValueNotifier<BookingSection>(BookingSection.in_progress);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  final _remoteConfig = getIt<RemoteConfigService>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HomeRouter.setup();
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

  void _navigateToSection(BookingSection section) {
    if (section == BookingSection.in_progress) {
      HomeRouter.router.goNamed(BookingPage.name);
    } else if (section == BookingSection.visit) {
      HomeRouter.router.goNamed(VisitPage.name);
    }
  }

  _showPaiementDialog() {
    showModalBottomSheet(
        isDismissible: false,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        context: context,
        builder: (context) => FractionallySizedBox(
              heightFactor: 0.93,
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
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
                  PaymentsPage(),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return EnvironmentsBadge(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.whiteBackground,
          centerTitle: true,
          title: ValueListenableBuilder(
              valueListenable: HomePage.selectedSection,
              builder: (context, state, child) {
                final isIOS = Platform.isIOS;
                return isIOS
                    ? CupertinoSlidingSegmentedControl<BookingSection>(
                        backgroundColor: CupertinoColors.systemFill,
                        thumbColor: Colors.white,
                        groupValue: HomePage.selectedSection.value,
                        children: {
                          BookingSection.in_progress: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: FittedBox(
                              child: Text(
                                'Réservations',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                          BookingSection.visit: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: FittedBox(
                              child: Text(
                                'Visites',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                        },
                        onValueChanged: (bookingSection) {
                          if (bookingSection != null) {
                            HomePage.selectedSection.value = bookingSection;
                            _navigateToSection(bookingSection);
                          }
                        },
                      )
                    : SegmentedButton<BookingSection>(
                        segments: const <ButtonSegment<BookingSection>>[
                          ButtonSegment(
                            value: BookingSection.in_progress,
                            label: Text('Réservations'),
                          ),
                          ButtonSegment(
                            value: BookingSection.visit,
                            label: Text('Visites'),
                          ),
                        ],
                        selected: {HomePage.selectedSection.value},
                        showSelectedIcon: false,
                        style: SegmentedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.grey.shade700,
                          selectedForegroundColor: Colors.white,
                          selectedBackgroundColor: AppColors.primary,
                        ),
                        onSelectionChanged: (newSelection) {
                          final selected = newSelection.first;
                          HomePage.selectedSection.value = selected;
                          _navigateToSection(selected);
                        },
                      );
              }),
          titleTextStyle: Theme.of(context).textTheme.titleLarge,
          actions: [
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     shape: BoxShape.circle,
            //     border: Border.all(),
            //     // boxShadow: [
            //     //   BoxShadow(
            //     //       blurRadius: 5,
            //     //       color: Colors.grey.shade400,
            //     //       spreadRadius: 1)
            //     // ],
            //   ),
            //   child: InkWell(
            //     onTap: () {
            //       //context.go('/home/notifs');
            //     },
            //     child: CircleAvatar(
            //       backgroundColor: Colors.white,
            //       child: Badge(
            //         isLabelVisible: true,
            //         label: const Text(
            //           '+9',
            //           style: TextStyle(
            //             color: Colors.white,
            //             fontSize: 10,
            //           ),
            //         ),
            //         child: Container(
            //           padding: const EdgeInsets.all(8),
            //           child: Icon(
            //             CupertinoIcons.bell,
            //             color: AppColors.primary,
            //             size: 20,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // const Gap(13),

            BlocBuilder<WalletCubit, RequestState>(
              builder: (context, state) {
                return InputChip(
                  onPressed:
                      state is REQUEST_LOADING ? null : _showPaiementDialog,
                  avatar: Icon(
                    FontAwesomeIcons.coins,
                    color: Colors.white,
                    size: 13,
                  ),
                  labelPadding: EdgeInsets.symmetric(horizontal: 2),
                  backgroundColor: AppColors.primary,
                  labelStyle: context.textTheme.labelLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  label: (state is WALLET)
                      ? Text(
                          formatCfa(state.data.availableBalance),
                        )
                      : CupertinoActivityIndicator(
                          color: Colors.white,
                        ),
                );
              },
            ),
            Gap(8),
          ],
        ),
        drawer: const HomeDrawer(),
        body: Router(
          routerDelegate: HomeRouter.router.routerDelegate,
          routeInformationParser: HomeRouter.router.routeInformationParser,
          routeInformationProvider: HomeRouter.router.routeInformationProvider,
        ),
      ),
    );
  }
}
