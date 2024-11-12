import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:immoplus_pro/data/models/residence/commodite_model.dart';
import 'package:immoplus_pro/modules/logment_creation/components/logement_location_page.dart';
import 'package:immoplus_pro/modules/logment_creation/components/type_logment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/create_lodgment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/create_logment_router.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/enum_utils.dart';
import 'package:immoplus_pro/modules/logment_creation/widgets/amentities_selection.dart';
import 'package:immoplus_pro/modules/logment_creation/widgets/step_bottom_button.dart';

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
    PregressStepperLogmentCreating.setStepe(3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverSafeArea(
            sliver: SliverPersistentHeader(
              delegate: PregressStepperLogmentCreating(),
            ),
          ),
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
      bottomNavigationBar: StepBottomButton(
        onNext: ResidenceCreationModelBuilder().commodites.isNotEmpty
            ? () {
                CreateLogmentRouter.router.goNamed(LogmentLocationPage.name);
              }
            : null,
        onPreview: () {
          CreateLogmentRouter.router.goNamed(TypeLogmentPage.name);
        },
      ),
    );
  }
}
