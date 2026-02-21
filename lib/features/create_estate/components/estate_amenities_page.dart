import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/residence/commodite_model.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_logement_location_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_type_logment_page.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_manager.dart';
import 'package:immoplus_pro/features/create_estate/widgets/amentities_selection.dart';
import 'package:immoplus_pro/features/create_residence/widgets/step_bottom_button.dart';

import '../utils/creation_estate_navigation.dart';

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
    //PregressStepperEstateCreating.setStepe(3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
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
                CreationEstateNavigation.goToPage(
                    pageName: EstateLogmentLocationPage.name);
              },
              onPrevious: () {
                CreationEstateNavigation.goToPage(
                    pageName: EstateTypePage.name);
              },
            ),
    );
  }
}
