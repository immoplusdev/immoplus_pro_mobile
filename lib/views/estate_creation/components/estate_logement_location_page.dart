import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/residence/position_model.dart';
import 'package:immoplus_pro/modules/logment_creation/create_lodgment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/enum_utils.dart';
import 'package:immoplus_pro/modules/logment_creation/widgets/step_bottom_button.dart';
import 'package:immoplus_pro/modules/ville_and_commune_selector/commune_selector_listtile.dart';
import 'package:immoplus_pro/modules/ville_and_commune_selector/ville_selector_listtile.dart';
import 'package:immoplus_pro/views/estate_creation/components/estate_amenities_page.dart';
import 'package:immoplus_pro/views/estate_creation/components/estate_pictures_logment_page.dart';
import 'package:immoplus_pro/views/estate_creation/utils/create_estate_router.dart';
import 'package:immoplus_pro/views/estate_creation/utils/creation_estate_manager.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

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
    PregressStepperLogmentCreating.setStepe(4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scafold,
      body: CustomScrollView(
        slivers: [
          SliverSafeArea(
            sliver: SliverPersistentHeader(
              delegate: PregressStepperLogmentCreating(),
            ),
          ),
          const SliverGap(10),
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
                tileColor: CupertinoColors.systemFill,
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
                    builder: (context) => FractionallySizedBox(
                      heightFactor: 0.9,
                      child: FlutterLocationPicker(
                        mapLanguage: 'fr',

                        initPosition: const LatLong(5.345317, -4.024429),
                        initZoom: 14,
                        minZoomLevel: 5,
                        maxZoomLevel: 16,
                        //trackMyPosition: true,
                        selectLocationButtonText: 'Sélectionner cet endroit',
                        searchBarHintText: 'Rechercher un endroit',
                        zoomButtonsBackgroundColor: AppColors.primary,
                        markerIcon: SizedBox(
                          //color: Colors.grey,
                          height: 55,
                          width: 50,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              RippleAnimation(
                                color: AppColors.primary,
                                delay: const Duration(milliseconds: 300),
                                repeat: true,
                                minRadius: 30,
                                ripplesCount: 6,
                                duration: const Duration(milliseconds: 1000),
                                child: const CircleAvatar(
                                  minRadius: 5,
                                  maxRadius: 5,
                                ),
                              ),
                              const Positioned(
                                top: 1,
                                child: Icon(
                                  Icons.location_on_sharp,
                                  size: 50,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),

                        locationButtonBackgroundColor: AppColors.primary,
                        searchBarBackgroundColor: Colors.white,

                        onPicked: (pickedData) {
                          PickedData;
                          setState(() {
                            inspect(pickedData);
                            EstateCreationModelBuilder().adresse =
                                pickedData.address;
                            EstateCreationModelBuilder().position =
                                PositionModel(type: 'Point', coordinates: [
                              pickedData.latLong.longitude,
                              pickedData.latLong.latitude,
                            ]);
                          });

                          context.pop();
                        },
                      ),
                    ),
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
                    "Sélectionnez **Prendre ma position actuelle** si vous être présentement dans le logement",
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: StepBottomButton(
        onPreview: () {
          CreateEstateRouter.router.goNamed(EstateAmentitiesPage.name);
        },
        onNext: (EstateCreationModelBuilder().adresse.isNotEmpty &&
                EstateCreationModelBuilder().commune.isNotEmpty &&
                EstateCreationModelBuilder().ville.isNotEmpty)
            ? () {
                CreateEstateRouter.router
                    .goNamed(EstatePicturesLogmentPage.name);
              }
            : null,
      ),
    );
  }
}
