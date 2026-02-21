import 'package:delta_to_html/delta_to_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/create_residence/screens/logment_price_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/rules_page.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_navigation.dart';
import 'package:immoplus_pro/features/create_residence/utils/enum_utils.dart';
import 'package:immoplus_pro/features/create_residence/widgets/step_bottom_button.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_quill/markdown_quill.dart';

class DescriptionEditorPage extends StatefulWidget {
  const DescriptionEditorPage({super.key});
  static String name = "description";
  @override
  State<DescriptionEditorPage> createState() => _DescriptionEditorPageState();
}

class _DescriptionEditorPageState extends State<DescriptionEditorPage> {
  late SelectionCardData currentSlected;
  late QuillController _controller = _controller = QuillController.basic();
  ValueNotifier<bool> isEmpty = ValueNotifier<bool>(true);
  @override
  void initState() {
    super.initState();
    //PregressStepperResidenceCreating.setStepe(7);
    if (ResidenceCreationModelBuilder().description.isNotEmpty) {
      final mdDocument = md.Document(encodeHtml: false);
      final mdToDelta = MarkdownToDelta(markdownDocument: mdDocument);
      // Convertir Markdown en Delta
      final delta =
          mdToDelta.convert(ResidenceCreationModelBuilder().description);

      // Initialiser le QuillController avec le Delta
      _controller = quill.QuillController(
        document: quill.Document.fromDelta(delta),
        selection: const TextSelection.collapsed(offset: 0),
      );
    }
    //  Future.delayed(const Duration(seconds: 1),(){

    //  }),
    _controller.addListener(
      () {
        List deltaJson = _controller.document.toDelta().toJson();

        final html = DeltaToHTML.encodeJson(deltaJson).toString();
        ResidenceCreationModelBuilder().description = html2md.convert(html);
        isEmpty.value = _controller.document.isEmpty();
      },
    );
  }

  // @override
  // void dispose() {
  //   //_controller.removeListener(listener)
  // }
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            sliver: SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: Text('Decrivez votre logement',
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.primaryLite,
              child: QuillSimpleToolbar(
                controller: _controller,
                config: QuillSimpleToolbarConfig(
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
                  showInlineCode: false,
                  showFontSize: false,
                  showFontFamily: false,
                  showQuote: false,
                  showHeaderStyle: false,
                  showStrikeThrough: false,
                  showClearFormat: false,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(5),
              color: Colors.white,
              height: 500,
              child: QuillEditor.basic(
                controller: _controller,
                config: QuillEditorConfig(
                  showCursor: true,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ValueListenableBuilder<bool>(
              valueListenable: isEmpty,
              builder: (context, isEmptyValue, child) {
                return StepBottomButton(
                  onNext: isEmptyValue
                      ? null
                      : () {
                          _controller.document.toDelta();
                          List deltaJson =
                              _controller.document.toDelta().toJson();

                          final html =
                              DeltaToHTML.encodeJson(deltaJson).toString();
                          ResidenceCreationModelBuilder().description =
                              html2md.convert(html);
                          CreationResidenceNavigation.goToPage(
                              pageName: LogmentPricePage.name);

                          //CreateLogmentRouter.router.goNamed(LogmentPricePage.name);
                        },
                  onPrevious: () {
                    CreationResidenceNavigation.goToPage(
                        pageName: RulesPage.name);
                    //CreateLogmentRouter.router.goNamed(RulesPage.name);
                  },
                );
              }),
    );
  }
}
