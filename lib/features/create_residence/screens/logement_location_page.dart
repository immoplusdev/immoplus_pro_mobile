import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/data/models/configs/address.dart';
import 'package:immoplus_pro/data/models/residence/position_model.dart';
import 'package:immoplus_pro/modules/ville_and_commune_selector/commune_selector_listtile.dart';
import 'package:immoplus_pro/modules/ville_and_commune_selector/ville_selector_listtile.dart';
import 'package:immoplus_pro/features/create_residence/screens/amenities_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/pictures_logment_page.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_navigation.dart';
import 'package:immoplus_pro/features/create_residence/utils/enum_utils.dart';
import 'package:immoplus_pro/features/create_residence/widgets/step_bottom_button.dart';
import 'package:immoplus_pro/features/location_module/location_page.dart';

class LogmentLocationPage extends StatefulWidget {
  const LogmentLocationPage({super.key});
  static String name = "location";
  @override
  State<LogmentLocationPage> createState() => _LogmentLocationPageState();
}

class _LogmentLocationPageState extends State<LogmentLocationPage> {
  late SelectionCardData currentSlected;

  @override
  void initState() {
    super.initState();
    //PregressStepperResidenceCreating.setStepe(3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: AppColors.scafold,
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
          const SliverGap(10),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverToBoxAdapter(
              child: Text('Où se situe votre logement ?',
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
                    ResidenceCreationModelBuilder().ville = ville.id;
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
                    ResidenceCreationModelBuilder().commune = commune.id;
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
                leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      FontAwesomeIcons.locationDot,
                      color: AppColors.primary,
                    )),
                tileColor: ResidenceCreationModelBuilder().adresse.isNotEmpty
                    ? AppColors.scafold
                    : CupertinoColors.tertiarySystemFill,
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
                    enableDrag: false,
                    showDragHandle: true,
                    backgroundColor: AppColors.whiteBackground,
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
                          ResidenceCreationModelBuilder().adresse =
                              value.description!;
                          ResidenceCreationModelBuilder().position =
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
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   log(ResidenceCreationModelBuilder().ville);
      // }),
      bottomNavigationBar: StepBottomButton(
              onPrevious: () {
                CreationResidenceNavigation.goToPage(
                    pageName: AmentitiesPage.name);
                //CreateLogmentRouter.router.goNamed(AmentitiesPage.name);
              },
              onNext: (ResidenceCreationModelBuilder().adresse.isNotEmpty &&
                      ResidenceCreationModelBuilder().commune.isNotEmpty &&
                      ResidenceCreationModelBuilder().ville.isNotEmpty)
                  ? () {
                      CreationResidenceNavigation.goToPage(
                          pageName: PicturesLogmentPage.name);
                      //CreateLogmentRouter.router.goNamed(PicturesLogmentPage.name);
                    }
                  : null,
            ),
    );
  }
}
