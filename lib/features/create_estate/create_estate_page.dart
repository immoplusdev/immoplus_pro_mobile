import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_amenities_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_logement_location_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_logment_price_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_pictures_logment_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_type_logment_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_video_logment_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_wellcome_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estatedescription_editor_page.dart';
import 'package:immoplus_pro/features/create_estate/pregress_stepper_estate_creating.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_manager.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_navigation.dart';
import 'package:immoplus_pro/utils/app_dialog.dart';

class CreateEstatePage extends StatefulWidget {
  const CreateEstatePage({super.key});
  static String name = 'create_estate';
  @override
  State<CreateEstatePage> createState() => _CreateEstatePageState();
}

class _CreateEstatePageState extends State<CreateEstatePage> {
  @override
  void initState() {
    CreationEstateNavigation.stepperStateNotifier = ValueNotifier<int>(0);
    CreationEstateNavigation.pageController = PageController();

    CreationEstateNavigation.pageController.addListener(
      () {
        if (EstateCreationModelBuilder().editing == true) {
          CreationEstateNavigation.setStepe(
              CreationEstateNavigation.pageController.page!.round());
        }
      },
    );
    super.initState();
    //CreateLogmentRouter.setup();
  }

  @override
  void dispose() {
    super.dispose();
    CreationEstateNavigation.pageController.dispose();
    CreationEstateNavigation.stepperStateNotifier.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverSafeArea(
              sliver: SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: PregressStepperEstateCreating(),
              ),
            ),
            SliverFillRemaining(
              child: PageView(
                controller: CreationEstateNavigation.pageController,
                physics: EstateCreationModelBuilder().editing
                    ? const BouncingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                children: const [
                  EstateWellcommePage(),
                  EstateTypePage(),
                  EstateAmentitiesPage(),
                  EstateLogmentLocationPage(),
                  EstatePicturesLogmentPage(),
                  EstateVideoLogmentPage(),
                  EstateDescriptionEditorPage(),
                  EstateLogmentPricePage(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 55,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                AppDialog.confirm(
                  context: context,
                  content: EstateCreationModelBuilder().editing
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
