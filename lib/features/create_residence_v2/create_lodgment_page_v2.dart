import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';

import 'package:immoplus_pro/features/creations_v2/widgets/creation_stepper_v2.dart';
import 'package:immoplus_pro/features/create_residence_v2/logic/residence_creation_cubit_v2.dart';

import 'pages/step1_general_info_page.dart';
import 'pages/step2_amenities_page.dart';
import 'pages/step3_media_page.dart';
import 'pages/step4_rules_price_page.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:immoplus_pro/features/home_page/utils/custom_popup.dart';

class CreateLodgmentPageV2 extends StatefulWidget {
  final ResidenceModel? initialResidence;
  final String? listingRoute;
  const CreateLodgmentPageV2({super.key, this.initialResidence, this.listingRoute});

  static const name = 'CREATE_LODGMENT_PAGE_V2';

  @override
  State<CreateLodgmentPageV2> createState() => _CreateLodgmentPageV2State();
}

class _CreateLodgmentPageV2State extends State<CreateLodgmentPageV2> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  late final ResidenceCreationCubitV2 _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ResidenceCreationCubitV2();
    if (widget.initialResidence != null) {
      _cubit.initWithResidence(widget.initialResidence!);
    }
  }

  final List<String> _stepTitles = [
    "Type :",
    "Commodité",
    "Photo/ video",
    "Règles"
  ];

  void _nextStep() {
    if (_currentStep < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    } else {
      _cubit.submit();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<ResidenceCreationCubitV2, ResidenceCreationStateV2>(
        listenWhen: (p, c) =>
            p.isSubmitting != c.isSubmitting ||
            p.submissionSuccess != c.submissionSuccess,
        listener: (context, state) {
          if (state.isSubmitting) {
            EasyLoading.show(
                status: state.id != null
                    ? "Modification en cours..."
                    : "Création en cours...");
          } else {
            EasyLoading.dismiss();
            if (state.submissionSuccess == true) {
              CustomPopup.showSuccesToast(
                text: state.id != null
                    ? "Résidence modifiée avec succès"
                    : "Résidence créée avec succès",
              );
              if (widget.listingRoute != null) {
                context.replaceNamed(widget.listingRoute!);
              } else {
                context.pop(true);
              }
            } else if (state.submissionSuccess == false) {
              CustomPopup.showErrorToast(
                text: state.id != null
                    ? "Erreur lors de la modification"
                    : "Erreur lors de la création",
              );
            }
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  color: Colors.black, size: 20),
              onPressed: () {
                if (_currentStep > 0) {
                  _previousStep();
                } else {
                  context.pop();
                }
              },
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Column(
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
                            BlocBuilder<ResidenceCreationCubitV2,
                                ResidenceCreationStateV2>(
                              buildWhen: (p, c) => p.id != c.id,
                              builder: (context, state) {
                                return Text(
                                  state.id != null
                                      ? "Modifier la résidence"
                                      : "Nouvelle résidence",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                    letterSpacing: -0.5,
                                  ),
                                );
                              },
                            ),
                            const Gap(15),
                            CreationStepperV2(
                              currentStep: _currentStep,
                              totalSteps: 4,
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
                      Step1GeneralInfoPage(
                          onNext: _nextStep, onPrevious: _previousStep),
                      Step2AmenitiesPage(
                          onNext: _nextStep, onPrevious: _previousStep),
                      Step3MediaPage(
                          onNext: _nextStep, onPrevious: _previousStep),
                      Step4RulesPricePage(
                          onNext: _nextStep, onPrevious: _previousStep),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
