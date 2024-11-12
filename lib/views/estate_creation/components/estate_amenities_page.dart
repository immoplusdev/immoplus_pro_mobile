import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:immoplus_pro/data/models/residence/commodite_model.dart';
import 'package:immoplus_pro/modules/logment_creation/create_lodgment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/widgets/amentities_selection.dart';
import 'package:immoplus_pro/modules/logment_creation/widgets/step_bottom_button.dart';
import 'package:immoplus_pro/views/estate_creation/components/estate_logement_location_page.dart';
import 'package:immoplus_pro/views/estate_creation/components/estate_type_logment_page.dart';
import 'package:immoplus_pro/views/estate_creation/utils/create_estate_router.dart';
import 'package:immoplus_pro/views/estate_creation/utils/creation_estate_manager.dart';
import 'package:immoplus_pro/views/estate_creation/widgets/amentities_selection.dart';

class EstateAmentitiesPage extends StatefulWidget {
  const EstateAmentitiesPage({super.key});
  static String name = "amentities";
  @override
  State<EstateAmentitiesPage> createState() => _EstateAmentitiesPageState();
}

class _EstateAmentitiesPageState extends State<EstateAmentitiesPage> {
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
              child: Text('Que proposez vous dans votre bien ?',
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
          ),
          EstateAmentitiesSelection(
            onSlect: (p0) {
              setState(() {
                EstateCreationModelBuilder().commodites = p0
                    .where(
                      (element) => element['selected'] == true,
                    )
                    .map(
                      (e) => CommoditeModel.fromJson(e as Map<String, dynamic>),
                    )
                    .toList();
                inspect(EstateCreationModelBuilder().commodites);
              });
            },
          ),
        ],
      ),
      bottomNavigationBar: StepBottomButton(
        onNext: () {
          CreateEstateRouter.router.goNamed(EstateLogmentLocationPage.name);
        },
        onPreview: () {
          CreateEstateRouter.router.goNamed(EstateTypePage.name);
        },
      ),
    );
  }
}
