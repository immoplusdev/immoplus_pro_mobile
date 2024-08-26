import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:go_router/go_router.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/cubits/authentification/registration_cubit.dart';
import 'package:immoplus_pro/data/models/configs/commune_config.dart';
import 'package:immoplus_pro/data/models/residence/position_model.dart';
import 'package:immoplus_pro/modules/logment_creation/components/amenities_page.dart';
import 'package:immoplus_pro/modules/logment_creation/components/pictures_logment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/create_lodgment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/create_logment_router.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/enum_utils.dart';
import 'package:immoplus_pro/modules/logment_creation/widgets/step_bottom_button.dart';
import 'package:immoplus_pro/modules/ville_selector/commune_selector_listtile.dart';
import 'package:immoplus_pro/modules/ville_selector/ville_selector_listtile.dart';
import 'package:immoplus_pro/views/shared_widgets/picker_location_listiletile.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class LogmentLocationPage extends StatefulWidget {
  const LogmentLocationPage({super.key});
  static String name = "location";
  @override
  State<LogmentLocationPage> createState() => _LogmentLocationPageState();
}

class _LogmentLocationPageState extends State<LogmentLocationPage> {
  late SelectionCardData currentSlected;
  FocusNode _focusNode = FocusNode();
  int _selectedCity = 1;
  ConfigCommunes _selectedCommune = ConfigCommunes(id: 0, name: '');
  List<ConfigCommunes> communesAbidjan = [
    ConfigCommunes(id: 1, name: "Abobo"),
    ConfigCommunes(id: 2, name: "Adjamé"),
    ConfigCommunes(id: 3, name: "Yopougon"),
    ConfigCommunes(id: 4, name: "Cocody"),
    ConfigCommunes(id: 5, name: "Marcory"),
    ConfigCommunes(id: 6, name: "Treichville"),
    ConfigCommunes(id: 7, name: "Koumassi"),
    ConfigCommunes(id: 8, name: "Plateau"),
    ConfigCommunes(id: 9, name: "Attécoubé"),
    ConfigCommunes(id: 10, name: "Port-Bouët"),
    ConfigCommunes(id: 11, name: "Bingerville"),
  ];
  _getCity({required Widget child}) {
    _focusNode.unfocus();
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  @override
  void initState() {
    ResidenceCreationModelBuilder().ville = 'Abidjan';

    _focusNode.unfocus();
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
          SliverGap(10),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverToBoxAdapter(
              child: Text('Où se situe votre logement ?',
                  style: Theme.of(context).textTheme.headlineLarge),
            ),
          ),
          SliverGap(20),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverToBoxAdapter(child: VilleSelectorListtile(
              onSelect: (ville) {
                if (ville != null) {
                  setState(() {
                    ResidenceCreationModelBuilder().ville = ville.id;
                  });
                }
              },
            )),
          ),
          const SliverGap(10),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverToBoxAdapter(child: CommuneSelectorListtile(
              onSelect: (commune) {
                if (commune != null) {
                  setState(() {
                    ResidenceCreationModelBuilder().commune = commune.id;
                  });
                }
              },
            )),
          ),
          SliverGap(10),
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
                title: Text((ResidenceCreationModelBuilder().adresse.isEmpty)
                    ? 'Position de la résidence'
                    : ResidenceCreationModelBuilder().adresse),
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
                        markerIcon: const Icon(
                          Icons.location_on_sharp,
                          size: 50,
                          color: Colors.red,
                        ),
                        locationButtonBackgroundColor: AppColors.primary,
                        searchBarBackgroundColor: Colors.white,

                        onPicked: (pickedData) {
                          setState(() {
                            inspect(pickedData);
                            ResidenceCreationModelBuilder().adresse =
                                pickedData.address;
                            ResidenceCreationModelBuilder().position =
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
                physics: NeverScrollableScrollPhysics(),
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
          CreateLogmentRouter.router.goNamed(AmentitiesPage.name);
        },
        onNext: (ResidenceCreationModelBuilder().adresse.isNotEmpty &&
                ResidenceCreationModelBuilder().commune.isNotEmpty &&
                ResidenceCreationModelBuilder().ville.isNotEmpty)
            ? () {
                CreateLogmentRouter.router.goNamed(PicturesLogmentPage.name);
              }
            : null,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          inspect(ResidenceCreationModelBuilder().position);
        },
      ),
    );
  }
}
