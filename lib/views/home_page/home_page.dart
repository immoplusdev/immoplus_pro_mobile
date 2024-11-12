import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/views/home_page/pages/booking_page.dart';
import 'package:immoplus_pro/views/home_page/pages/visit_page.dart';
import 'package:immoplus_pro/views/home_page/utils/home_router.dart';
import 'package:immoplus_pro/views/home_page/widgets/home_drawer.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.scafold,
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(),
              // boxShadow: [
              //   BoxShadow(
              //       blurRadius: 5,
              //       color: Colors.grey.shade400,
              //       spreadRadius: 1)
              // ],
            ),
            child: InkWell(
              onTap: () {
                //context.go('/home/notifs');
              },
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Badge(
                  isLabelVisible: true,
                  label: const Text(
                    '+9',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      CupertinoIcons.bell,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Gap(13),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: ValueListenableBuilder(
              valueListenable: HomePage.selectedSection,
              builder: (context, state, child) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8)
                      .copyWith(bottom: 8),
                  color: AppColors.scafold,
                  //height: 50,
                  child: SegmentedButton<BookingSection>(
                    showSelectedIcon: false,
                    style: SegmentedButton.styleFrom(
                      backgroundColor: Colors.white,
                      // foregroundColor: Colors.red,
                      // selectedForegroundColor: Colors.white,
                      selectedBackgroundColor: AppColors.primary,

                      selectedForegroundColor: Colors.white,
                    ),
                    segments: [
                      ButtonSegment<BookingSection>(
                        value: BookingSection.in_progress,
                        label: const Text('Réservations'),
                        icon: Icon(
                          FontAwesomeIcons.key,
                          color: (HomePage.selectedSection.value ==
                                  BookingSection.in_progress)
                              ? Colors.white
                              : null,
                        ),
                      ),
                      ButtonSegment<BookingSection>(
                        value: BookingSection.visit,
                        label: const Text('Visites'),
                        icon: Icon(
                          FontAwesomeIcons.personWalkingLuggage,
                          color: (HomePage.selectedSection.value ==
                                  BookingSection.visit)
                              ? Colors.white
                              : null,
                        ),
                      ),
                      // ButtonSegment<BookingSection>(
                      //   value: BookingSection.withdrew,
                      //   label: Text('Gains'),
                      //   icon: Icon(
                      //     FontAwesomeIcons.coins,
                      //     color: (HomePage.selectedSection.value ==
                      //             BookingSection.withdrew)
                      //         ? AppColors.primary
                      //         : null,
                      //   ),
                      // ),
                    ],
                    selected: <BookingSection>{HomePage.selectedSection.value},
                    onSelectionChanged: (p0) {
                      Vibrate.feedback(FeedbackType.impact);
                      HomePage.selectedSection.value = p0.first;
                      if (HomePage.selectedSection.value ==
                          BookingSection.in_progress) {
                        HomeRouter.router.goNamed(BookingPage.name);
                      } else if (HomePage.selectedSection.value ==
                          BookingSection.visit) {
                        HomeRouter.router.goNamed(VisitPage.name);
                      }
                      // else {
                      //   HomeRouter.router.goNamed(EarningPage.name);
                      // }
                    },
                  ),
                );
              }),
        ),
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
