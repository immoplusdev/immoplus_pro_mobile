import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:immoplus_pro/app_states/request_state.dart';
import 'package:immoplus_pro/common/enums.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/network/utils/constants.dart';
import 'package:immoplus_pro/features/home_page/pages/booking_page.dart';
import 'package:immoplus_pro/features/home_page/pages/visit_page.dart';
import 'package:immoplus_pro/features/home_page/utils/home_router.dart';
import 'package:immoplus_pro/features/home_page/widgets/home_drawer.dart';
import 'package:immoplus_pro/features/payments/logic/wallet_cubit.dart';
import 'package:immoplus_pro/features/payments/payments_page.dart';
import 'package:immoplus_pro/utils/session_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static String name = 'HOME_PAGE';
  static ValueNotifier<BookingSection> selectedSection =
      ValueNotifier<BookingSection>(BookingSection.in_progress);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HomeRouter.setup();
    context.read<WalletCubit>().onGetWallet();
  }

  void _navigateToSection(BookingSection section) {
    if (section == BookingSection.in_progress) {
      HomeRouter.router.goNamed(BookingPage.name);
    } else if (section == BookingSection.visit) {
      HomeRouter.router.goNamed(VisitPage.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteBackground,
        centerTitle: (SessionManager().currentUser!.roleName ==
                Roles.pro_entreprise.name)
            ? true
            : false,
        title: (SessionManager().currentUser!.roleName ==
                Roles.pro_entreprise.name)
            ? ValueListenableBuilder(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'Réservations',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            BookingSection.visit: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'Visites',
                                style: Theme.of(context).textTheme.titleMedium,
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
                })
            : const AutoSizeText('Réservations'),
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
                onPressed: state is REQUEST_LOADING
                    ? null
                    : () {
                        showModalBottomSheet(
                            isDismissible: false,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            context: context,
                            builder: (context) => FractionallySizedBox(
                                  heightFactor: 0.93,
                                  child: PaymentsPage(),
                                ));
                      },
                avatar: Icon(
                  FontAwesomeIcons.moneyBills,
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
    );
  }
}
