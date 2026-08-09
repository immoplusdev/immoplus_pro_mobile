import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:immoplus_pro/constantes/app_colors.dart';

class CreationDescriptionEditorV2 extends StatefulWidget {
  final quill.QuillController controller;
  final String label;
  final double height;

  const 
  CreationDescriptionEditorV2({
    super.key,
    required this.controller,
    this.label = "Description :",
    this.height = 180,
  });

  @override
  State<CreationDescriptionEditorV2> createState() =>
      _CreationDescriptionEditorV2State();
}

class _CreationDescriptionEditorV2State
    extends State<CreationDescriptionEditorV2> {
  late final FocusNode _focusNode;
  final GlobalKey _editorBoxKey = GlobalKey();
  int _scrollRequestId = 0;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) return;
    _scrollRequestId++;
    _waitForKeyboardThenScroll(_scrollRequestId);
  }

  // The keyboard-open animation duration varies by device/OS, so instead of
  // guessing a fixed delay we poll MediaQuery.viewInsets until it stops
  // growing (i.e. the keyboard has finished sliding in) before scrolling.
  Future<void> _waitForKeyboardThenScroll(int requestId) async {
    double previousInset = -1;
    double currentInset = MediaQuery.of(context).viewInsets.bottom;
    for (var i = 0; i < 15; i++) {
      await Future.delayed(const Duration(milliseconds: 60));
      if (!mounted || requestId != _scrollRequestId) return;
      previousInset = currentInset;
      currentInset = MediaQuery.of(context).viewInsets.bottom;
      if (currentInset > 0 && currentInset == previousInset) break;
    }
    if (!mounted || requestId != _scrollRequestId || !_focusNode.hasFocus) {
      return;
    }
    final targetContext = _editorBoxKey.currentContext;
    if (targetContext == null || !targetContext.mounted) return;
    await Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      alignment: 1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          Text(widget.label,
              style: const TextStyle(color: Colors.grey, fontSize: 13)),
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
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(14)),
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    iconTheme: const IconThemeData(color: Colors.white),
                  ),
                  child: quill.QuillSimpleToolbar(
                    controller: widget.controller,
                    config: quill.QuillSimpleToolbarConfig(
                      multiRowsDisplay: false,
                      color: Colors.transparent,
                      showSearchButton: false,
                      showListCheck: false,
                      showColorButton: false,
                      showCodeBlock: false,
                      showLink: false,
                      showRedo: true,
                      showSuperscript: false,
                      showSubscript: false,
                      showUnderLineButton: false,
                      showBackgroundColorButton: false,
                      toolbarIconAlignment: WrapAlignment.center,
                      toolbarSize: 35,
                      showInlineCode: false,
                      showFontSize: false,
                      showFontFamily: false,
                      showQuote: false,
                      showHeaderStyle: false,
                      showStrikeThrough: false,
                      showClearFormat: false,
                      showDividers: false,
                      showBoldButton: true,
                      showItalicButton: true,
                      showListNumbers: true,
                      showListBullets: true,
                      showAlignmentButtons: true,
                      iconTheme: const quill.QuillIconTheme(
                        iconButtonUnselectedData: quill.IconButtonData(
                          color: Colors.white,
                        ),
                        iconButtonSelectedData: quill.IconButtonData(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (!_focusNode.hasFocus) {
                    _focusNode.requestFocus();
                  }
                },
                child: Container(
                  key: _editorBoxKey,
                  height: widget.height,
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(14)),
                  ),
                  child: quill.QuillEditor.basic(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    config: const quill.QuillEditorConfig(
                      showCursor: true,
                      placeholder: "Entrez une description détaillée...",
                    ),
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
