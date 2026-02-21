import 'package:delta_to_html/delta_to_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_logment_price_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_video_logment_page.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_manager.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_navigation.dart';
import 'package:immoplus_pro/features/create_residence/utils/enum_utils.dart';
import 'package:immoplus_pro/features/create_residence/widgets/step_bottom_button.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_quill/markdown_quill.dart';

class EstateDescriptionEditorPage extends StatefulWidget {
  const EstateDescriptionEditorPage({super.key});
  static String name = "description";
  @override
  State<EstateDescriptionEditorPage> createState() =>
      _EstateDescriptionEditorPageState();
}

class _EstateDescriptionEditorPageState
    extends State<EstateDescriptionEditorPage> {
  late SelectionCardData currentSlected;
  late QuillController _controller = _controller = QuillController.basic();
  ValueNotifier<bool> isEmpty = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    //PregressStepperEstateCreating.setStepe(8);
    if (EstateCreationModelBuilder().description.isNotEmpty) {
      final mdDocument = md.Document(encodeHtml: false);
      final mdToDelta = MarkdownToDelta(markdownDocument: mdDocument);
      // Convertir Markdown en Delta
      final delta = mdToDelta.convert(EstateCreationModelBuilder().description);

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
        EstateCreationModelBuilder().description = html2md.convert(html);
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
      backgroundColor: AppColors.scafold,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverToBoxAdapter(
              child: Text('Decrivez bien immobilier',
                  style: Theme.of(context).textTheme.headlineSmall),
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
                          EstateCreationModelBuilder().description =
                              html2md.convert(html);
                          CreationEstateNavigation.goToPage(
                              pageName: EstateLogmentPricePage.name);
                        },
                  onPrevious: () {
                    CreationEstateNavigation.goToPage(
                        pageName: EstateVideoLogmentPage.name);
                  },
                );
              }),
    );
  }
}
