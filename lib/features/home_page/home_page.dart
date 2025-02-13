import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/common/enums.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/home_page/pages/booking_page.dart';
import 'package:immoplus_pro/features/home_page/pages/visit_page.dart';
import 'package:immoplus_pro/features/home_page/utils/home_router.dart';
import 'package:immoplus_pro/features/home_page/widgets/home_drawer.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteBackground,
        centerTitle: true,
        title: (SessionManager().currentUser!.roleName ==
                Roles.pro_entreprise.name)
            ? ValueListenableBuilder(
                valueListenable: HomePage.selectedSection,
                builder: (context, state, child) {
                  return CupertinoSlidingSegmentedControl<BookingSection>(
                    backgroundColor: CupertinoColors.systemFill,
                    thumbColor:
                        CupertinoColors.white, //skyColors[_selectedSegment]!,

                    // This represents the currently selected segmented control.
                    groupValue: state,
                    // Callback that sets the selected segmented control.
                    // showSelectedIcon: false,
                    // style: SegmentedButton.styleFrom(
                    //   backgroundColor: Colors.white,
                    //   // foregroundColor: Colors.red,
                    //   // selectedForegroundColor: Colors.white,
                    //   selectedBackgroundColor: AppColors.primary,

                    //   selectedForegroundColor: Colors.white,
                    // ),
                    children: <BookingSection, Widget>{
                      BookingSection.in_progress: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // if ((controller.selectedSegment.value !=
                            //         ColisActiveListType.COLLECTION) &&
                            //     (controller.totalColisForCollection.value != 0))
                            //   Container(
                            //     padding:
                            //         const EdgeInsets.symmetric(horizontal: 8)
                            //             .copyWith(top: 2),
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(60),
                            //         color: AppColors.primary),
                            //     child: Text(
                            //       (controller.totalColisForCollection >= 9)
                            //           ? '+9'
                            //           : controller.totalColisForCollection
                            //               .toString(),
                            //       style: Theme.of(context).textTheme.bodySmall,
                            //     ),
                            //   ),
                            Text(
                              'Réservations',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      BookingSection.visit: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Visites',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            // if ((controller.selectedSegment.value !=
                            //         ColisActiveListType.DELIVERY) &&
                            //     (controller.totalColisForDelivery.value != 0))
                            //   Container(
                            //     padding:
                            //         const EdgeInsets.symmetric(horizontal: 8)
                            //             .copyWith(top: 2),
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(60),
                            //         color: kColorPrimary),
                            //     child: Text(
                            //       (controller.totalColisForDelivery.value >= 9)
                            //           ? '+9'
                            //           : controller.totalColisForDelivery
                            //               .toString(),
                            //       style: Theme.of(context).textTheme.bodySmall,
                            //     ),
                            //   ),
                          ],
                        ),
                      )
                    },

                    // ch: [
                    //   ButtonSegment<BookingSection>(
                    //     value: BookingSection.in_progress,
                    //     label: const Text('Réservations'),
                    //     icon: Icon(
                    //       FontAwesomeIcons.key,
                    //       color: (HomePage.selectedSection.value ==
                    //               BookingSection.in_progress)
                    //           ? Colors.white
                    //           : null,
                    //     ),
                    //   ),
                    //   ButtonSegment<BookingSection>(
                    //     value: BookingSection.visit,
                    //     label: const Text('Visites'),
                    //     icon: Icon(
                    //       FontAwesomeIcons.personWalkingLuggage,
                    //       color: (HomePage.selectedSection.value ==
                    //               BookingSection.visit)
                    //           ? Colors.white
                    //           : null,
                    //     ),
                    //   ),
                    // ],

                    //selected: <BookingSection>{HomePage.selectedSection.value},
                    onValueChanged: (bookingSection) {
                      // Vibrate.feedback(FeedbackType.impact);
                      HomePage.selectedSection.value = bookingSection!;
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
                  );
                })
            : const AutoSizeText('Réservations en cours'),
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
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
