import 'package:delta_to_html/delta_to_html.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:gap/gap.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:immoplus_pro/common/widgets/v2/creation_description_editor_v2.dart';
import 'package:immoplus_pro/features/create_estate_v2/logic/estate_creation_cubit_v2.dart';
import 'package:immoplus_pro/common/widgets/v2/creation_navigation_buttons_v2.dart';
import 'package:immoplus_pro/features/create_residence/widgets/upload_image_item_card.dart';
import 'package:immoplus_pro/common/widgets/v2/upload_video_page_v2.dart';
import 'package:immoplus_pro/common/widgets/v2/video_preview_v2.dart';
import 'package:immoplus_pro/common/widgets/v2/remove_video_button_v2.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_quill/markdown_quill.dart';
import 'package:immoplus_pro/core/services/image_picker_service.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/create_residence/entity/image_upload_item.dart';

class Step3EstateMediaPage extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Step3EstateMediaPage({
    super.key,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<Step3EstateMediaPage> createState() => _Step3EstateMediaPageState();
}

class _Step3EstateMediaPageState extends State<Step3EstateMediaPage> {
  late quill.QuillController _controller;

  @override
  void initState() {
    super.initState();
    final existingDescription =
        context.read<EstateCreationCubitV2>().state.description;

    if (existingDescription.isNotEmpty) {
      final mdDocument = md.Document(encodeHtml: false);
      final mdToDelta = MarkdownToDelta(markdownDocument: mdDocument);
      final delta = mdToDelta.convert(existingDescription);
      _controller = quill.QuillController(
        document: quill.Document.fromDelta(delta),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      _controller = quill.QuillController.basic();
    }

    _controller.addListener(_onDescriptionChanged);
  }

  void _onDescriptionChanged() {
    final deltaJson = _controller.document.toDelta().toJson();
    final html = DeltaToHTML.encodeJson(deltaJson).toString();
    final markdown = html2md.convert(html);
    context.read<EstateCreationCubitV2>().updateDescription(markdown);
  }

  @override
  void dispose() {
    _controller.removeListener(_onDescriptionChanged);
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final pickedFiles =
        await ImagePickerService.pickMultipleImages(context: context);
    if (pickedFiles.isNotEmpty) {
      if (mounted) {
        context.read<EstateCreationCubitV2>().addUploadingImages(pickedFiles);
      }
    }
  }

  Future<void> _pickVideo() async {
    final videoId = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => const FractionallySizedBox(
        heightFactor: 0.9,
        child: UploadVideoPageV2(),
      ),
    );

    if (videoId != null && mounted) {
      context.read<EstateCreationCubitV2>().updateVideo(videoId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<EstateCreationCubitV2, EstateCreationStateV2>(
            buildWhen: (p, c) =>
                p.uploadingImages != c.uploadingImages || p.video != c.video,
            builder: (context, state) {
              final isUploading = state.uploadingImages
                  .any((i) => i.status == UploadStatus.uploading);

              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Photo de votre bien (Sélectionnez plusieurs) :",
                        style: TextStyle(color: Colors.grey, fontSize: 13)),
                    const Gap(15),

                    // HORIZONTAL IMAGE LIST
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildAddMediaBox(
                            context,
                            width: 100,
                            height: 100,
                            icon: Icons.add_photo_alternate_outlined,
                            text: "Ajouter",
                            onTap: _pickImages,
                          ),
                          ...state.uploadingImages.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: UploadImageItemCard(
                                  key: ValueKey(item.id),
                                  imageItem: item,
                                  onItemUpdated: (updated) => context
                                      .read<EstateCreationCubitV2>()
                                      .updateUploadingImage(updated),
                                  onDelete: () => context
                                      .read<EstateCreationCubitV2>()
                                      .removeUploadingImage(item.id),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    const Gap(25),
                    const Text("Ajoutez une video pour votre feeds",
                        style: TextStyle(color: Colors.grey, fontSize: 13)),
                    const Gap(15),

                    // VIDEO SELECTION
                    state.video != null && state.video!.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              VideoPreviewV2(videoId: state.video!),
                              RemoveVideoButtonV2(
                                onTap: () => context
                                    .read<EstateCreationCubitV2>()
                                    .updateVideo(null),
                              ),
                            ],
                          )
                        : _buildAddMediaBox(
                            context,
                            icon: Icons.video_call_outlined,
                            text: "Ajouter une vidéo",
                            onTap: _pickVideo,
                          ),

                    const Gap(25),
                    // EDITOR BOX
                    CreationDescriptionEditorV2(
                      controller: _controller,
                      label: "Description de votre bien :",
                    ),

                    // UPLOADING STATUS
                    if (isUploading) ...[
                      const Gap(10),
                      Text(
                        "Téléchargement en cours...",
                        style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),

        // BOTTOM BUTTONS
        BlocBuilder<EstateCreationCubitV2, EstateCreationStateV2>(
          builder: (context, state) {
            final hasImages = state.images.isNotEmpty;
            final descriptionValid = state.description.trim().isNotEmpty;
            final isValid = hasImages && descriptionValid;

            return CreationNavigationButtonsV2(
              onPrevious: widget.onPrevious,
              onNext: isValid ? widget.onNext : null,
            );
          },
        ),
      ],
    );
  }

  Widget _buildAddMediaBox(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onTap,
      double? width,
      double? height}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: DottedBorder(
        color: AppColors.primary.withOpacity(0.5),
        strokeWidth: 1.5,
        dashPattern: const [8, 4],
        borderType: BorderType.RRect,
        radius: const Radius.circular(15),
        child: Container(
          width: width ?? 100,
          height: height ?? 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primary, size: 28),
              const Gap(8),
              Text(
                text,
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
