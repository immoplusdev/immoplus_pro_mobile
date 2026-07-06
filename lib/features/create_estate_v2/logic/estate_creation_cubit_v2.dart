import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/core/services/image_upload_service.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_creation_model.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus_pro/data/models/residence/commodite_model.dart';
import 'package:immoplus_pro/data/models/residence/piece_model.dart';
import 'package:immoplus_pro/data/models/residence/position_model.dart';
import 'package:immoplus_pro/data/repositories/bien_immobilier_repository.dart';
import 'package:immoplus_pro/features/create_residence/entity/image_upload_item.dart';
import 'package:immoplus_pro/utils/session_manager.dart';

class EstateCreationStateV2 {
  final String? miniature;
  final String nom;
  final String typeBienImmobilier;
  final String description;
  final int prix;
  final String adresse;
  final String ville;
  final String commune;
  final PositionModel position;
  final String? video;
  final List<String> images;
  final List<CommoditeModel> amentities;
  final List<PieceModel> pieces;
  final List<ImageUploadItem> uploadingImages;
  final String typeLocation; // mois, jour, heure, vente
  final bool aLouer;
  final bool bienImmobilierDisponible;
  final String? id; // Null pour création, String pour édition
  final bool isSubmitting;
  final bool? submissionSuccess;

  const EstateCreationStateV2({
    this.miniature,
    this.nom = '',
    this.typeBienImmobilier = '',
    this.description = '',
    this.prix = 0,
    this.adresse = '',
    this.ville = '',
    this.commune = '',
    this.position = const PositionModel(),
    this.video,
    this.images = const [],
    this.amentities = const [],
    this.pieces = const [],
    this.uploadingImages = const [],
    this.typeLocation = 'mois',
    this.aLouer = true,
    this.bienImmobilierDisponible = true,
    this.id,
    this.isSubmitting = false,
    this.submissionSuccess,
  });

  EstateCreationStateV2 copyWith({
    String? miniature,
    String? nom,
    String? typeBienImmobilier,
    String? description,
    int? prix,
    String? adresse,
    String? ville,
    String? commune,
    PositionModel? position,
    String? video,
    List<String>? images,
    List<CommoditeModel>? amentities,
    List<PieceModel>? pieces,
    List<ImageUploadItem>? uploadingImages,
    String? typeLocation,
    bool? aLouer,
    bool? bienImmobilierDisponible,
    String? id,
    bool? isSubmitting,
    bool? submissionSuccess,
    bool clearVideo = false,
  }) {
    return EstateCreationStateV2(
      miniature: miniature ?? this.miniature,
      nom: nom ?? this.nom,
      typeBienImmobilier: typeBienImmobilier ?? this.typeBienImmobilier,
      description: description ?? this.description,
      prix: prix ?? this.prix,
      adresse: adresse ?? this.adresse,
      ville: ville ?? this.ville,
      commune: commune ?? this.commune,
      position: position ?? this.position,
      video: clearVideo ? null : (video ?? this.video),
      images: images ?? this.images,
      amentities: amentities ?? this.amentities,
      pieces: pieces ?? this.pieces,
      uploadingImages: uploadingImages ?? this.uploadingImages,
      typeLocation: typeLocation ?? this.typeLocation,
      aLouer: aLouer ?? this.aLouer,
      bienImmobilierDisponible:
          bienImmobilierDisponible ?? this.bienImmobilierDisponible,
      id: id ?? this.id,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submissionSuccess: submissionSuccess ?? this.submissionSuccess,
    );
  }

  BienImmobilierCreationModel toModel() {
    return BienImmobilierCreationModel(
      miniature: miniature,
      nom: nom,
      typeBienImmobilier: typeBienImmobilier,
      description: description,
      prix: prix,
      adresse: adresse,
      ville: ville.isNotEmpty ? ville : null,
      commune: commune.isNotEmpty ? commune : null,
      position: position,
      video: video,
      images: images.toList(),
      amentities: amentities.toList(),
      pieces: pieces.toList(),
      typeLocation: typeLocation,
      aLouer: aLouer,
      bienImmobilierDisponible: bienImmobilierDisponible,
    );
  }
}

