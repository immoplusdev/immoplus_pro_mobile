import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:immoplus_pro/app_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/modules/logment_creation/components/description_editor_page.dart';
import 'package:immoplus_pro/modules/logment_creation/create_lodgment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/create_logment_router.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/enum_utils.dart';
import 'package:immoplus_pro/modules/logment_creation/widgets/step_bottom_button.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/views/residence/residences_page.dart';

class LogmentPricePage extends StatefulWidget {
  const LogmentPricePage({super.key});
  static String name = "price_page";
  @override
  State<LogmentPricePage> createState() => _LogmentPricePageState();
}

class _LogmentPricePageState extends State<LogmentPricePage> {
  late SelectionCardData currentSlected;
  late TextEditingController _textEditingController;
  late GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    PregressStepperLogmentCreating.setStepe(9);
  }

  final MoneyMaskedTextController _controller = MoneyMaskedTextController(
    decimalSeparator: '.', // Séparateur décimal
    thousandSeparator: ' ', // Séparateur de milliers
    precision: 1, // Nombre de décimales à afficher
    initialValue: 0, // Valeur initiale
    // leftSymbol: ' ',
    rightSymbol: ' F',
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scafold,
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverSafeArea(
              sliver: SliverPersistentHeader(
                delegate: PregressStepperLogmentCreating(),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              sliver: SliverToBoxAdapter(
                child: Text('Quel est le prix de réservation par nuit ?',
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
            ),
            SliverGap(50),
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

                  // Vérifier si le montant est un nombre valide
                  if (_controller.numberValue == null) {
                    return 'Veuillez entrer un montant valide';
                  }

                  // Vérifier si le montant est égal à 0
                  if (_controller.numberValue == 0) {
                    return 'Le montant ne peut pas être égal à 0';
                  }

                  // Vérifier si le montant est un multiple de 100
                  if (_controller.numberValue! % 100 != 0) {
                    return 'Le montant doit être un multiple de 100';
                  }

                  return null; // Validation réussie
                },
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: StepBottomButton(
        onNext: () async {
          if (_formKey.currentState!.validate()) {
            EasyLoading.show(status: "Création en cours");
            ResidenceCreationModelBuilder().prixReservation =
                _controller.numberValue.toInt();
            await SessionManager().getCurrentUser();
            await LogmentRepository.createResidence(
                    model: ResidenceCreationModelBuilder().build())
                .then(
              (value) {
                EasyLoading.dismiss();
                AppRouter.router.goNamed(ResidencesPage.name);
              },
            );
          }
        },

        //CreateLogmentRouter.router.goNamed(PicturesLogmentPage.name);

        onPreview: () {
          CreateLogmentRouter.router.goNamed(DescriptionEditorPage.name);
        },
      ),
    );
  }
}
