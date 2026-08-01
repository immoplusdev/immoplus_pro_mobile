import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_type_logment_page.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_manager.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_navigation.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_text_field.dart';
import 'package:immoplus_pro/utils/formular_utils.dart';
import 'package:immoplus_pro/utils/lottie_assets.dart';

class EstateWellcommePage extends StatefulWidget {
  const EstateWellcommePage({super.key});
  static String name = "estate_wellcome_page";
  @override
  State<EstateWellcommePage> createState() => _EstateWellcommePageState();
}

class _EstateWellcommePageState extends State<EstateWellcommePage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.text = EstateCreationModelBuilder().nom;
    //PregressStepperEstateCreating.setStepe(1);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          // SliverSafeArea(
          //   sliver: SliverPersistentHeader(
          //     delegate: PregressStepperLogmentCreating(),
          //   ),
          // ),
          SliverToBoxAdapter(
            child: SizedBox(height: 250, child: LottieAssets().house),
          ),
          const SliverPadding(
            padding: EdgeInsets.all(10),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  Text(
                    "Biens immobiliers",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Gap(10),
                  Text(
                    "Nous sommes ravis de vous accueillir au sein de la communauté ImmoPlus. Ajoutez vos biens immobiliers, tels que des appartements, des maisons à louer, des terrains à vendre, ou des espaces, ainsi que tout autre bien que nos clients pourraient demander à visiter en vue d'une location ou d'une vente.",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SliverGap(20),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverToBoxAdapter(
              child: CustomTextField(
                controller: _controller,
                prefixIcon: const FaIcon(FontAwesomeIcons.building),
                labelText: "Nom du bien immobilier",
                validator: (String? value) =>
                    FormUtils.fieldValidator(value: value),
                onChanged: (name) {
                  if (name.trim().isNotEmpty) {
                    EstateCreationModelBuilder().nom = name;
                  }
                },
              ),
            ),
          ),

          const SliverGap(50),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverToBoxAdapter(
              child: InputChip(
                padding: const EdgeInsets.all(10),
                onDeleted: () {
                  if (_formKey.currentState!.validate()) {
                    EstateCreationModelBuilder().nom = _controller.text;
                    CreationEstateNavigation.goToPage(
                        pageName: EstateTypePage.name);
                  }
                },
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    EstateCreationModelBuilder().nom = _controller.text;
                    CreationEstateNavigation.goToPage(
                        pageName: EstateTypePage.name);
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor: AppColors.primary,
                avatar: const FaIcon(FontAwesomeIcons.doorOpen,
                  color: Colors.white,
                  size: 16,
                ),
                label: const Text("Commencer"),
                labelStyle: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white),
                deleteIcon: const Icon(
                  CupertinoIcons.chevron_right_circle_fill,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(),
        ],
      ),
    );
  }
}
