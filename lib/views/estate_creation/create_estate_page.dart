import 'package:flutter/material.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/views/estate_creation/utils/create_estate_router.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class CreateEstatePage extends StatefulWidget {
  const CreateEstatePage({super.key});
  static String name = 'create_estate';
  @override
  State<CreateEstatePage> createState() => _CreateEstatePageState();
}

class _CreateEstatePageState extends State<CreateEstatePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CreateEstateRouter.setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Router(
      routerDelegate: CreateEstateRouter.router.routerDelegate,
      routeInformationParser: CreateEstateRouter.router.routeInformationParser,
      routeInformationProvider:
          CreateEstateRouter.router.routeInformationProvider,
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
