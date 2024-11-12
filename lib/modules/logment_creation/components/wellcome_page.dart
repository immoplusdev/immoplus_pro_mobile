import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/app_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/modules/logment_creation/components/type_logment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/create_lodgment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/create_logment_router.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/utils/formular_utils.dart';
import 'package:immoplus_pro/utils/lottie_assets.dart';
import 'package:immoplus_pro/views/shared_widgets/custom_text_field.dart';

class WellcommePage extends StatefulWidget {
  const WellcommePage({super.key});
  static String name = "wellcome_page";
  @override
  State<WellcommePage> createState() => _WellcommePageState();
}

class _WellcommePageState extends State<WellcommePage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.text = ResidenceCreationModelBuilder().nom;
    PregressStepperLogmentCreating.setStepe(1);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverAppBar(
            leading: IconButton(
                onPressed: () {
                  AppRouter.router.pop();
                },
                icon: const Icon(FontAwesomeIcons.circleChevronLeft)),
          ),
          // SliverSafeArea(
          //   sliver: SliverPersistentHeader(
          //     delegate: PregressStepperLogmentCreating(),
          //   ),
          // ),
          SliverToBoxAdapter(
            child: SizedBox(height: 300, child: LottieAssets().house),
          ),
          const SliverPadding(
            padding: EdgeInsets.all(10),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Nous sommes ravis de vous accueillir au sein de la communauté ImmoPlus, la plateforme où chaque espace trouve son voyageur. En rejoignant ImmoPlus, vous faites bien plus que simplement lister votre propriété ; vous ouvrez la porte à des expériences inoubliables et à des opportunités enrichissantes.",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // SliverToBoxAdapter(child: FloatingActionButton(onPressed: () {
          //   log(ResidenceCreationModelBuilder().nom);
          // })),
          const SliverGap(10),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverToBoxAdapter(
              child: CustomTextField(
                controller: _controller,
                prefixIcon: const Icon(FontAwesomeIcons.building),
                labelText: "Nom de la résidence",
                validator: (String? value) =>
                    FormUtils.fieldValidator(value: value),
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
                    ResidenceCreationModelBuilder().nom = _controller.text;
                    CreateLogmentRouter.router.goNamed(TypeLogmentPage.name);
                  }
                },
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ResidenceCreationModelBuilder().nom = _controller.text;
                    CreateLogmentRouter.router.goNamed(TypeLogmentPage.name);
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor: AppColors.primary,
                avatar: const Icon(
                  FontAwesomeIcons.doorOpen,
                  color: Colors.white,
                  size: 16,
                ),
                label: const Text("Commencer"),
                labelStyle: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.white),
                deleteIcon: const Icon(
                  CupertinoIcons.chevron_right_circle_fill,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
