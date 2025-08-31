import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/features/create_residence/entity/image_upload_item.dart';
import 'package:immoplus_pro/features/create_residence/screens/logement_location_page.dart';
import 'package:immoplus_pro/features/create_residence/screens/video_logment_page.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_manager.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_navigation.dart';
import 'package:immoplus_pro/features/create_residence/widgets/saving_button.dart';
import 'package:immoplus_pro/features/create_residence/widgets/step_bottom_button.dart';
import 'package:immoplus_pro/features/create_residence/widgets/upload_image_item_card.dart';
import 'package:immoplus_pro/features/residence_detail/components/logment_viewer_image.dart';

class PicturesLogmentPage extends StatefulWidget {
  const PicturesLogmentPage({super.key});
  static String name = "pictures_logment_page";

  @override
  State<PicturesLogmentPage> createState() => _PicturesLogmentPageState();
}

class _PicturesLogmentPageState extends State<PicturesLogmentPage> {
  bool _isUploading = false;
  final uploadingImages = ResidenceCreationModelBuilder().uploadingImages;

  @override
  void initState() {
    super.initState();
    //PregressStepperResidenceCreating.setStepe(4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          Visibility(
            visible: uploadingImages.isNotEmpty,
            replacement: SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  padding: const EdgeInsets.all(20),
                  color: Colors.grey.shade400,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        FontAwesomeIcons.photoFilm,
                        size: 100,
                        color: Colors.grey,
                      ),
                      Gap(20),
                      Text(
                        "Capturez la beauté de votre bien ! Prenez des photos soigneusement travaillées pour attirer davantage de clients. N'oubliez pas, la première image sélectionnée sera celle affichée en miniature.",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )),
            ),
            child: _buildUploadingImagesGrid(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _isUploading ? Colors.grey : AppColors.primary,
        onPressed: _isUploading ? null : _pickImages,
        child: _isUploading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2))
            : const Icon(Icons.add_photo_alternate_outlined),
      ),
      bottomNavigationBar: (ResidenceCreationModelBuilder().editing)
          ? SavingButton()
          : StepBottomButton(
              onPrevious: () {
                // CreateLogmentRouter.router.goNamed(LogmentLocationPage.name);
                CreationResidenceNavigation.goToPage(
                    pageName: LogmentLocationPage.name);
              },
              onNext: _canProceed()
                  ? () async {
                      CreationResidenceNavigation.goToPage(
                          pageName: VideoLogmentPage.name);
                      //CreateLogmentRouter.router.goNamed(VideoLogmentPage.name);
                    }
                  : null,
            ),
    );
  }

  Widget _buildUploadingImagesGrid() {
    if (uploadingImages.isEmpty) return SliverToBoxAdapter(child: Container());

    return SliverPadding(
      padding: const EdgeInsets.all(12),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250.0,
          mainAxisExtent: 200,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final item = uploadingImages[index];
            return UploadImageItemCard(
              key: ValueKey(item.id),
              imageItem: item,
              onItemUpdated: (updatedItem) =>
                  _handleItemUpdated(index, updatedItem),
              onDelete: () {
                setState(() => _removeItemEverywhere(item));
              },
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewerImageLogment(
                          initialPage: index,
                          tag: ResidenceCreationModelBuilder().images[index],
                          imageUrls: uploadingImages
                              .where((ite) => ite.isUploaded)
                              .map((e) => e.uploadedId!)
                              .toList()),
                    ));
              },
            );
          },
          childCount: uploadingImages.length,
        ),
      ),
    );
  }

  /// Méthode pour gérer la mise à jour d'un élément d'upload
  void _handleItemUpdated(int index, ImageUploadItem updatedItem) {
    setState(() {
      uploadingImages[index] = updatedItem;

      if (updatedItem.isUploaded && updatedItem.uploadedId != null) {
        final id = updatedItem.uploadedId!;

        // Ajout si pas déjà présent
        if (!ResidenceCreationModelBuilder().images.contains(id)) {
          ResidenceCreationModelBuilder().images.add(id);
        }

        // Définir miniature si aucune
        if (ResidenceCreationModelBuilder().miniature.isEmpty) {
          ResidenceCreationModelBuilder().miniature = id;
        }
      }

      _checkUploadCompletion();
    });
  }

  /// Méthode pour supprimer un élément de la liste d'upload et des images finales
  void _removeItemEverywhere(ImageUploadItem item) {
    uploadingImages.removeWhere((it) => it.id == item.id);

    final uploadedId = item.uploadedId;
    if (uploadedId != null && uploadedId.isNotEmpty) {
      ResidenceCreationModelBuilder()
          .images
          .removeWhere((x) => x == uploadedId);
      if (ResidenceCreationModelBuilder().miniature == uploadedId) {
        ResidenceCreationModelBuilder().miniature =
            ResidenceCreationModelBuilder().images.isNotEmpty
                ? ResidenceCreationModelBuilder().images.first
                : '';
      }
    }
    _checkUploadCompletion();
  }

  // Méthode pour sélectionner les images
  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();

    try {
      final List<XFile> pickedImages =
          await picker.pickMultiImage(imageQuality: 60);

      if (pickedImages.isEmpty) return;

      setState(() {
        // Convertir les XFile en ImageUploadItem avec statut uploading
        final newUploadItems = pickedImages
            .map((xFile) => ImageUploadItem(
                file: File(xFile.path), status: UploadStatus.uploading))
            .toList();

        uploadingImages.addAll(newUploadItems);
        inspect(uploadingImages);
      });
    } catch (e) {
      // Gérer les erreurs de sélection d'images
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la sélection des images: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Méthode pour vérifier si tous les uploads sont terminés
  void _checkUploadCompletion() {
    final hasUploadingImages =
        uploadingImages.any((item) => item.status == UploadStatus.uploading);

    setState(() {
      _isUploading = hasUploadingImages;
    });
  }

  bool _canProceed() {
    return ResidenceCreationModelBuilder().images.isNotEmpty && !_isUploading;
  }
}
