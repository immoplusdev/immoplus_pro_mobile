import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:immoplus_pro/data/models/residence/commodite_model.dart';
import 'package:immoplus_pro/features/create_residence/screens/logement_location_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/type_logment_page.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_navigation.dart';
import 'package:immoplus_pro/features/create_residence/utils/enum_utils.dart';
import 'package:immoplus_pro/features/create_residence/widgets/amentities_selection.dart';
import 'package:immoplus_pro/features/create_residence/widgets/saving_button.dart';
import 'package:immoplus_pro/features/create_residence/widgets/step_bottom_button.dart';

class AmentitiesPage extends StatefulWidget {
  const AmentitiesPage({super.key});
  static String name = "amentities";
  @override
  State<AmentitiesPage> createState() => _AmentitiesPageState();
}

class _AmentitiesPageState extends State<AmentitiesPage> {
  late SelectionCardData currentSlected;
  @override
  void initState() {
    super.initState();
    //PregressStepperResidenceCreating.setStepe(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // SliverSafeArea(
          //   sliver: SliverPersistentHeader(
          //     delegate: PregressStepperResidenceCreating(),
          //   ),
          // ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverToBoxAdapter(
              child: Text('Que proposez vous dans votre logement ?',
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
          ),
          AmentitiesSelection(
            onSlect: (p0) {
              setState(() {
                ResidenceCreationModelBuilder().commodites = p0
                    .where(
                      (element) => element['selected'] == true,
                    )
                    .map(
                      (e) => CommoditeModel.fromJson(e as Map<String, dynamic>),
                    )
                    .toList();
                inspect(ResidenceCreationModelBuilder().commodites);
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: (ResidenceCreationModelBuilder().editing)
          ? SavingButton()
          : StepBottomButton(
              onNext: ResidenceCreationModelBuilder().commodites.isNotEmpty
                  ? () {
                      //CreateLogmentRouter.router.goNamed(LogmentLocationPage.name);
                      CreationResidenceNavigation.goToPage(
                          pageName: LogmentLocationPage.name);
                    }
                  : null,
              onPrevious: () {
                //CreateLogmentRouter.router.goNamed(TypeLogmentPage.name);
                CreationResidenceNavigation.goToPage(
                    pageName: TypeLogmentPage.name);
              },
            ),
    );
  }
}
