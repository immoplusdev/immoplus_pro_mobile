import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:immoplus_pro/constantes/app_colors.dart';

class CreationDescriptionEditorV2 extends StatelessWidget {
  final quill.QuillController controller;
  final String label;
  final double height;

  const CreationDescriptionEditorV2({
    super.key,
    required this.controller,
    this.label = "Description :",
    this.height = 180,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 10),
        ],
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                ),
                child: quill.QuillSimpleToolbar(
                  controller: controller,
                  config: const quill.QuillSimpleToolbarConfig(
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
                    toolbarSize: 40,
                    showInlineCode: false,
                    showFontSize: false,
                    showFontFamily: false,
                    showQuote: false,
                    showHeaderStyle: false,
                    showStrikeThrough: false,
                    showClearFormat: false,
                    iconTheme: quill.QuillIconTheme(
                      iconButtonUnselectedData: quill.IconButtonData(color: Colors.white),
                      iconButtonSelectedData: quill.IconButtonData(color: Colors.black87),
                    ),
                  ),
                ),
              ),
              Container(
                height: height,
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
                ),
                child: quill.QuillEditor.basic(
                  controller: controller,
                  config: const quill.QuillEditorConfig(
                    showCursor: true,
                    placeholder: "Entrez une description détaillée...",
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
