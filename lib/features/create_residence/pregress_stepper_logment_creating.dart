import 'dart:developer';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/create_residence/screens/amenities_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/description_editor_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/logement_location_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/logment_price_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/pictures_logment_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/rules_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/type_logment_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/video_logment_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/wellcome_page.dart';
import 'package:immoplus_pro/features/create_residence/utils/create_logment_router.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_navigation.dart';

class PregressStepperResidenceCreating extends SliverPersistentHeaderDelegate {
  final List<String> stepTitles = [
    'Nom',
    'Type',
    'Commodités',
    'Localisation',
    'Photos',
    'Vidéo',
    'Règles',
    'Description',
    'Prix',
  ];

  final List<IconData> stepIcons = [
    FontAwesomeIcons.font.data,
    FontAwesomeIcons.building.data,
    Icons.chair,
    FontAwesomeIcons.locationDot.data,
    FontAwesomeIcons.camera.data,
    FontAwesomeIcons.video.data,
    FontAwesomeIcons.fileContract.data,
    FontAwesomeIcons.alignLeft.data,
    FontAwesomeIcons.moneyBills.data,
  ];

  void navigateToStep(int step) {
    if (ResidenceCreationModelBuilder().editing) {
      switch (step) {
        case 0:
          CreationResidenceNavigation.goToPage(pageName: WellcommePage.name);
          break;
        case 1:
          CreationResidenceNavigation.goToPage(pageName: TypeLogmentPage.name);
          break;
        case 2:
          CreationResidenceNavigation.goToPage(pageName: AmentitiesPage.name);
          break;
        case 3:
          CreationResidenceNavigation.goToPage(
              pageName: LogmentLocationPage.name);
          break;
        case 4:
          CreationResidenceNavigation.goToPage(
              pageName: PicturesLogmentPage.name);
          break;
        case 5:
          CreationResidenceNavigation.goToPage(pageName: VideoLogmentPage.name);
          break;
        case 6:
          CreationResidenceNavigation.goToPage(pageName: RulesPage.name);
          break;
        case 7:
          CreationResidenceNavigation.goToPage(
              pageName: DescriptionEditorPage.name);
          break;
        case 8:
          CreationResidenceNavigation.goToPage(pageName: LogmentPricePage.name);
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
      valueListenable: CreationResidenceNavigation.stepperStateNotifier,
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
              if (ResidenceCreationModelBuilder().editing == true) {
                CreationResidenceNavigation.setStepe(step);
                navigateToStep(step);
                CreationResidenceNavigation.goToPageIndex(pageIndex: step);

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
                  CreationResidenceNavigation.setStepe(step);
                  navigateToStep(step);
                  CreationResidenceNavigation.goToPageIndex(pageIndex: step);
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
