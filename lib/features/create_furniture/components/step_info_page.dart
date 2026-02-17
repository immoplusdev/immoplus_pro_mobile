import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/create_furniture/utils/furniture_creation_manager.dart';
import 'package:immoplus_pro/features/create_furniture/utils/furniture_creation_navigation.dart';
import 'package:immoplus_pro/features/shared_widgets/custom_text_field.dart';
import 'package:immoplus_pro/utils/formular_utils.dart';
import 'package:immoplus_pro/utils/lottie_assets.dart';


class StepInfoPage extends StatefulWidget {
  const StepInfoPage({super.key});

  static String name = 'step_info_page';

  @override
  State<StepInfoPage> createState() => _StepInfoPageState();
}

class _StepInfoPageState extends State<StepInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final _manager = FurnitureCreationManager();

  @override
  void initState() {
    super.initState();
    _controller.text = _manager.titre ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SafeArea(
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200, 
                child: LottieAssets().furniture, 
                
              ),
            ),
            const SliverPadding(
              padding: EdgeInsets.all(10),
              sliver: SliverToBoxAdapter(
                child: Column(
                  children: [
                    Text(
                      "Meuble",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Gap(10),
                    Text(
                      "Bienvenue dans l'ajout de meuble sur ImmoPlus ! "
                      "Donnez un nom à votre meuble pour commencer. "
                      "Vous pourrez ensuite ajouter une description, "
                      "un prix, des photos et bien plus encore.",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SliverGap(10),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              sliver: SliverToBoxAdapter(
                child: CustomTextField(
                  controller: _controller,
                  prefixIcon: const Icon(FontAwesomeIcons.couch),
                  labelText: "Nom du meuble",
                  onChanged: (name) {
                    if (name.trim().isNotEmpty) {
                      _manager.titre = name.trim();
                    }
                  },
                  validator: (String? value) =>
                      FormUtils.fieldValidator(value: value),
                ),
              ),
            ),
            const SliverGap(30),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              sliver: SliverToBoxAdapter(
                child: InputChip(
                  padding: const EdgeInsets.all(10),
                  onDeleted: () {
                    if (_formKey.currentState!.validate()) {
                      _manager.titre = _controller.text.trim();
                      FurnitureCreationNavigation.next();
                    }
                  },
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _manager.titre = _controller.text.trim();
                      FurnitureCreationNavigation.next();
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  backgroundColor: AppColors.furnitureViolet,
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
            ),
            const SliverGap(20),
          ],
        ),
      ),
    );
  }
}
