import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/modules/logment_creation/components/amenities_page.dart';
import 'package:immoplus_pro/modules/logment_creation/components/description_editor_page.dart';
import 'package:immoplus_pro/modules/logment_creation/components/logement_location_page.dart';
import 'package:immoplus_pro/modules/logment_creation/components/logment_price_page.dart';
import 'package:immoplus_pro/modules/logment_creation/components/pictures_logment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/components/rules_page.dart';
import 'package:immoplus_pro/modules/logment_creation/components/type_logment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/components/video_logment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/components/wellcome_page.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/create_logment_router.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/creation_residence_manager.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class CreateLodgmentPage extends StatefulWidget {
  const CreateLodgmentPage({super.key});
  static String name = 'create_logment';
  @override
  State<CreateLodgmentPage> createState() => _CreateLodgmentPageState();
}

class _CreateLodgmentPageState extends State<CreateLodgmentPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //CreateLogmentRouter.setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Router(
      routerDelegate: CreateLogmentRouter.router.routerDelegate,
      routeInformationParser: CreateLogmentRouter.router.routeInformationParser,
      routeInformationProvider:
          CreateLogmentRouter.router.routeInformationProvider,
    ));
  }
}

class PregressStepperLogmentCreating extends SliverPersistentHeaderDelegate {
  static ValueNotifier<int> stepperStateNotifier = ValueNotifier<int>(1);
  static setStepe(int step) {
    stepperStateNotifier.value = step;
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: 50,
      child: StepProgressIndicator(
        size: 8,
        roundedEdges: const Radius.circular(10),
        totalSteps: 9,
        currentStep: stepperStateNotifier.value,
        selectedColor: AppColors.primary,
        unselectedColor: AppColors.primaryLite,
        onTap: (p0) {
          return () {
            if (ResidenceCreationModelBuilder().editing == true) {
              if ((p0 + 1) == 1) {
                CreateLogmentRouter.router.goNamed(WellcommePage.name);
              } else if ((p0 + 1) == 2) {
                CreateLogmentRouter.router.goNamed(TypeLogmentPage.name);
              } else if ((p0 + 1) == 3) {
                CreateLogmentRouter.router.goNamed(AmentitiesPage.name);
              } else if ((p0 + 1) == 4) {
                CreateLogmentRouter.router.goNamed(LogmentLocationPage.name);
              } else if ((p0 + 1) == 5) {
                CreateLogmentRouter.router.goNamed(PicturesLogmentPage.name);
              } else if ((p0 + 1) == 6) {
                CreateLogmentRouter.router.goNamed(VideoLogmentPage.name);
              } else if ((p0 + 1) == 7) {
                CreateLogmentRouter.router.goNamed(RulesPage.name);
              } else if ((p0 + 1) == 8) {
                CreateLogmentRouter.router.goNamed(DescriptionEditorPage.name);
              } else if ((p0 + 1) == 9) {
                CreateLogmentRouter.router.goNamed(LogmentPricePage.name);
              }
            }
          };
        },
      ),
    );
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 10;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
