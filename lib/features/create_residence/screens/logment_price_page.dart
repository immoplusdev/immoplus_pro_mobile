import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/app_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/features/create_residence/screens/description_editor_page.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_navigation.dart';
import 'package:immoplus_pro/features/create_residence/utils/enum_utils.dart';
import 'package:immoplus_pro/features/create_residence/widgets/saving_button.dart';
import 'package:immoplus_pro/features/create_residence/widgets/step_bottom_button.dart';
import 'package:immoplus_pro/features/home_page/utils/custom_popup.dart';
import 'package:immoplus_pro/features/residence/residences_page.dart';
import 'package:immoplus_pro/utils/session_manager.dart';

class LogmentPricePage extends StatefulWidget {
  const LogmentPricePage({super.key});
  static String name = "price_page";
  @override
  State<LogmentPricePage> createState() => _LogmentPricePageState();
}

class _LogmentPricePageState extends State<LogmentPricePage> {
  late SelectionCardData currentSlected;
  late TextEditingController _textEditingController;
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(
        text: ResidenceCreationModelBuilder().prixReservation.toString());

    //PregressStepperResidenceCreating.setStepe(8);
    _controller = MoneyMaskedTextController(
      decimalSeparator: '', // Séparateur décimal
      thousandSeparator: ' ', // Séparateur de milliers
      precision: 0, // Nombre de décimales à afficher
      initialValue: ResidenceCreationModelBuilder()
          .prixReservation
          .toDouble(), // Valeur initiale
      // leftSymbol: ' ',

      rightSymbol: ' FCFA',
    );
    _controller.addListener(
      () {
        log(_controller.numberValue.toString(), name: "VALUE", level: 2);
        ResidenceCreationModelBuilder().prixReservation =
            _controller.numberValue.toInt();
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
            // SliverSafeArea(
            //   sliver: SliverPersistentHeader(
            //     pinned: true,
            //     delegate: PregressStepperResidenceCreating(),
            //   ),
            // ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              sliver: SliverToBoxAdapter(
                child: Text('Quel est le prix de réservation par nuit ?',
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
                  try {
                    // Vérifier si le montant est égal à 0
                    if (_controller.numberValue == 0) {
                      return 'Le montant ne peut pas être égal à 0';
                    }

                    // Vérifier si le montant est un multiple de 100
                    if (_controller.numberValue % 100 != 0) {
                      return 'Le montant doit être un multiple de 100';
                    }
                  } catch (e) {}

                  return null; // Validation réussie
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: (ResidenceCreationModelBuilder().editing)
          ? SavingButton()
          : StepBottomButton(
              onNextText: ResidenceCreationModelBuilder().editing
                  ? 'Modifier'
                  : 'Terminer',
              onNext: () async {
                if (_formKey.currentState!.validate()) {
                  if (ResidenceCreationModelBuilder().editing) {
                    try {
                      CustomPopup.showLoagingToast(
                          text: "Modification en cours");
                      ResidenceCreationModelBuilder().prixReservation =
                          _controller.numberValue.toInt();
                      await SessionManager().getCurrentUser();

                      await LogmentRepository.updateResidence(
                              id: ResidenceCreationModelBuilder().id,
                              fields: ResidenceCreationModelBuilder()
                                  .build()
                                  .toJson())
                          .then(
                        (value) {
                          EasyLoading.dismiss();
                          AppRouter.router.push(
                              '/logment_page/${ResidenceCreationModelBuilder().id}');
                        },
                      );
                    } catch (e) {
                      CustomPopup.showErrorToast(text: 'Modification échoué');
                    }
                  } else {
                    try {
                      EasyLoading.show(status: "Création en cours");
                      ResidenceCreationModelBuilder().prixReservation =
                          _controller.numberValue.toInt();
                      await SessionManager().getCurrentUser();
                      await LogmentRepository.createResidence(
                              model: ResidenceCreationModelBuilder().build())
                          .then(
                        (value) {
                          EasyLoading.dismiss();
                          // CreationResidenceNavigation.goToPage(
                          //     pageName: ResidencesPage.name);
                          AppRouter.router.goNamed(ResidencesPage.name);
                        },
                      );
                    } catch (e) {
                      EasyLoading.dismiss();
                      CustomPopup.showErrorToast(text: 'Création échoué');
                    }
                  }
                }
              },

              //CreateLogmentRouter.router.goNamed(PicturesLogmentPage.name);

              onPreview: () {
                CreationResidenceNavigation.goToPage(
                    pageName: DescriptionEditorPage.name);
                //CreateLogmentRouter.router.goNamed(DescriptionEditorPage.name);
              },
            ),
    );
  }
}
