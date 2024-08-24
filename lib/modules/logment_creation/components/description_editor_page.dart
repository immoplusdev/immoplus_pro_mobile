import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/modules/logment_creation/components/logment_price_page.dart';
import 'package:immoplus_pro/modules/logment_creation/components/rules_page.dart';
import 'package:immoplus_pro/modules/logment_creation/create_lodgment_page.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/create_logment_router.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/enum_utils.dart';
import 'package:immoplus_pro/modules/logment_creation/widgets/step_bottom_button.dart';
import 'package:delta_to_html/delta_to_html.dart';
import 'package:html2md/html2md.dart' as html2md;

class DescriptionEditorPage extends StatefulWidget {
  const DescriptionEditorPage({super.key});
  static String name = "description";
  @override
  State<DescriptionEditorPage> createState() => _DescriptionEditorPageState();
}

class _DescriptionEditorPageState extends State<DescriptionEditorPage> {
  late SelectionCardData currentSlected;
  late QuillController _controller;

  @override
  void initState() {
    super.initState();
    PregressStepperLogmentCreating.setStepe(8);
    _controller = QuillController.basic();
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
              child: Text('Decrivez votre logement',
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.primaryLite,
              child: QuillToolbar.simple(
                configurations: QuillSimpleToolbarConfigurations(
                  showSearchButton: false,
                  showListCheck: false,
                  showColorButton: false,
                  showCodeBlock: false,
                  showLink: false,
                  showRedo: false,
                  showSuperscript: false,
                  showSubscript: false,
                  showUnderLineButton: false,
                  showBackgroundColorButton: false,
                  toolbarSize: 20,
                  controller: _controller,
                  sharedConfigurations: const QuillSharedConfigurations(
                      //locale: Locale('fr'),
                      ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.all(5),
              color: Colors.white,
              height: 500,
              child: QuillEditor.basic(
                configurations: QuillEditorConfigurations(
                  showCursor: true,
                  controller: _controller,
                  //readOnly: false,
                  sharedConfigurations: const QuillSharedConfigurations(),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: StepBottomButton(
        onNext: () {
          _controller.document.toDelta();
          List deltaJson = _controller.document.toDelta().toJson();

          final html = DeltaToHTML.encodeJson(deltaJson).toString();
          ResidenceCreationModelBuilder().description = html2md.convert(html);
          CreateLogmentRouter.router.goNamed(LogmentPricePage.name);
        },
        onPreview: () {
          CreateLogmentRouter.router.goNamed(RulesPage.name);
        },
      ),
    );
  }
}
