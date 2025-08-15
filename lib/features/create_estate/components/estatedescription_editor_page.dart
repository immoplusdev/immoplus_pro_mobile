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
import 'package:immoplus_pro/features/create_estate/widgets/saving_estate_button.dart';
import 'package:immoplus_pro/features/create_residence/pregress_stepper_logment_creating.dart';
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
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(5),
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
      bottomNavigationBar: EstateCreationModelBuilder().editing
          ? SavingEstateButton()
          : StepBottomButton(
              onNext: () {
                _controller.document.toDelta();
                List deltaJson = _controller.document.toDelta().toJson();

                final html = DeltaToHTML.encodeJson(deltaJson).toString();
                EstateCreationModelBuilder().description =
                    html2md.convert(html);
                CreationEstateNavigation.goToPage(
                    pageName: EstateLogmentPricePage.name);
              },
              onPreview: () {
                CreationEstateNavigation.goToPage(
                    pageName: EstateVideoLogmentPage.name);
              },
            ),
    );
  }
}
