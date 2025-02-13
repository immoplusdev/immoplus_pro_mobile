import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/configs/address.dart';
import 'package:immoplus_pro/data/models/residence/position_model.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_amenities_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_pictures_logment_page.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_manager.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_navigation.dart';
import 'package:immoplus_pro/features/create_residence/utils/enum_utils.dart';
import 'package:immoplus_pro/features/create_residence/widgets/step_bottom_button.dart';
import 'package:immoplus_pro/features/location_module/location_page.dart';
import 'package:immoplus_pro/modules/ville_and_commune_selector/commune_selector_listtile.dart';
import 'package:immoplus_pro/modules/ville_and_commune_selector/ville_selector_listtile.dart';

class EstateLogmentLocationPage extends StatefulWidget {
  const EstateLogmentLocationPage({super.key});
  static String name = "location";
  @override
  State<EstateLogmentLocationPage> createState() =>
      _EstateLogmentLocationPageState();
}

class _EstateLogmentLocationPageState extends State<EstateLogmentLocationPage> {
  late SelectionCardData currentSlected;

  @override
  void initState() {
    super.initState();
    // PregressStepperEstateCreating.setStepe(4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverToBoxAdapter(
              child: Text('Où se situe votre bien ?',
                  style: Theme.of(context).textTheme.headlineLarge),
            ),
          ),
          const SliverGap(20),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverToBoxAdapter(child: VilleSelectorListtile(
              onSelect: (ville) {
                if (ville != null) {
                  setState(() {
                    EstateCreationModelBuilder().ville = ville.id;
                  });
                }
              },
            )),
          ),
          const SliverGap(10),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverToBoxAdapter(child: CommuneSelectorListtile(
              onSelect: (commune) {
                if (commune != null) {
                  setState(() {
                    EstateCreationModelBuilder().commune = commune.id;
                  });
                }
              },
            )),
          ),
          const SliverGap(10),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverToBoxAdapter(
              child: ListTile(
                leading: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      FontAwesomeIcons.locationDot,
                      color: Colors.blue,
                    )),
                tileColor: EstateCreationModelBuilder().adresse.isNotEmpty
                    ? AppColors.scafold
                    : AppColors.whiteBackground,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: Text((EstateCreationModelBuilder().adresse.isEmpty)
                    ? 'Position GPS de votre bien'
                    : EstateCreationModelBuilder().adresse),
                trailing: const Icon(CupertinoIcons.chevron_right_circle_fill),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    showDragHandle: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    builder: (context) => const FractionallySizedBox(
                      heightFactor: 0.9,
                      child: LocationPage(),
                    ),
                  ).then(
                    (value) {
                      inspect(value);
                      if (value is Address) {
                        setState(() {
                          //inspect(pickedData);
                          EstateCreationModelBuilder().adresse =
                              value.description!;
                          EstateCreationModelBuilder().position =
                              PositionModel(type: 'Point', coordinates: [
                            value.longitude!,
                            value.latitude!,
                          ]);
                        });
                      }
                    },
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: Markdown(
                physics: const NeverScrollableScrollPhysics(),
                styleSheet: MarkdownStyleSheet(textAlign: WrapAlignment.center),
                selectable: true,
                data:
                    "Sélectionnez **Ma position actuelle** si vous être présentement dans le logement",
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: StepBottomButton(
        onPreview: () {
          CreationEstateNavigation.goToPage(
              pageName: EstateAmentitiesPage.name);
        },
        onNext: (EstateCreationModelBuilder().adresse.isNotEmpty &&
                EstateCreationModelBuilder().commune.isNotEmpty &&
                EstateCreationModelBuilder().ville.isNotEmpty)
            ? () {
                CreationEstateNavigation.goToPage(
                    pageName: EstatePicturesLogmentPage.name);
              }
            : null,
      ),
    );
  }
}
