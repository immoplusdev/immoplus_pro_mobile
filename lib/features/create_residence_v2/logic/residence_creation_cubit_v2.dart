import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:immoplus_pro/core/services/image_upload_service.dart';
import 'package:immoplus_pro/data/models/residence/commodite_model.dart';
import 'package:immoplus_pro/data/models/residence/piece_model.dart';
import 'package:immoplus_pro/data/models/residence/position_model.dart';
import 'package:immoplus_pro/data/models/residence/residence_creation_model.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/data/repositories/logment_repository.dart';
import 'package:immoplus_pro/features/create_residence/entity/image_upload_item.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'dart:io';

class ResidenceCreationStateV2 {
  final String? miniature;
  final String nom;
  final String typeResidence;
  final String description;
  final int prixReservation;
  final String adresse;
  final String ville;
  final String commune;
  final PositionModel position;
  final String? video;
  final List<String> images;
  final List<CommoditeModel> commodites;
  final List<PieceModel> pieces;
  final List<ImageUploadItem> uploadingImages;
  final int dureeMinSejour;
  final int dureeMaxSejour;
  final String heureEntree;
  final String heureDepart;
  final int nombreMaxOccupants;
  final bool animauxAutorises;
  final bool fetesAutorises;
  final String reglesSupplementaires;
  final bool residenceDisponible;
  final String? id; // Null pour création, String pour édition
  final bool isSubmitting;
  final bool? submissionSuccess;

  const ResidenceCreationStateV2({
    this.miniature,
    this.nom = '',
    this.typeResidence = '',
    this.description = '',
    this.prixReservation = 0,
    this.adresse = '',
    this.ville = '',
    this.commune = '',
    this.position = const PositionModel(),
    this.video,
    this.images = const [],
    this.commodites = const [],
    this.pieces = const [],
    this.uploadingImages = const [],
    this.dureeMinSejour = 0,
    this.dureeMaxSejour = 0,
    this.heureEntree = '',
    this.heureDepart = '',
    this.nombreMaxOccupants = 0,
    this.animauxAutorises = false,
    this.fetesAutorises = false,
    this.reglesSupplementaires = '',
    this.residenceDisponible = true,
    this.id,
    this.isSubmitting = false,
    this.submissionSuccess,
  });

  ResidenceCreationStateV2 copyWith({
    String? miniature,
    String? nom,
    String? typeResidence,
    String? description,
    int? prixReservation,
    String? adresse,
    String? ville,
    String? commune,
    PositionModel? position,
    String? video,
    List<String>? images,
    List<CommoditeModel>? commodites,
    List<PieceModel>? pieces,
    List<ImageUploadItem>? uploadingImages,
    int? dureeMinSejour,
    int? dureeMaxSejour,
    String? heureEntree,
    String? heureDepart,
    int? nombreMaxOccupants,
    bool? animauxAutorises,
    bool? fetesAutorises,
    String? reglesSupplementaires,
    bool? residenceDisponible,
    String? id,
    bool? isSubmitting,
    bool? submissionSuccess,
    bool clearVideo = false,
  }) {
    return ResidenceCreationStateV2(
      miniature: miniature ?? this.miniature,
      nom: nom ?? this.nom,
      typeResidence: typeResidence ?? this.typeResidence,
      description: description ?? this.description,
      prixReservation: prixReservation ?? this.prixReservation,
      adresse: adresse ?? this.adresse,
      ville: ville ?? this.ville,
      commune: commune ?? this.commune,
      position: position ?? this.position,
      video: clearVideo ? null : (video ?? this.video),
      images: images ?? this.images,
      commodites: commodites ?? this.commodites,
      pieces: pieces ?? this.pieces,
      uploadingImages: uploadingImages ?? this.uploadingImages,
      dureeMinSejour: dureeMinSejour ?? this.dureeMinSejour,
      dureeMaxSejour: dureeMaxSejour ?? this.dureeMaxSejour,
      heureEntree: heureEntree ?? this.heureEntree,
      heureDepart: heureDepart ?? this.heureDepart,
      nombreMaxOccupants: nombreMaxOccupants ?? this.nombreMaxOccupants,
      animauxAutorises: animauxAutorises ?? this.animauxAutorises,
      fetesAutorises: fetesAutorises ?? this.fetesAutorises,
      reglesSupplementaires:
          reglesSupplementaires ?? this.reglesSupplementaires,
      residenceDisponible: residenceDisponible ?? this.residenceDisponible,
      id: id ?? this.id,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submissionSuccess: submissionSuccess ?? this.submissionSuccess,
    );
  }

