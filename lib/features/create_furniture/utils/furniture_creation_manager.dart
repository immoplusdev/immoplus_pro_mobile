import 'package:immoplus_pro/data/models/furniture/furniture_creation_model.dart';
import 'package:immoplus_pro/data/models/furniture/furniture_model.dart';
import 'package:immoplus_pro/data/models/furniture/furniture_status.dart';
import 'package:immoplus_pro/data/models/furniture/geo_json_point.dart';
import 'package:immoplus_pro/features/create_residence/entity/image_upload_item.dart';

/// Singleton qui stocke toutes les données saisies à travers les 4 steps
/// du stepper de création/édition d'un meuble.
///
/// Les données persistent entre les étapes : l'utilisateur peut naviguer
/// librement sans perdre ses saisies.
///
/// Usage :
/// ```dart
/// // Création
/// FurnitureCreationManager().reset();
/// FurnitureCreationManager().titre = "Table en bois";
/// final model = FurnitureCreationManager().build();
///
/// // Édition
/// FurnitureCreationManager().fromModel(existingFurniture);
/// // ... modifier des champs ...
/// final updatedModel = FurnitureCreationManager().build();
/// ```
class FurnitureCreationManager {
  static final FurnitureCreationManager _instance =
      FurnitureCreationManager._internal();

  // ──────────────────────────────────────────────
  // Step 1 — Informations générales
  // ──────────────────────────────────────────────
  String? titre;
  String? description;
  int? prix;

  // ──────────────────────────────────────────────
  // Step 2 — Localisation
  // ──────────────────────────────────────────────
  String? adresse;
  String? ville;
  String? commune;
  double? lat;
  double? lng;

  // ──────────────────────────────────────────────
  // Step 3 — Médias
  // ──────────────────────────────────────────────
  List<String> images = [];
  String? video;
  List<ImageUploadItem> uploadingImages = [];

  // ──────────────────────────────────────────────
  // Step 4 — Métadonnées & Statut
  // ──────────────────────────────────────────────
  String? category;
  String? type;
  String? etat;
  FurnitureStatus status = FurnitureStatus.active;
  Map<String, dynamic> metadata = {};

  // ──────────────────────────────────────────────
  // Mode édition
  // ──────────────────────────────────────────────
  bool editing = false;
  String? editingId;

  // Private constructor
  FurnitureCreationManager._internal();

  // Singleton factory
  factory FurnitureCreationManager() {
    return _instance;
  }

  /// Construit le [FurnitureCreationModel] final pour le POST/PATCH.
  ///
  /// Si [lat] et [lng] sont définis, crée automatiquement un [GeoJsonPoint]
  /// au format GeoJSON `[longitude, latitude]`.
  FurnitureCreationModel build() {
    GeoJsonPoint? position;
    if (lat != null && lng != null) {
      position = GeoJsonPoint.fromLatLng(
        latitude: lat!,
        longitude: lng!,
      );
    }

    return FurnitureCreationModel(
      titre: titre ?? '',
      description: description ?? '',
      prix: prix ?? 0,
      adresse: adresse ?? '',
      ville: ville,
      commune: commune,
      position: position,
      lat: lat,
      lng: lng,
      images: List<String>.from(images),
      video: video,
      category: category,
      type: type,
      etat: etat,
      status: status,
      metadata: Map<String, dynamic>.from(metadata),
    );
  }

  /// Pré-remplit tous les champs depuis un [FurnitureModel] existant
  /// pour le mode édition.
  ///
  /// Active [editing] et stocke l'[editingId].
  void fromModel(FurnitureModel model) {
    // Step 1
    titre = model.titre;
    description = model.description;
    prix = model.prix;

    // Step 2
    adresse = model.adresse;
    ville = model.ville;
    commune = model.commune;
    lat = model.lat;
    lng = model.lng;

    // Step 3
    images = List<String>.from(model.images ?? []);
    video = model.video;
    uploadingImages = (model.images ?? [])
        .map((img) => ImageUploadItem(
              status: UploadStatus.success,
              uploadedId: img,
            ))
        .toList();

    // Step 4
    category = model.category;
    type = model.type;
    etat = model.etat;
    status = model.status;
    metadata = Map<String, dynamic>.from(model.metadata ?? {});

    // Mode édition
    editing = true;
    editingId = model.id;
  }

  /// Remet tous les champs à leurs valeurs par défaut.
  ///
  /// À appeler avant de commencer une nouvelle création.
  void reset() {
    // Step 1
    titre = null;
    description = null;
    prix = null;

    // Step 2
    adresse = null;
    ville = null;
    commune = null;
    lat = null;
    lng = null;

    // Step 3
    images = [];
    video = null;
    uploadingImages = [];

    // Step 4
    category = null;
    type = null;
    etat = null;
    status = FurnitureStatus.active;
    metadata = {};

    // Mode édition
    editing = false;
    editingId = null;
  }
}
