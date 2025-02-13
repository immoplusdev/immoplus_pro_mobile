import 'dart:developer';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/create_residence/screens/description_editor_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/logment_price_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_amenities_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_logement_location_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_pictures_logment_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_type_logment_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_video_logment_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_wellcome_page.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_manager.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_navigation.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class PregressStepperEstateCreating extends SliverPersistentHeaderDelegate {
  final List<String> stepTitles = [
    'Nom',
    'Type',
    'Commodités',
    'Localisation',
    'Photos',
    'Vidéo',
    'Description',
    'Prix',
  ];

  final List<IconData> stepIcons = [
    FontAwesomeIcons.font,
    FontAwesomeIcons.building,
    Icons.chair,
    FontAwesomeIcons.locationDot,
    FontAwesomeIcons.camera,
    FontAwesomeIcons.video,
    FontAwesomeIcons.alignLeft,
    FontAwesomeIcons.moneyBills,
  ];

  void navigateToStep(int step) {
    if (EstateCreationModelBuilder().editing) {
      switch (step) {
        case 0:
          CreationEstateNavigation.goToPage(pageName: EstateWellcommePage.name);
          break;
        case 1:
          CreationEstateNavigation.goToPage(pageName: EstateTypePage.name);
          break;
        case 2:
          CreationEstateNavigation.goToPage(
              pageName: EstateAmentitiesPage.name);
          break;
        case 3:
          CreationEstateNavigation.goToPage(
              pageName: EstateLogmentLocationPage.name);
          break;
        case 4:
          CreationEstateNavigation.goToPage(
              pageName: EstatePicturesLogmentPage.name);
          break;
        case 5:
          CreationEstateNavigation.goToPage(
              pageName: EstateVideoLogmentPage.name);
          break;

        case 6:
          CreationEstateNavigation.goToPage(
              pageName: DescriptionEditorPage.name);
          break;
        case 7:
          CreationEstateNavigation.goToPage(pageName: LogmentPricePage.name);
          break;
        default:
          break;
      }
    }
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ValueListenableBuilder<int>(
      valueListenable: CreationEstateNavigation.stepperStateNotifier,
      builder: (context, currentStep, _) {
        return Container(
          color: Colors.white,
          height: 70,
          //padding: const EdgeInsets.symmetric(vertical: 5),
          child: EasyStepper(
            activeStep: currentStep,
            lineStyle: LineStyle(
              lineWidth: 20,
              lineLength: 45,
              lineType: LineType.dotted,
              defaultLineColor: Colors.grey,
              finishedLineColor: AppColors.primary,
            ),
            stepRadius: 20,
            activeStepBackgroundColor: AppColors.primary,
            finishedStepBackgroundColor: Colors.blue.shade300,
            unreachedStepBackgroundColor: Colors.grey.shade300,
            showLoadingAnimation: false,
            steps: List.generate(stepTitles.length, (index) {
              return EasyStep(
                customStep: Center(
                  child: Icon(
                    stepIcons[index],
                    size: 15,
                    color:
                        index == currentStep ? Colors.white : AppColors.primary,
                  ),
                ),

                customTitle: Text(
                  stepTitles[index],
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontSize: 9),
                ),

                // Text(
                //   stepTitles[index],
                //   style: TextStyle(
                //     color: index == currentStep ? AppColors.primary : Colors.grey,
                //   ),
                // ),
              );
            }),
            onStepReached: (step) {
              log(step.toString());
              if (EstateCreationModelBuilder().editing == true) {
                CreationEstateNavigation.setStepe(step);
                navigateToStep(step);
                CreationEstateNavigation.goToPageIndex(pageIndex: step);

                // if ((p0 + 1) == 1) {
                //   CreateLogmentRouter.router.goNamed(WellcommePage.name);
                // } else if ((p0 + 1) == 2) {
                //   CreateLogmentRouter.router.goNamed(TypeLogmentPage.name);
                // } else if ((p0 + 1) == 3) {
                //   CreateLogmentRouter.router.goNamed(AmentitiesPage.name);
                // } else if ((p0 + 1) == 4) {
                //   CreateLogmentRouter.router
                //       .goNamed(LogmentLocationPage.name);
                // } else if ((p0 + 1) == 5) {
                //   CreateLogmentRouter.router
                //       .goNamed(PicturesLogmentPage.name);
                // } else if ((p0 + 1) == 6) {
                //   CreateLogmentRouter.router.goNamed(VideoLogmentPage.name);
                // } else if ((p0 + 1) == 7) {
                //   CreateLogmentRouter.router.goNamed(RulesPage.name);
                // } else if ((p0 + 1) == 8) {
                //   CreateLogmentRouter.router
                //       .goNamed(DescriptionEditorPage.name);
                // } else if ((p0 + 1) == 9) {
                //   CreateLogmentRouter.router.goNamed(LogmentPricePage.name);
                // }
              } else {
                if (step < currentStep) {
                  CreationEstateNavigation.setStepe(step);
                  navigateToStep(step);
                  CreationEstateNavigation.goToPageIndex(pageIndex: step);
                }
              }
            },
          ),
        );
      },
    );
  }

  @override
  double get maxExtent => 70;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
