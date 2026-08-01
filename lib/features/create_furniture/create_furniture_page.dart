import 'dart:developer';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/repositories/furniture_repository.dart';
import 'package:immoplus_pro/features/create_furniture/components/step_description_page.dart';
import 'package:immoplus_pro/features/create_furniture/components/step_info_page.dart';
import 'package:immoplus_pro/features/create_furniture/components/step_location_page.dart';
import 'package:immoplus_pro/features/create_furniture/components/step_metadata_page.dart';
import 'package:immoplus_pro/features/create_furniture/components/step_photos_page.dart';
import 'package:immoplus_pro/features/create_furniture/components/step_prix_page.dart';
import 'package:immoplus_pro/features/create_furniture/components/step_videos_page.dart';
import 'package:immoplus_pro/features/create_furniture/utils/furniture_creation_manager.dart';
import 'package:immoplus_pro/features/create_furniture/utils/furniture_creation_navigation.dart';
import 'package:immoplus_pro/features/create_residence/widgets/step_bottom_button.dart';
import 'package:immoplus_pro/features/furnitures/theme/furniture_theme.dart';
import 'package:immoplus_pro/utils/easy_loading_handler.dart';
import 'package:immoplus_pro/utils/app_dialog.dart';
import 'package:immoplus_pro/utils/toast_utils.dart';

/// Page principale de création/édition d'un meuble.

class CreateFurniturePage extends StatefulWidget {
  const CreateFurniturePage({super.key});

  static String name = 'create_furniture';

  @override
  State<CreateFurniturePage> createState() => _CreateFurniturePageState();
}

class _CreateFurniturePageState extends State<CreateFurniturePage> {
  final _manager = FurnitureCreationManager();
  bool _isSubmitting = false;

  bool _validatePriceStep() {
    final prix = _manager.prix ?? 0;
    if (prix <= 0) {
      ToastUtils.showError(title: 'Veuillez saisir un prix superieur a 0');
      return false;
    }
    if (prix % 100 != 0) {
      ToastUtils.showError(title: 'Le prix doit etre un multiple de 100 FCFA');
      return false;
    }
    return true;
  }

  bool _validateStepBeforeContinue(int step) {
    // Step index 2 = Prix
    if (step == 2) return _validatePriceStep();
    return true;
  }

  @override
  void initState() {
    super.initState();
    FurnitureCreationNavigation.currentStepNotifier = ValueNotifier<int>(0);
    FurnitureCreationNavigation.pageController = PageController();

    // En mode édition, synchro le stepper quand on swipe manuellement
    FurnitureCreationNavigation.pageController.addListener(() {
      if (_manager.editing) {
        FurnitureCreationNavigation.setStep(
          FurnitureCreationNavigation.pageController.page!.round(),
        );
      }
    });
  }

  @override
  void dispose() {
    FurnitureCreationNavigation.pageController.dispose();
    FurnitureCreationNavigation.currentStepNotifier.dispose();
    super.dispose();
  }

  // ────────────────────────────────────────────────
  // SOUMISSION
  // ────────────────────────────────────────────────

