import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus_pro/features/creations_v2/widgets/creation_stepper_v2.dart';
import 'package:immoplus_pro/features/create_estate_v2/logic/estate_creation_cubit_v2.dart';
import 'package:immoplus_pro/utils/easy_loading_handler.dart';

import 'pages/step1_general_info_page.dart';
import 'pages/step2_amenities_page.dart';
import 'pages/step3_media_page.dart';
import 'pages/step4_price_page.dart';

class CreateEstatePageV2 extends StatefulWidget {
  final BienImmobilierModel? initialEstate;
  final String? listingRoute;
  const CreateEstatePageV2({super.key, this.initialEstate, this.listingRoute});

  static const name = 'CREATE_ESTATE_PAGE_V2';

  @override
  State<CreateEstatePageV2> createState() => _CreateEstatePageV2State();
}

class _CreateEstatePageV2State extends State<CreateEstatePageV2> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  late final EstateCreationCubitV2 _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = EstateCreationCubitV2();
    if (widget.initialEstate != null) {
      _cubit.initWithEstate(widget.initialEstate!);
    }
  }

  final List<String> _stepTitles = [
    "Type :",
    "Commodité",
    "Photo/ video",
    "Prix"
  ];

  void _nextStep() {
    FocusScope.of(context).unfocus();
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
    FocusScope.of(context).unfocus();
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
      child: BlocListener<EstateCreationCubitV2, EstateCreationStateV2>(
        listenWhen: (p, c) =>
            p.isSubmitting != c.isSubmitting ||
            p.submissionSuccess != c.submissionSuccess,
        listener: (context, state) {
          if (state.isSubmitting) {
            EasyLoadingHandler.showLoadingToast(
                text: state.id != null
                    ? "Modification en cours..."
                    : "Création en cours...");
          } else {
            EasyLoadingHandler.hideLoadingToast();
            if (state.submissionSuccess == true) {
              EasyLoadingHandler.showSuccessToast(
                text: state.id != null
                    ? "Bien immobilier modifié avec succès"
                    : "Bien immobilier créé avec succès",
              );
              if (widget.listingRoute != null) {
                context.replaceNamed(widget.listingRoute!);
              } else {
                context.pop(true);
              }
            } else if (state.submissionSuccess == false) {
              EasyLoadingHandler.showErrorToast(
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
                            BlocBuilder<EstateCreationCubitV2,
                                EstateCreationStateV2>(
                              buildWhen: (p, c) => p.id != c.id,
                              builder: (context, state) {
                                return Text(
                                  state.id != null
                                      ? "Modifier le bien"
                                      : "Nouveau bien",
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
                      Step1EstateGeneralInfoPage(
                          onNext: _nextStep, onPrevious: _previousStep),
                      Step2EstateAmenitiesPage(
                          onNext: _nextStep, onPrevious: _previousStep),
                      Step3EstateMediaPage(
                          onNext: _nextStep, onPrevious: _previousStep),
                      Step4EstatePricePage(
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
