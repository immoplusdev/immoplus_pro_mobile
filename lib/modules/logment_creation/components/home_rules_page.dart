import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus_pro/modules/logment_creation/components/pictures_logment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/components/wellcome_page.dart';
import 'package:immoplus_pro/modules/logment_creation/create_lodgment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/create_logment_router.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/enum_utils.dart';
import 'package:immoplus_pro/modules/logment_creation/widgets/step_bottom_button.dart';
import 'package:immoplus_pro/views/place/widgets/selectable_card.dart';

class HomeRulesPage extends StatefulWidget {
  const HomeRulesPage({super.key});
  static String name = "home_rule";
  @override
  State<HomeRulesPage> createState() => _HomeRulesPageState();
}

class _HomeRulesPageState extends State<HomeRulesPage> {
  List<SelectionCardData> amentitiesList = <SelectionCardData>[
    SelectionCardData<LogmentType>(
        icon: Icon(FontAwesomeIcons.perbyte),
        title: 'Animaux autorisés',
        state: LogmentType.apartment),
    SelectionCardData<LogmentType>(
        icon: Icon(FontAwesomeIcons.snowflake),
        title: 'Climatisation',
        state: LogmentType.apartment),
    SelectionCardData<LogmentType>(
        icon: Icon(FontAwesomeIcons.tv),
        title: 'Télévision',
        state: LogmentType.apartment),
    SelectionCardData<LogmentType>(
        icon: Icon(FontAwesomeIcons.personBooth),
        title: 'Serviettes',
        state: LogmentType.apartment),
  ];
  late SelectionCardData currentSlected;
  @override
  void initState() {
    currentSlected = amentitiesList[0];

    super.initState();
    PregressStepperLogmentCreating.setStepe(5);
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
            padding: EdgeInsets.symmetric(horizontal: 8),
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
          CreateLogmentRouter.router.goNamed(PicturesLogmentPage.name);
        },
        onPreview: () {
          CreateLogmentRouter.router.goNamed(WellcommePage.name);
        },
      ),
    );
  }
}
