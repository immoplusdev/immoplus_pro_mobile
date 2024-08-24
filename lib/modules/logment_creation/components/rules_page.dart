import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/modules/logment_creation/components/description_editor_page.dart';
import 'package:immoplus_pro/modules/logment_creation/components/video_logment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/create_lodgment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/create_logment_router.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/modules/logment_creation/widgets/increase_listtile.dart';
import 'package:immoplus_pro/modules/logment_creation/widgets/list_rule_section.dart';
import 'package:immoplus_pro/modules/logment_creation/widgets/step_bottom_button.dart';
import 'package:immoplus_pro/modules/logment_creation/widgets/time_selector.dart';

class RulesPage extends StatefulWidget {
  const RulesPage({super.key});
  static String name = "logment_rules";
  @override
  State<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {
  @override
  void initState() {
    super.initState();
    PregressStepperLogmentCreating.setStepe(7);
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
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverToBoxAdapter(
              child: Text('Les règles de la maison',
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
          ),
          SliverGap(20),
          SliverToBoxAdapter(
            child: TimeSelector(
              onUpdate: (p0) {
                setState(() {
                  ResidenceCreationModelBuilder().heureEntree = p0;
                });
              },
              icon: Icon(
                FontAwesomeIcons.doorOpen,
                color: Colors.black,
              ),
              subtitle: 'Heur a partir de laquelle le client peut venir',
            ),
          ),
          SliverGap(10),
          SliverToBoxAdapter(
            child: TimeSelector(
              onUpdate: (p0) {
                setState(() {
                  ResidenceCreationModelBuilder().heureDepart = p0;
                });
              },
              icon: Icon(
                FontAwesomeIcons.doorClosed,
                color: Colors.black,
              ),
              subtitle: 'Heur avant laquelle le client doit partir',
            ),
          ),
          SliverGap(10),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Durée minimum de séjour'),
                  IncreaseListTile(
                    title: 'Jour',
                    onUpdate: (p0, p1) {
                      setState(() {
                        ResidenceCreationModelBuilder().dureeMinSejour = p1;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          SliverGap(10),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8),
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Durée maximum de séjour'),
                  IncreaseListTile(
                    title: 'Jour',
                    onUpdate: (p0, p1) {
                      setState(() {
                        ResidenceCreationModelBuilder().dureeMaxSejour = p1;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          SliverGap(10),
          ListRuleSection(),
          SliverToBoxAdapter(),
        ],
      ),
      bottomNavigationBar: StepBottomButton(
        onPreview: () {
          CreateLogmentRouter.router.goNamed(VideoLogmentPage.name);
        },
        onNext: (ResidenceCreationModelBuilder().dureeMaxSejour == 0 ||
                ResidenceCreationModelBuilder().dureeMinSejour == 0 ||
                ResidenceCreationModelBuilder().heureDepart.isEmpty ||
                ResidenceCreationModelBuilder().heureEntree.isEmpty)
            ? null
            : () {
                CreateLogmentRouter.router.goNamed(DescriptionEditorPage.name);
              },
      ),
    );
  }
}