  ResidenceCreationModel toModel() {
    return ResidenceCreationModel(
      miniature: miniature,
      nom: nom,
      typeResidence: typeResidence,
      description: description,
      prixReservation: prixReservation,
      adresse: adresse,
      ville: ville.isNotEmpty ? ville : null,
      commune: commune.isNotEmpty ? commune : null,
      position: position,
      video: video,
      images: images.toList(),
      commodites: commodites.toList(),
      pieces: pieces.toList(),
      dureeMinSejour: dureeMinSejour,
      dureeMaxSejour: dureeMaxSejour,
      heureEntree: heureEntree,
      heureDepart: heureDepart,
      nombreMaxOccupants: nombreMaxOccupants,
      animauxAutorises: animauxAutorises,
      fetesAutorises: fetesAutorises,
      reglesSupplementaires: reglesSupplementaires,
      residenceDisponible: residenceDisponible,
    );
  }
}

class ResidenceCreationCubitV2 extends Cubit<ResidenceCreationStateV2> {
  ResidenceCreationCubitV2() : super(const ResidenceCreationStateV2());

  void updateNom(String nom) => emit(state.copyWith(nom: nom));
  void updateTypeResidence(String type) =>
      emit(state.copyWith(typeResidence: type));

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

  void toggleCommodite(CommoditeModel commodite) {
    final List<CommoditeModel> newCommodites = List.from(state.commodites);
    final exists = newCommodites.any((c) => c.text == commodite.text);
    if (exists) {
      newCommodites.removeWhere((c) => c.text == commodite.text);
    } else {
      newCommodites.add(commodite);
    }
    emit(state.copyWith(commodites: newCommodites));
  }

  bool hasCommodite(CommoditeModel commodite) {
    return state.commodites.any((c) => c.text == commodite.text);
  }

  void addUploadingImages(List<File> files) {
    for (final file in files) {
      _uploadSingleImage(file);
    }
  }

  Future<void> _uploadSingleImage(File file) async {
    final item = ImageUploadItem(file: file, status: UploadStatus.uploading);
    
    // Add to list immediately
    final List<ImageUploadItem> currentUploads = List.from(state.uploadingImages);
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
      if (uploadedIds.isNotEmpty && (newMiniature == null || !uploadedIds.contains(newMiniature))) {
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

  void removeImage(String imagePath) {
    final List<String> newImages = List.from(state.images);
    newImages.remove(imagePath);
    emit(state.copyWith(images: newImages));
  }

  void updateVideo(String? videoPath) {
    emit(state.copyWith(video: videoPath, clearVideo: videoPath == null));
  }

  void updateDescription(String description) {
    emit(state.copyWith(description: description));
  }

  void updateHeures(String entree, String sortie) {
    emit(state.copyWith(heureEntree: entree, heureDepart: sortie));
  }

  void updateDurees(int min, int max) {
    emit(state.copyWith(dureeMinSejour: min, dureeMaxSejour: max));
  }

  void updateRegles(bool animaux, bool fetes, bool bruit) {
    emit(state.copyWith(
      animauxAutorises: animaux,
      fetesAutorises: fetes,
      reglesSupplementaires: bruit ? "Éviter le bruit" : "",
    ));
  }

  void updatePrix(int prix) {
    emit(state.copyWith(prixReservation: prix));
  }

  void initWithResidence(ResidenceModel residence) {
    final List<ImageUploadItem> existingItems = residence.images.map((url) {
      return ImageUploadItem(
        status: UploadStatus.success,
        uploadedId: url,
      );
    }).toList();

    emit(state.copyWith(
      id: residence.id,
      nom: residence.nom,
      typeResidence: residence.typeResidence,
      description: residence.description,
      miniature: residence.miniature,
      prixReservation: residence.prixReservation,
      commune: residence.commune,
      ville: residence.ville,
      adresse: residence.adresse,
      position: residence.position,
      images: residence.images,
      uploadingImages: existingItems,
      video: residence.video,
      commodites: residence.commodites,
      pieces: residence.pieces,
      animauxAutorises: residence.animauxAutorises,
      fetesAutorises: residence.fetesAutorises,
      reglesSupplementaires: residence.reglesSupplementaires,
      dureeMinSejour: residence.dureeMinSejour,
      dureeMaxSejour: residence.dureeMaxSejour,
      heureEntree: residence.heureEntree,
      heureDepart: residence.heureDepart,
      nombreMaxOccupants: residence.nombreMaxOccupants,
      residenceDisponible: residence.residenceDisponible,
    ));
  }

  Future<void> submit() async {
    emit(state.copyWith(isSubmitting: true, submissionSuccess: null));

    try {
      await SessionManager().getCurrentUser();
      final model = state.toModel();

      if (state.id != null) {
        await LogmentRepository.updateResidence(
          id: state.id!,
          fields: model.toJson(),
        );
        emit(state.copyWith(isSubmitting: false, submissionSuccess: true));
      } else {
        final result = await LogmentRepository.createResidence(model: model);
        emit(state.copyWith(
          id: result.data.id,
          isSubmitting: false,
          submissionSuccess: true,
        ));
      }
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, submissionSuccess: false));
    }
  }
}
