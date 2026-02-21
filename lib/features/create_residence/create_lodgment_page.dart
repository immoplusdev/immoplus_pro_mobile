import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/features/create_residence/pregress_stepper_logment_creating.dart';
import 'package:immoplus_pro/features/create_residence/screens/amenities_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/description_editor_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/logement_location_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/logment_price_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/pictures_logment_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/rules_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/type_logment_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/video_logment_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/wellcome_page.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_navigation.dart';
import 'package:immoplus_pro/utils/app_dialog.dart';

class CreateLodgmentPage extends StatefulWidget {
  const CreateLodgmentPage({super.key});
  static String name = 'create_logment';
  @override
  State<CreateLodgmentPage> createState() => _CreateLodgmentPageState();
}

class _CreateLodgmentPageState extends State<CreateLodgmentPage> {
  @override
  void initState() {
    CreationResidenceNavigation.stepperStateNotifier = ValueNotifier<int>(0);
    CreationResidenceNavigation.pageController = PageController();

    CreationResidenceNavigation.pageController.addListener(
      () {
        if (ResidenceCreationModelBuilder().editing == true) {
          CreationResidenceNavigation.setStepe(
              CreationResidenceNavigation.pageController.page!.round());
        }
      },
    );
    super.initState();
    //CreateLogmentRouter.setup();
  }

  @override
  void dispose() {
    super.dispose();
    CreationResidenceNavigation.pageController.dispose();
    CreationResidenceNavigation.stepperStateNotifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        title: Text(
          ResidenceCreationModelBuilder().editing ? 'Modifier residence' : 'Nouvelle residence',
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
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverSafeArea(
              sliver: SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: PregressStepperResidenceCreating(),
              ),
            ),
            SliverFillRemaining(
              child: PageView(
                controller: CreationResidenceNavigation.pageController,
                physics: ResidenceCreationModelBuilder().editing
                    ? const BouncingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                children: const [
                  WellcommePage(),
                  TypeLogmentPage(),
                  AmentitiesPage(),
                  LogmentLocationPage(),
                  PicturesLogmentPage(),
                  VideoLogmentPage(),
                  RulesPage(),
                  DescriptionEditorPage(),
                  LogmentPricePage(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                AppDialog.confirm(
                  context: context,
                  content: ResidenceCreationModelBuilder().editing
                      ? 'Voulez-vous annuler la modification de cette résidence ?'
                      : 'Voulez-vous annuler la création de cette résidence ?',
                  rollback: () {
                    context.pop();
                    if (context.canPop()) {
                      context.pop();
                    }
                  },
                );
              },
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.red),
                  foregroundColor: Colors.red),
              child: const Text('Annuler'),
            ),
          ],
        ),
      ),
    );
  }
}
