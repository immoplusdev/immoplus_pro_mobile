import 'package:flutter/material.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/create_logment_router.dart';
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
    CreateLogmentRouter.setup();
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
    return Container(
      height: 40,
      child: StepProgressIndicator(
        totalSteps: 9,
        currentStep: stepperStateNotifier.value,
        selectedColor: AppColors.primary,
        unselectedColor: AppColors.primaryLite,
      ),
    );
  }

  double get maxExtent => 40;

  double get minExtent => 10;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
