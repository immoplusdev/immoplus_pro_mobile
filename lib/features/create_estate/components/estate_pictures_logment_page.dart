import 'package:flutter/material.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/services/image_picker_service.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_logement_location_page.dart';
import 'package:immoplus_pro/features/create_estate/components/estate_video_logment_page.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_manager.dart';
import 'package:immoplus_pro/features/create_estate/utils/creation_estate_navigation.dart';
import 'package:immoplus_pro/features/create_residence/entity/image_upload_item.dart';
import 'package:immoplus_pro/features/create_residence/widgets/step_bottom_button.dart';
import 'package:immoplus_pro/features/create_residence/widgets/upload_image_item_card.dart';
import 'package:immoplus_pro/features/residence_detail/components/logment_viewer_image.dart';
import 'package:immoplus_pro/features/shared_widgets/empty_image_picker.dart';

class EstatePicturesLogmentPage extends StatefulWidget {
  const EstatePicturesLogmentPage({super.key});
  static String name = "pictures_logment_page";

  @override
  State<EstatePicturesLogmentPage> createState() =>
      _EstatePicturesLogmentPageState();
}

class _EstatePicturesLogmentPageState extends State<EstatePicturesLogmentPage> {
  bool _isUploading = false;
  final uploadingImages = EstateCreationModelBuilder().uploadingImages;
  @override
  void initState() {
    super.initState();
    //PregressStepperEstateCreating.setStepe(5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          Visibility(
            visible: uploadingImages.isNotEmpty,
            replacement: SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyImagePicker(),
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
      bottomNavigationBar: EstateCreationModelBuilder().editing
          ? SizedBox()
          : StepBottomButton(
              onPrevious: () {
                CreationEstateNavigation.goToPage(
                    pageName: EstateLogmentLocationPage.name);
              },
              onNext: _canProceed()
                  ? () async {
                      CreationEstateNavigation.goToPage(
                          pageName: EstateVideoLogmentPage.name);
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
                          tag: EstateCreationModelBuilder().images[index],
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
        if (!EstateCreationModelBuilder().images.contains(id)) {
          EstateCreationModelBuilder().images.add(id);
        }

        // Définir miniature si aucune
        if (EstateCreationModelBuilder().miniature.isEmpty) {
          EstateCreationModelBuilder().miniature = id;
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
      EstateCreationModelBuilder().images.removeWhere((x) => x == uploadedId);
      if (EstateCreationModelBuilder().miniature == uploadedId) {
        EstateCreationModelBuilder().miniature =
            EstateCreationModelBuilder().images.isNotEmpty
                ? EstateCreationModelBuilder().images.first
                : '';
      }
    }
    _checkUploadCompletion();
  }

  // Méthode pour sélectionner les images
  Future<void> _pickImages() async {
    final pickedImages = await ImagePickerService.pickMultipleImages();

    if (pickedImages.isEmpty) return;

    setState(() {
      // Convertir les XFile en ImageUploadItem avec statut uploading
      final newUploadItems = pickedImages
          .map((file) =>
              ImageUploadItem(file: file, status: UploadStatus.uploading))
          .toList();

      uploadingImages.addAll(newUploadItems);
    });
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
    return EstateCreationModelBuilder().images.isNotEmpty && !_isUploading;
  }
}
