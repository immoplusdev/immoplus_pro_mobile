import 'package:delta_to_html/delta_to_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:gap/gap.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:immoplus_pro/common/widgets/v2/add_media_box_v2.dart';
import 'package:immoplus_pro/common/widgets/v2/creation_description_editor_v2.dart';
import 'package:immoplus_pro/common/widgets/v2/creation_navigation_buttons_v2.dart';
import 'package:immoplus_pro/common/widgets/v2/location_selector_v2.dart';
import 'package:immoplus_pro/common/widgets/v2/upload_video_page_v2.dart';
import 'package:immoplus_pro/common/widgets/v2/video_preview_v2.dart';
import 'package:immoplus_pro/common/widgets/v2/remove_video_button_v2.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/services/image_picker_service.dart';
import 'package:immoplus_pro/data/models/furniture/geo_json_point.dart';
import 'package:immoplus_pro/features/create_furniture_v2/logic/furniture_creation_cubit_v2.dart';
import 'package:immoplus_pro/features/create_residence/widgets/upload_image_item_card.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_quill/markdown_quill.dart';

class Step1FurnitureGeneralPage extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Step1FurnitureGeneralPage({
    super.key,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<Step1FurnitureGeneralPage> createState() =>
      _Step1FurnitureGeneralPageState();
}

class _Step1FurnitureGeneralPageState extends State<Step1FurnitureGeneralPage> {
  late quill.QuillController _descriptionController;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final currentState = context.read<FurnitureCreationCubitV2>().state;
    final existingDescription = currentState.furniture?.description ?? '';
    _nameController =
        TextEditingController(text: currentState.furniture?.titre);

    if (existingDescription.isNotEmpty) {
      final mdDocument = md.Document(encodeHtml: false);
      final mdToDelta = MarkdownToDelta(markdownDocument: mdDocument);
      final delta = mdToDelta.convert(existingDescription);
      _descriptionController = quill.QuillController(
        document: quill.Document.fromDelta(delta),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      _descriptionController = quill.QuillController.basic();
    }

    _descriptionController.addListener(_onDescriptionChanged);
  }

  void _onDescriptionChanged() {
    final deltaJson = _descriptionController.document.toDelta().toJson();
    final html = DeltaToHTML.encodeJson(deltaJson).toString();
    final markdown = html2md.convert(html);
    context.read<FurnitureCreationCubitV2>().updateDescription(markdown);
  }

  @override
  void dispose() {
    _descriptionController.removeListener(_onDescriptionChanged);
    _descriptionController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final pickedFiles =
        await ImagePickerService.pickMultipleImages(context: context);
    if (pickedFiles.isNotEmpty && mounted) {
      context.read<FurnitureCreationCubitV2>().addUploadingImages(pickedFiles);
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
      context.read<FurnitureCreationCubitV2>().updateVideo(videoId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                // Nom du meuble
                const Text("Nom du meuble:",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const Gap(8),
                TextField(
                  controller: _nameController,
                  onChanged: (val) =>
                      context.read<FurnitureCreationCubitV2>().updateTitre(val),
                  decoration: _inputDecoration(),
                ),
                const Gap(20),
                BlocBuilder<FurnitureCreationCubitV2, FurnitureCreationStateV2>(
                  buildWhen: (p, c) =>
                      p.furniture?.adresse != c.furniture?.adresse ||
                      p.furniture?.ville != c.furniture?.ville ||
                      p.furniture?.commune != c.furniture?.commune,
                  builder: (context, state) {
                    return LocationSelectorV2(
                      currentVille: state.villeName,
                      currentCommune: state.communeName,
                      currentAdresse: state.furniture?.adresse,
                      onVilleSelected: (ville) {
                        context
                            .read<FurnitureCreationCubitV2>()
                            .updateLocalisation(
                                state.furniture?.adresse ?? '',
                                ville.id,
                                ville.name,
                                state.furniture?.commune ?? '',
                                state.communeName ?? '',
                                state.furniture?.position ??
                                    const GeoJsonPoint(
                                        type: 'Point', coordinates: [0, 0]));
                      },
                      onCommuneSelected: (commune) {
                        context
                            .read<FurnitureCreationCubitV2>()
                            .updateLocalisation(
                                state.furniture?.adresse ?? '',
                                state.furniture?.ville ?? '',
                                state.villeName ?? '',
                                commune.id,
                                commune.name,
                                state.furniture?.position ??
                                    const GeoJsonPoint(
                                        type: 'Point', coordinates: [0, 0]));
                      },
                      onPositionSelected: (pos) {
                        final geo = GeoJsonPoint(
                          type: 'Point',
                          coordinates: [pos.longitude!, pos.latitude!],
                        );
                        context
                            .read<FurnitureCreationCubitV2>()
                            .updateLocalisation(
                                pos.description ?? '',
                                state.furniture?.ville ?? '',
                                state.villeName ?? '',
                                state.furniture?.commune ?? '',
                                state.communeName ?? '',
                                geo);
                      },
                    );
                  },
                ),
                const Gap(25),
                const Text("Photos du meuble (Sélectionnez plusieurs) :",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const Gap(15),
                BlocBuilder<FurnitureCreationCubitV2, FurnitureCreationStateV2>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          AddMediaBoxV2(
                            isVideo: false,
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
                                      .read<FurnitureCreationCubitV2>()
                                      .updateUploadingImage(updated),
                                  onDelete: () => context
                                      .read<FurnitureCreationCubitV2>()
                                      .removeUploadingImage(item.id),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  },
                ),
                const Gap(25),
                const Text("Une vidéo pour votre flux",
                    style: TextStyle(color: Colors.grey, fontSize: 13)),
                const Gap(15),
                BlocBuilder<FurnitureCreationCubitV2, FurnitureCreationStateV2>(
                  builder: (context, state) {
                    final video = state.furniture?.video;
                    if (video != null && video.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          VideoPreviewV2(videoId: video),
                          RemoveVideoButtonV2(
                            onTap: () => context
                                .read<FurnitureCreationCubitV2>()
                                .updateVideo(null),
                          ),
                        ],
                      );
                    }
                    return AddMediaBoxV2(
                      width: double.infinity,
                      isVideo: true,
                      text: "Ajouter une vidéo",
                      onTap: _pickVideo,
                    );
                  },
                ),
                const Gap(25),
                CreationDescriptionEditorV2(
                  controller: _descriptionController,
                  label: "Description du meuble :",
                ),
                const Gap(30),
              ],
            ),
          ),
        ),
        BlocBuilder<FurnitureCreationCubitV2, FurnitureCreationStateV2>(
          builder: (context, state) {
            final isValid =
                context.read<FurnitureCreationCubitV2>().validateStep1();
            return CreationNavigationButtonsV2(
              onPrevious: widget.onPrevious,
              onNext: isValid ? widget.onNext : null,
            );
          },
        ),
      ],
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.primary),
      ),
    );
  }
}