class EstateCreationCubitV2 extends Cubit<EstateCreationStateV2> {
  EstateCreationCubitV2() : super(const EstateCreationStateV2());

  void updateNom(String nom) => emit(state.copyWith(nom: nom));
  void updateTypeBien(String type) =>
      emit(state.copyWith(typeBienImmobilier: type));

  void updateVille(String ville) => emit(state.copyWith(ville: ville));
  void updateCommune(String commune) => emit(state.copyWith(commune: commune));

  void updateLocalisation(String adresse, PositionModel position) {
    emit(state.copyWith(adresse: adresse, position: position));
  }

  void updatePieceQuantity(String nomPiece, int variation) {
    final List<PieceModel> newPieces = List.from(state.pieces);
    final index = newPieces.indexWhere((p) => p.nom == nomPiece);

    if (index >= 0) {
      final oldModel = newPieces[index];
      final newQuantity = oldModel.nombre + variation;
      if (newQuantity <= 0) {
        newPieces.removeAt(index);
      } else {
        newPieces[index] = oldModel.copyWith(nombre: newQuantity);
      }
    } else if (variation > 0) {
      newPieces.add(PieceModel(nom: nomPiece, nombre: variation));
    }
    emit(state.copyWith(pieces: newPieces));
  }

  int getPieceQuantity(String nomPiece) {
    final index = state.pieces.indexWhere((p) => p.nom == nomPiece);
    if (index >= 0) return state.pieces[index].nombre;
    return 0;
  }

  void toggleAmenity(CommoditeModel amenity) {
    final List<CommoditeModel> newAmenities = List.from(state.amentities);
    final exists = newAmenities.any((c) => c.text == amenity.text);
    if (exists) {
      newAmenities.removeWhere((c) => c.text == amenity.text);
    } else {
      newAmenities.add(amenity);
    }
    emit(state.copyWith(amentities: newAmenities));
  }

  bool hasAmenity(CommoditeModel amenity) {
    return state.amentities.any((c) => c.text == amenity.text);
  }

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
  }

  void updateVideo(String? videoPath) {
    emit(state.copyWith(video: videoPath, clearVideo: videoPath == null));
  }

  void updateDescription(String description) {
    emit(state.copyWith(description: description));
  }

  void updatePrix(int prix) {
    emit(state.copyWith(prix: prix));
  }

  void updateFrequency(String frequency, bool aLouer) {
    emit(state.copyWith(typeLocation: frequency, aLouer: aLouer));
  }

  void initWithEstate(BienImmobilierModel estate) {
    final List<ImageUploadItem> existingItems = estate.images.map((url) {
      return ImageUploadItem(
        status: UploadStatus.success,
        uploadedId: url,
      );
    }).toList();

    emit(state.copyWith(
      id: estate.id,
      nom: estate.nom,
      typeBienImmobilier: estate.typeBienImmobilier,
      description: estate.description,
      miniature: estate.miniature,
      prix: estate.prix,
      commune: estate.commune,
      ville: estate.ville,
      adresse: estate.adresse,
      position: estate.position,
      images: estate.images,
      uploadingImages: existingItems,
      video: estate.video,
      amentities: estate.amentities,
      pieces: estate.pieces,
      typeLocation: estate.typeLocation,
      aLouer: estate.aLouer,
      bienImmobilierDisponible: estate.bienImmobilierDisponible,
    ));
  }

  Future<void> submit() async {
    emit(state.copyWith(isSubmitting: true, submissionSuccess: null));

    try {
      await SessionManager().getCurrentUser();
      final model = state.toModel();

      if (state.id != null) {
        await BienImmobilierRepository.update(
          id: state.id!,
          fields: model.toJson(),
        );
        emit(state.copyWith(isSubmitting: false, submissionSuccess: true));
      } else {
        final result = await BienImmobilierRepository.createBienImmobilier(model: model);
        emit(state.copyWith(id: result.data?.id, isSubmitting: false, submissionSuccess: true));
      }
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, submissionSuccess: false));
    }
  }
}
