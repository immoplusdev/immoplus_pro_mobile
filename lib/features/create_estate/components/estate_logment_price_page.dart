import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_payment_type.dart';
import 'package:immoplus_pro/features/create_estate/components/estatedescription_editor_page.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_manager.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_navigation.dart';
import 'package:immoplus_pro/features/create_residence/utils/enum_utils.dart';
import 'package:immoplus_pro/features/create_residence/widgets/step_bottom_button.dart';
import 'package:immoplus_pro/utils/easy_loading_handler.dart';
import 'package:immoplus_pro/utils/session_manager.dart';

class EstateLogmentPricePage extends StatefulWidget {
  const EstateLogmentPricePage({super.key});
  static String name = "price_page";
  @override
  State<EstateLogmentPricePage> createState() => _EstateLogmentPricePageState();
}

class _EstateLogmentPricePageState extends State<EstateLogmentPricePage> {
  late SelectionCardData currentSlected;
  late TextEditingController _textEditingController;
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(
        text: EstateCreationModelBuilder().prix.toString());
    //PregressStepperEstateCreating.setStepe(9);
    _controller = MoneyMaskedTextController(
      decimalSeparator: '.', // Séparateur décimal
      thousandSeparator: ' ', // Séparateur de milliers
      precision: 1, // Nombre de décimales à afficher
      initialValue:
          EstateCreationModelBuilder().prix.toDouble(), // Valeur initiale
      // leftSymbol: ' ',

      rightSymbol: ' F',
    );
    _controller.addListener(
      () {
        EstateCreationModelBuilder().prix = _controller.numberValue.toInt();
      },
    );
  }

  late MoneyMaskedTextController _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              sliver: SliverToBoxAdapter(
                child: Text('Quel est le prix  ?',
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
            ),
            const SliverGap(50),
            SliverToBoxAdapter(
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                enableInteractiveSelection: false,
                autofocus: true,
                keyboardType: TextInputType.number,
                // onChanged: (value) {
                //   _textEditingController.text =
                //       Utils.simpleFormatCurrency(int.parse(value));
                // },
                controller: _controller,
                cursorWidth: 3,
                decoration: InputDecoration(
                  filled: false,
                  errorStyle: GoogleFonts.inter(
                    color: Colors.red, // Couleur du texte d'erreur

                    fontSize: 14, // Taille du texte d'erreur
                  ),

                  //suffix: Text('F CFA'),
                ),
                textAlign: TextAlign.center,

                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(color: AppColors.primary),

                // Centrage de l'indicateur d'erreur

                validator: (value) {
                  // Vérifier si le champ est vide
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un montant';
                  }

                  // Vérifier si le montant est égal à 0
                  if (_controller.numberValue == 0) {
                    return 'Le montant ne peut pas être égal à 0';
                  }

                  // Vérifier si le montant est un multiple de 100
                  if (_controller.numberValue % 100 != 0) {
                    return 'Le montant doit être un multiple de 100';
                  }

                  return null; // Validation réussie
                },
              ),
            ),
            const SliverGap(50),
            const SliverToBoxAdapter(
              child: EstatePayementType(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: StepBottomButton(
              onNextText: EstateCreationModelBuilder().editing
                  ? 'Modifier'
                  : 'Terminer',
              onNext: () async {
                inspect(EstateCreationModelBuilder().build());

                if (_formKey.currentState!.validate()) {
                  if (EstateCreationModelBuilder().editing) {
                    try {
                      EasyLoadingHandler.showLoadingToast(
                          text: "Modification en cours");

                      EstateCreationModelBuilder().prix =
                          _controller.numberValue.toInt();
                      await SessionManager().getCurrentUser();

                      await BienImmobilierRepository.update(
                              id: EstateCreationModelBuilder().id,
                              fields:
                                  EstateCreationModelBuilder().build().toJson())
                          .then(
                        (value) {
                          EasyLoadingHandler.hideLoadingToast();
                          if (context.mounted) context.pop(true);
                        },
                      );
                    } catch (e) {
                      EasyLoading.dismiss();
                      EasyLoadingHandler.showErrorToast(text: 'Modification échoué');
                    }
                  } else {
                    try {
                      EasyLoadingHandler.showLoadingToast(text: "Création en cours");
                      EstateCreationModelBuilder().prix =
                          _controller.numberValue.toInt();
                      await SessionManager().getCurrentUser();
                      await BienImmobilierRepository.createBienImmobilier(
                              model: EstateCreationModelBuilder().build())
                          .then(
                        (value) {
                          EasyLoadingHandler.hideLoadingToast();
                          EstateCreationModelBuilder().reset();
                          context.pop(true);
                          // AppRouter.router.goNamed(EstatesPage.name);
                        },
                      );
                    } catch (e) {
                      EasyLoading.dismiss();
                    }
                  }
                }
              },

              // CreationEstateNavigation.goToPage(pageName:PicturesLogmentPage.name);

              onPrevious: () {
                CreationEstateNavigation.goToPage(
                    pageName: EstateDescriptionEditorPage.name);
              },
            ),
    );
  }
}
