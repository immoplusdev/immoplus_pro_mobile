import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/core/services/image_upload_service.dart';
import 'package:immoplus_pro/data/models/furniture/furniture_creation_model.dart';
import 'package:immoplus_pro/data/models/furniture/furniture_model.dart';
import 'package:immoplus_pro/data/models/furniture/furniture_status.dart';
import 'package:immoplus_pro/data/models/furniture/geo_json_point.dart';
import 'package:immoplus_pro/data/repositories/furniture_repository.dart';
import 'package:immoplus_pro/features/create_residence/entity/image_upload_item.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:immoplus_pro/core/injection.dart';

class FurnitureCreationStateV2 {
  final int currentStep;
  final FurnitureModel? furniture;
  final List<ImageUploadItem> uploadingImages;
  final List<String> images;
  final String? miniature;
  final String? villeName;
  final String? communeName;
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  const FurnitureCreationStateV2({
    this.currentStep = 0,
    this.furniture,
    this.uploadingImages = const [],
    this.images = const [],
    this.miniature,
    this.villeName,
    this.communeName,
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  FurnitureCreationStateV2 copyWith({
    int? currentStep,
    FurnitureModel? furniture,
    List<ImageUploadItem>? uploadingImages,
    List<String>? images,
    String? miniature,
    String? villeName,
    String? communeName,
    bool? isLoading,
    String? error,
    bool? isSuccess,
    bool clearVideo = false,
  }) {
    FurnitureModel? updatedFurniture = furniture ?? this.furniture;
    if (clearVideo && updatedFurniture != null) {
      updatedFurniture = updatedFurniture.copyWith(video: null);
    }

    return FurnitureCreationStateV2(
      currentStep: currentStep ?? this.currentStep,
      furniture: updatedFurniture,
      uploadingImages: uploadingImages ?? this.uploadingImages,
      images: images ?? this.images,
      miniature: miniature ?? this.miniature,
      villeName: villeName ?? this.villeName,
      communeName: communeName ?? this.communeName,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class FurnitureCreationCubitV2 extends Cubit<FurnitureCreationStateV2> {
  FurnitureCreationCubitV2({FurnitureModel? initialFurniture})
      : super(FurnitureCreationStateV2(
          furniture: initialFurniture ??
              FurnitureModel(
                id: '',
                owner: getIt<SessionManager>().currentUser?.userId ?? '',
                titre: '',
                description: '',
                adresse: '',
                prix: 0,
                status: FurnitureStatus.active,
                metadata: {'colors': <String>[]},
              ),
        )) {
    if (initialFurniture != null) {
      final List<ImageUploadItem> existingItems = initialFurniture.images?.map((url) {
            return ImageUploadItem(
              status: UploadStatus.success,
              uploadedId: url,
            );
          }).toList() ??
          [];

      emit(state.copyWith(
        images: initialFurniture.images ?? [],
        uploadingImages: existingItems,
      ));
    }
  }

  bool get isEditing => state.furniture?.id.isNotEmpty ?? false;

  void nextStep() => emit(state.copyWith(currentStep: state.currentStep + 1));
  void previousStep() => emit(state.copyWith(currentStep: state.currentStep - 1));

  // --- Update Methods ---

  void updateTitre(String val) => _update((f) => f.copyWith(titre: val));
  void updateDescription(String val) => _update((f) => f.copyWith(description: val));
  void updateAdresse(String val) => _update((f) => f.copyWith(adresse: val));

  void updateLocalisation(String adresse, String villeId, String villeName, String communeId, String communeName, GeoJsonPoint position) {
    emit(state.copyWith(villeName: villeName, communeName: communeName));
    _update((f) => f.copyWith(
          adresse: adresse,
          ville: villeId,
          commune: communeId,
          position: position,
          lat: position.latitude,
          lng: position.longitude,
        ));
  }

  void updateVideo(String? video) {
    if (video == null) {
      emit(state.copyWith(clearVideo: true));
    } else {
      _update((f) => f.copyWith(video: video));
    }
  }

  // IMAGE UPLOAD METHODS
  void addUploadingImages(List<File> files) {
    for (final file in files) {
      _uploadSingleImage(file);
    }
  }

  Future<void> _uploadSingleImage(File file) async {
    final item = ImageUploadItem(file: file, status: UploadStatus.uploading);

    // Add to list immediately
    final List<ImageUploadItem> currentUploads =
        List.from(state.uploadingImages);
    currentUploads.add(item);
    emit(state.copyWith(uploadingImages: currentUploads));

    // Start upload
    final result = await ImageUploadService.uploadImage(file);

    // Update the item status
    updateUploadingImage(item.copyWith(
      status: result.isSuccess ? UploadStatus.success : UploadStatus.failed,
      uploadedId: result.imageId,
      errorMessage: result.errorMessage,
    ));
  }

  void updateUploadingImage(ImageUploadItem item) {
    final List<ImageUploadItem> newUploads = List.from(state.uploadingImages);
    final index = newUploads.indexWhere((u) => u.id == item.id);
    if (index >= 0) {
      newUploads[index] = item;

      final List<String> uploadedIds = newUploads
          .where((i) => i.isUploaded && i.uploadedId != null)
          .map((i) => i.uploadedId!)
          .toList();

      String? newMiniature = state.miniature;
      if (uploadedIds.isNotEmpty &&
          (newMiniature == null || !uploadedIds.contains(newMiniature))) {
        newMiniature = uploadedIds.first;
      }

      emit(state.copyWith(
        uploadingImages: newUploads,
        images: uploadedIds,
        miniature: newMiniature,
      ));
      
      _update((f) => f.copyWith(images: uploadedIds));
    }
  }

  void removeUploadingImage(String id) {
    final List<ImageUploadItem> newUploads = List.from(state.uploadingImages);
    newUploads.removeWhere((u) => u.id == id);

    final List<String> uploadedIds = newUploads
        .where((i) => i.isUploaded && i.uploadedId != null)
        .map((i) => i.uploadedId!)
        .toList();

    String? newMiniature = state.miniature;
    if (!uploadedIds.contains(newMiniature)) {
      newMiniature = uploadedIds.isNotEmpty ? uploadedIds.first : null;
    }

    emit(state.copyWith(
      uploadingImages: newUploads,
      images: uploadedIds,
      miniature: newMiniature,
    ));
    _update((f) => f.copyWith(images: uploadedIds));
  }

  void updateCategory(String category) => _update((f) => f.copyWith(category: category));
  void updateType(String type) => _update((f) => f.copyWith(type: type));
  void updateEtat(String etat) => _update((f) => f.copyWith(etat: etat));
  void updatePrix(int prix) => _update((f) => f.copyWith(prix: prix));

  void updateColors(List<String> hexColors) {
    final meta = Map<String, dynamic>.from(state.furniture?.metadata ?? {});
    meta['colors'] = hexColors;
    _update((f) => f.copyWith(metadata: meta));
  }

  void _update(FurnitureModel Function(FurnitureModel) update) {
    if (state.furniture == null) return;
    emit(state.copyWith(furniture: update(state.furniture!)));
  }

  // --- Actions ---

  Future<void> submit() async {
    if (state.furniture == null) return;

    emit(state.copyWith(isLoading: true, error: null));

    final ville = state.furniture?.ville?.isEmpty == true ? null : state.furniture?.ville;
    final commune = state.furniture?.commune?.isEmpty == true ? null : state.furniture?.commune;

    try {
      if (isEditing) {
        final fields = state.furniture!.toJson();
        if (ville == null) fields.remove('ville');
        if (commune == null) fields.remove('commune');
        
        await FurnitureRepository.updateFurniture(
          id: state.furniture!.id,
          fields: fields,
        );
        emit(state.copyWith(isLoading: false, isSuccess: true));
      } else {
        final creationModel = FurnitureCreationModel(
          titre: state.furniture!.titre,
          description: state.furniture!.description,
          prix: state.furniture!.prix,
          adresse: state.furniture!.adresse,
          ville: ville,
          commune: commune,
          position: state.furniture!.position,
          lat: state.furniture!.lat,
          lng: state.furniture!.lng,
          images: state.images,
          video: state.furniture!.video,
          type: state.furniture!.type,
          category: state.furniture!.category,
          etat: state.furniture!.etat,
          metadata: state.furniture!.metadata,
        );
        final result = await FurnitureRepository.createFurniture(
          model: creationModel,
        );
        emit(state.copyWith(
          furniture: state.furniture!.copyWith(id: result.data?.id ?? ''),
          isLoading: false,
          isSuccess: true,
        ));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  // Validation
  bool validateStep1() {
    final f = state.furniture;
    if (f == null) return false;
    return f.titre.isNotEmpty && f.adresse.isNotEmpty && (state.images.isNotEmpty) && f.description.isNotEmpty;
  }

  bool validateStep2() {
    final f = state.furniture;
    if (f == null) return false;
    return (f.category?.isNotEmpty ?? false) && (f.type?.isNotEmpty ?? false) && (f.etat?.isNotEmpty ?? false) && f.prix > 0;
  }
}