  /// Crée ou met à jour le meuble via l'API.
  Future<void> _submitForm() async {
    if (!_validatePriceStep()) return;

    setState(() => _isSubmitting = true);

    try {
      if (_manager.editing && _manager.editingId != null) {
        // ── Mode édition : PATCH ──
        EasyLoadingHandler.showLoadingToast(text: 'Modification en cours…');
        await FurnitureRepository.updateFurniture(
          id: _manager.editingId!,
          fields: _manager.build().toJson(),
        );
        EasyLoadingHandler.hideLoadingToast();
        ToastUtils.showSuccess(title: 'Meuble modifié avec succès');
        _manager.reset();
        if (mounted) context.pop(true);
      } else {
        // ── Mode création : POST ──
        EasyLoadingHandler.showLoadingToast(text: 'Création en cours…');
        final response = await FurnitureRepository.createFurniture(
          model: _manager.build(),
        );
        inspect(response);
        EasyLoadingHandler.hideLoadingToast();
        final created = response.data;
        if (created != null) {
          ToastUtils.showSuccess(title: 'Meuble créé: ${created.titre}');
        } else {
          ToastUtils.showSuccess(
            title: 'Meuble créé, mais réponse vide du serveur',
          );
        }
        _manager.reset();
        if (mounted) context.pop(true);
      }
    } catch (e) {
      EasyLoadingHandler.hideLoadingToast();
      ToastUtils.showError(title: 'Erreur : $e');
      log('Erreur soumission meuble : $e', name: 'CREATE_FURNITURE');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  /// Affiche la confirmation d'annulation.
  void _onCancel() {
    AppDialog.confirm(
      context: context,
      content: _manager.editing
          ? 'Voulez-vous annuler la modification de ce meuble ?'
          : 'Voulez-vous annuler la création de ce meuble ?',
      rollback: () {
        _manager.reset();
        context.pop();
        if (context.canPop()) {
          context.pop();
        }
      },
    );
  }

  // ────────────────────────────────────────────────
  // BUILD
  // ────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _manager.editing ? 'Modifier le meuble' : 'Nouveau meuble',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Stepper Header (fixe en haut) ──
            _buildStepperHeader(),

            // ── PageView avec les steps (prend le reste) ──
            Expanded(
              child: PageView(
                controller: FurnitureCreationNavigation.pageController,
                physics: _manager.editing
                    ? const BouncingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                children: const [
                  StepInfoPage(),
                  StepDescriptionPage(),
                  StepPrixPage(),
                  StepLocationPage(),
                  StepPhotosPage(),
                  StepVideosPage(),
                  StepMetadataPage(),
                ],
              ),
            ),
          ],
        ),
      ),

      // ── Bottom Navigation Bar centralisé ──
      // Masqué sur le 1er step (page d'accueil avec son propre bouton "Commencer")
      bottomNavigationBar: ValueListenableBuilder<int>(
        valueListenable: FurnitureCreationNavigation.currentStepNotifier,
        builder: (context, step, _) {
          // Step 0 = page d'accueil → pas de barre de navigation
          if (step == 0) return const SizedBox.shrink();

          return Container(
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Boutons Précédent / Suivant ──
                StepBottomButton(
                  onPreviousText: 'Précédent',
                  onPrevious: () => FurnitureCreationNavigation.previous(),
                  onNextText: _nextButtonLabel(step),
                  onNext: _isSubmitting
                      ? null
                      : () async {
                          if (!_validateStepBeforeContinue(step)) return;

                          if (step <
                              FurnitureCreationNavigation.totalSteps - 1) {
                            FurnitureCreationNavigation.next();
                          } else {
                            await _submitForm();
                          }
                        },
                ),

                // ── Bouton Annuler ──
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextButton(
                    onPressed: _onCancel,
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.red),
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Annuler'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Retourne le label du bouton "Suivant" selon l'étape courante.
  String _nextButtonLabel(int step) {
    if (_isSubmitting) return 'Envoi en cours…';
    if (step == FurnitureCreationNavigation.totalSteps - 1) {
      return _manager.editing ? 'Enregistrer' : 'Créer Meuble';
    }
    return 'Suivant';
  }

  // ────────────────────────────────────────────────
  // STEPPER HEADER (widget fixe)
  // ────────────────────────────────────────────────

  static const List<String> _stepTitles = [
    'Accueil',
    'Description',
    'Prix',
    'Lieu',
    'Photos',
    'Vidéo',
    'Caractéristiques',
  ];

  static const List<FaIconData> _stepIcons = [
    FontAwesomeIcons.couch,
    FontAwesomeIcons.alignLeft,
    FontAwesomeIcons.coins,
    FontAwesomeIcons.locationDot,
    FontAwesomeIcons.camera,
    FontAwesomeIcons.video,
    FontAwesomeIcons.sliders,
  ];

  /// Construit le stepper header comme widget normal (pas un Sliver).
  Widget _buildStepperHeader() {
    return ValueListenableBuilder<int>(
      valueListenable: FurnitureCreationNavigation.currentStepNotifier,
      builder: (context, currentStep, _) {
        return Container(
          color: Colors.white,
          height: 70,
          child: EasyStepper(
            activeStep: currentStep,
            lineStyle: LineStyle(
              lineWidth: 20,
              lineLength: 30,
              lineType: LineType.dotted,
              defaultLineColor: Colors.grey,
              finishedLineColor: FurnitureTheme.stepperLineActiveColor,
            ),
            stepRadius: 16,
            activeStepBackgroundColor: FurnitureTheme.stepperActiveColor,
            finishedStepBackgroundColor:
                AppColors.primary.withValues(alpha: 0.6),
            unreachedStepBackgroundColor: FurnitureTheme.stepperInactiveColor,
            showLoadingAnimation: false,
            steps: List.generate(_stepTitles.length, (index) {
              return EasyStep(
                customStep: Center(
                  child: FaIcon(
                    _stepIcons[index],
                    size: 12,
                    color:
                        index == currentStep ? Colors.white : AppColors.primary,
                  ),
                ),
                customTitle: Text(
                  _stepTitles[index],
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontSize: 8),
                ),
              );
            }),
            onStepReached: (step) {
              log('Stepper tapped: $step');
              if (_manager.editing) {
                FurnitureCreationNavigation.goToStep(step);
              } else {
                if (step < currentStep) {
                  FurnitureCreationNavigation.goToStep(step);
                }
              }
            },
          ),
        );
      },
    );
  }
}
