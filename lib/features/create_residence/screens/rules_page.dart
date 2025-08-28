import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:immoplus_pro/features/create_residence/screens/description_editor_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/video_logment_page.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_navigation.dart';
import 'package:immoplus_pro/features/create_residence/widgets/increase_listtile.dart';
import 'package:immoplus_pro/features/create_residence/widgets/list_rule_section.dart';
import 'package:immoplus_pro/features/create_residence/widgets/saving_button.dart';
import 'package:immoplus_pro/features/create_residence/widgets/step_bottom_button.dart';
import 'package:immoplus_pro/features/create_residence/widgets/time_selector.dart';

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
    //PregressStepperResidenceCreating.setStepe(6);
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
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverToBoxAdapter(
              child: Text('Les règles de la maison',
                  style: Theme.of(context).textTheme.headlineMedium),
            ),
          ),
          const SliverGap(20),
          SliverToBoxAdapter(
            child: TimeSelector(
              initialValue: ResidenceCreationModelBuilder().heureEntree.isEmpty
                  ? '00:00'
                  : ResidenceCreationModelBuilder().heureEntree,
              onUpdate: (p0) {
                setState(() {
                  ResidenceCreationModelBuilder().heureEntree = p0;
                });
              },
              icon: const Icon(
                FontAwesomeIcons.doorOpen,
                color: Colors.black,
              ),
              subtitle: 'Heur a partir de laquelle le client peut venir',
            ),
          ),
          const SliverGap(10),
          SliverToBoxAdapter(
            child: TimeSelector(
              initialValue: ResidenceCreationModelBuilder().heureDepart.isEmpty
                  ? '00:00'
                  : ResidenceCreationModelBuilder().heureDepart,
              onUpdate: (p0) {
                setState(() {
                  ResidenceCreationModelBuilder().heureDepart = p0;
                });
              },
              icon: const Icon(
                FontAwesomeIcons.doorClosed,
                color: Colors.black,
              ),
              subtitle: 'Heur avant laquelle le client doit partir',
            ),
          ),
          const SliverGap(10),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Durée minimum de séjour'),
                  IncreaseListTile(
                    title: 'Jour',
                    itemCount: ResidenceCreationModelBuilder().dureeMinSejour,
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
          const SliverGap(10),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Durée maximum de séjour'),
                  IncreaseListTile(
                    title: 'Jour',
                    itemCount: ResidenceCreationModelBuilder().dureeMaxSejour,
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
          const SliverGap(10),
          const ListRuleSection(),
          const SliverToBoxAdapter(),
        ],
      ),
      bottomNavigationBar: (ResidenceCreationModelBuilder().editing)
          ? SavingButton()
          : StepBottomButton(
              onPrevious: () {
                CreationResidenceNavigation.goToPage(
                    pageName: VideoLogmentPage.name);
                // CreateLogmentRouter.router.goNamed(VideoLogmentPage.name);
              },
              onNext: (ResidenceCreationModelBuilder().dureeMaxSejour == 0 ||
                      ResidenceCreationModelBuilder().dureeMinSejour == 0 ||
                      ResidenceCreationModelBuilder().heureDepart.isEmpty ||
                      ResidenceCreationModelBuilder().heureEntree.isEmpty)
                  ? null
                  : () {
                      CreationResidenceNavigation.goToPage(
                          pageName: DescriptionEditorPage.name);
                      //CreateLogmentRouter.router.goNamed(DescriptionEditorPage.name);
                    },
            ),
    );
  }
}
