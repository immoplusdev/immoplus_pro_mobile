import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/data/models/furniture/furniture_model.dart';
import 'package:immoplus_pro/features/create_furniture_v2/logic/furniture_creation_cubit_v2.dart';
import 'package:immoplus_pro/features/create_furniture_v2/pages/step1_furniture_general_page.dart';
import 'package:immoplus_pro/features/create_furniture_v2/pages/step2_furniture_details_page.dart';
import 'package:immoplus_pro/features/creations_v2/widgets/creation_stepper_v2.dart';
import 'package:immoplus_pro/features/shared_widgets/loading_page.dart';
import 'package:immoplus_pro/utils/toast_utils.dart';

class CreateFurniturePageV2 extends StatefulWidget {
  final FurnitureModel? initialFurniture;

  const CreateFurniturePageV2({
    super.key,
    this.initialFurniture,
  });

  static const name = 'CREATE_FURNITURE_PAGE_V2';

  @override
  State<CreateFurniturePageV2> createState() => _CreateFurniturePageV2State();
}

class _CreateFurniturePageV2State extends State<CreateFurniturePageV2> {
  late PageController _pageController;
  int _currentStep = 0;

  final List<String> _stepTitles = [
    "Informations générales & Médias",
    "Caractéristiques & Prix",
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentStep < _stepTitles.length - 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FurnitureCreationCubitV2(initialFurniture: widget.initialFurniture),
      child: BlocConsumer<FurnitureCreationCubitV2, FurnitureCreationStateV2>(
        listener: (context, state) {
          if (state.isSuccess) {
            ToastUtils.showSuccess(
              title: "Opération réussie",
              description: state.furniture?.id.isNotEmpty == true
                  ? "Meuble mis à jour"
                  : "Meuble créé avec succès",
            );
            context.pop(true);
          }
          if (state.error != null) {
            ToastUtils.showError(title: "Erreur", description: state.error);
          }
        },
        buildWhen: (p, c) =>
            p.isLoading != c.isLoading ||
            p.isSuccess != c.isSuccess ||
            p.error != c.error ||
            p.currentStep != c.currentStep ||
            p.furniture?.id != c.furniture?.id,
        builder: (context, state) {
          if (state.isLoading) return const LoadingPage();

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
            ),
            body: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: [
                            Text(
                              state.furniture?.id.isNotEmpty == true
                                  ? "Modifier le meuble"
                                  : "Nouveau meuble",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.black,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const Gap(15),
                            CreationStepperV2(
                              currentStep: _currentStep,
                              totalSteps: 2,
                            ),
                          ],
                        ),
                      ),
                      const Gap(15),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _stepTitles[_currentStep],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Step1FurnitureGeneralPage(
                        onNext: () {
                          context.read<FurnitureCreationCubitV2>().nextStep();
                          _nextPage();
                        },
                        onPrevious: () => context.pop(),
                      ),
                      Step2FurnitureDetailsPage(
                        onNext: () =>
                            context.read<FurnitureCreationCubitV2>().submit(),
                        onPrevious: () {
                          context
                              .read<FurnitureCreationCubitV2>()
                              .previousStep();
                          _previousPage();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
