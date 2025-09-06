import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_creation_model.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus_pro/data/models/residence/commodite_model.dart';
import 'package:immoplus_pro/data/models/residence/piece_model.dart';
import 'package:immoplus_pro/data/models/residence/position_model.dart';
import 'package:immoplus_pro/features/create_residence/entity/image_upload_item.dart';

class EstateCreationModelBuilder {
  static final EstateCreationModelBuilder _instance =
      EstateCreationModelBuilder._internal();

  // Attributes
  String? miniature;
  String nom = '';
  String typeBienImmobilier = '';
  String description = '';
  String typeLocation = 'mois';
  int prix = 0;
  String adresse = '';
  String ville = '';
  String commune = '';
  PositionModel position = const PositionModel();
  String? video;
  List<String> images = [];
  List<CommoditeModel> commodites = [];
  List<PieceModel> pieces = [];
  int dureeMinSejour = 0;
  int dureeMaxSejour = 0;
  bool aLouer = true;
  bool editing = false;
  String id = '';
  List<ImageUploadItem> uploadingImages = [];
  // Private constructor
  EstateCreationModelBuilder._internal();

  // Singleton factory
  factory EstateCreationModelBuilder() {
    return _instance;
  }
  BienImmobilierCreationModel build() {
    return BienImmobilierCreationModel(
      miniature: miniature,
      nom: nom,
      typeBienImmobilier: typeBienImmobilier,
      description: description,
      prix: prix,
      adresse: adresse,
      ville: ville,
      commune: commune,
      position: position,
      video: video,
      images: List<String>.from(images),
      amentities: List<CommoditeModel>.from(commodites),
      pieces: List<PieceModel>.from(pieces),
      typeLocation: typeLocation,
      aLouer: aLouer,
    );
  }

  void fromModel(BienImmobilierModel model) {
    miniature = model.miniature;
    nom = model.nom;
    typeBienImmobilier = model.typeBienImmobilier;
    description = model.description;
    prix = model.prix;
    adresse = model.adresse;
    ville = model.ville;
    commune = model.commune;
    position = model.position;
    video = model.video;
    images = List<String>.from(model.images);
    commodites = List<CommoditeModel>.from(model.amentities);
    pieces = List<PieceModel>.from(model.pieces);
    typeLocation = model.typeLocation;
    aLouer = model.aLouer;
    editing = true;
    id = model.id;
    uploadingImages = model.images
        .map((img) => ImageUploadItem(
              status: UploadStatus.success,
              uploadedId: img,
            ))
        .toList();
  }

  // Method to reset all values to default
  void reset() {
    miniature = '';
    nom = '';
    typeBienImmobilier = '';
    description = '';
    prix = 0;
    adresse = '';
    ville = '';
    commune = '';
    position = const PositionModel();
    video = null;
    images = [];
    commodites = [];
    pieces = [];
    dureeMinSejour = 0;
    dureeMaxSejour = 0;
    typeLocation = 'mois';
    aLouer = true;
    editing = false;
    id = '';
    uploadingImages = [];
  }
}
