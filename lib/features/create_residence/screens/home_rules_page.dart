import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus_pro/features/create_residence/pregress_stepper_logment_creating.dart';
import 'package:immoplus_pro/features/create_residence/screens/pictures_logment_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/wellcome_page.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_navigation.dart';
import 'package:immoplus_pro/features/create_residence/utils/enum_utils.dart';
import 'package:immoplus_pro/features/create_residence/widgets/step_bottom_button.dart';
import 'package:immoplus_pro/features/place/widgets/selectable_card.dart';

class HomeRulesPage extends StatefulWidget {
  const HomeRulesPage({super.key});
  static String name = "home_rule";
  @override
  State<HomeRulesPage> createState() => _HomeRulesPageState();
}

class _HomeRulesPageState extends State<HomeRulesPage> {
  List<SelectionCardData> amentitiesList = <SelectionCardData>[
    SelectionCardData<LogmentType>(
        icon: const Icon(FontAwesomeIcons.perbyte),
        title: 'Animaux autorisés',
        state: LogmentType.apartment),
    SelectionCardData<LogmentType>(
        icon: const Icon(FontAwesomeIcons.snowflake),
        title: 'Climatisation',
        state: LogmentType.apartment),
    SelectionCardData<LogmentType>(
        icon: const Icon(FontAwesomeIcons.tv),
        title: 'Télévision',
        state: LogmentType.apartment),
    SelectionCardData<LogmentType>(
        icon: const Icon(FontAwesomeIcons.personBooth),
        title: 'Serviettes',
        state: LogmentType.apartment),
  ];
  late SelectionCardData currentSlected;
  @override
  void initState() {
    currentSlected = amentitiesList[0];

    super.initState();
    //PregressStepperResidenceCreating.setStepe(5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverSafeArea(
            sliver: SliverPersistentHeader(
              delegate: PregressStepperResidenceCreating(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverToBoxAdapter(
              child: Text('Que proposez vous dans votre logement ?',
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisExtent: 125,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 4.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return SelectableCard<LogmentType>(
                  state: LogmentType.apartment,
                  selectionData: amentitiesList[index],
                  onSelected: () {},
                  onUnSelected: () {},
                );
              },
              childCount: amentitiesList.length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: StepBottomButton(
              onNext: () {
                //CreateLogmentRouter.router.goNamed(PicturesLogmentPage.name);
                CreationResidenceNavigation.goToPage(
                    pageName: PicturesLogmentPage.name);
              },
              onPrevious: () {
                //CreateLogmentRouter.router.goNamed(WellcommePage.name);
                CreationResidenceNavigation.goToPage(
                    pageName: WellcommePage.name);
              },
            ),
    );
  }
}
