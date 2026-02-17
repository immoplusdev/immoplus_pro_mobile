import 'package:flutter/material.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:immoplus_pro/core/services/image_picker_service.dart';
import 'package:immoplus_pro/features/create_furniture/utils/furniture_creation_manager.dart';
import 'package:immoplus_pro/features/create_residence/entity/image_upload_item.dart';
import 'package:immoplus_pro/features/create_residence/widgets/upload_image_item_card.dart';
import 'package:immoplus_pro/features/shared_widgets/empty_image_picker.dart';

/// Step 5 du stepper de création de meuble : Photos.

class StepPhotosPage extends StatefulWidget {
  const StepPhotosPage({super.key});

  static String name = 'step_photos_page';

  @override
  State<StepPhotosPage> createState() => _StepPhotosPageState();
}

class _StepPhotosPageState extends State<StepPhotosPage> {
  static const int _maxImages = 5;

  final _manager = FurnitureCreationManager();
  bool _isUploading = false;

  /// Raccourci vers la liste d'images en cours d'upload.
  List<ImageUploadItem> get _uploadingImages => _manager.uploadingImages;

  // ──────────────────────────────────────────────
  // PICK & UPLOAD
  // ──────────────────────────────────────────────

  /// Ouvre le sélecteur d'images multiples.
  Future<void> _pickImages() async {
    final remaining = _maxImages - _uploadingImages.length;
    if (remaining <= 0) return;

    final pickedImages = await ImagePickerService.pickMultipleImages(context: context);
    if (pickedImages.isEmpty) return;

    setState(() {
      final toAdd = pickedImages.take(remaining).toList();
      final newItems = toAdd
          .map((file) =>
              ImageUploadItem(file: file, status: UploadStatus.uploading))
          .toList();
      _uploadingImages.addAll(newItems);
    });
  }

  /// Met à jour un item d'upload après succès ou échec.
  void _handleItemUpdated(int index, ImageUploadItem updatedItem) {
    setState(() {
      _uploadingImages[index] = updatedItem;

      if (updatedItem.isUploaded && updatedItem.uploadedId != null) {
        // Reconstruire la liste des IDs d'images uploadées
        _manager.images = _uploadingImages
            .where((item) => item.isUploaded && item.uploadedId != null)
            .map((item) => item.uploadedId!)
            .toList();
      }

      _checkUploadCompletion();
    });
  }

  /// Supprime une image de la liste.
  void _removeImage(ImageUploadItem item) {
    setState(() {
      _uploadingImages.removeWhere((it) => it.id == item.id);

      final uploadedId = item.uploadedId;
      if (uploadedId != null && uploadedId.isNotEmpty) {
        _manager.images.removeWhere((x) => x == uploadedId);
      }

      _checkUploadCompletion();
    });
  }

  /// Vérifie si un upload est toujours en cours.
  void _checkUploadCompletion() {
    final hasUploading =
        _uploadingImages.any((item) => item.status == UploadStatus.uploading);
    setState(() {
      _isUploading = hasUploading;
    });
  }

  // ──────────────────────────────────────────────
  // BUILD
  // ──────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          Visibility(
            visible: _uploadingImages.isNotEmpty,
            replacement: SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyImagePicker(),
            ),
            child: _buildImagesGrid(),
          ),
        ],
      ),
      floatingActionButton: _uploadingImages.length < _maxImages
          ? FloatingActionButton(
              backgroundColor:
                  _isUploading ? Colors.grey : AppColors.furnitureViolet,
              onPressed: _isUploading ? null : _pickImages,
              child: _isUploading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.add_photo_alternate_outlined,
                      color: Colors.white),
            )
          : null,
    );
  }

  /// Grille d'images en cours d'upload / uploadées.
  Widget _buildImagesGrid() {
    if (_uploadingImages.isEmpty) {
      return SliverToBoxAdapter(child: Container());
    }

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
            final item = _uploadingImages[index];
            return UploadImageItemCard(
              key: ValueKey(item.id),
              imageItem: item,
              onItemUpdated: (updatedItem) =>
                  _handleItemUpdated(index, updatedItem),
              onDelete: () => _removeImage(item),
            );
          },
          childCount: _uploadingImages.length,
        ),
      ),
    );
  }
}
