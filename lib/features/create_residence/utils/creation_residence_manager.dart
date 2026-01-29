import 'package:immoplus_pro/data/models/residence/commodite_model.dart';
import 'package:immoplus_pro/data/models/residence/piece_model.dart';
import 'package:immoplus_pro/data/models/residence/position_model.dart';
import 'package:immoplus_pro/data/models/residence/residence_creation_model.dart';
import 'package:immoplus_pro/data/models/residence/residence_model.dart';
import 'package:immoplus_pro/features/create_residence/entity/image_upload_item.dart';

class ResidenceCreationModelBuilder {
  static final ResidenceCreationModelBuilder _instance =
      ResidenceCreationModelBuilder._internal();

  // Attributes
  String? miniature;
  String nom = '';
  String typeResidence = '';
  String description = '';
  int prixReservation = 0;
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
  Map<String, dynamic> metadata = {};
  String heureEntree = '00:00';
  String heureDepart = '00:00';
  int nombreMaxOccupants = 0;
  bool animauxAutorises = false;
  bool fetesAutorises = false;
  String reglesSupplementaires = 'string';
  bool residenceDisponible = true;
  bool editing = false;
  String id = '';
  List<ImageUploadItem> uploadingImages = [];

  // Private constructor
  ResidenceCreationModelBuilder._internal();

  // Singleton factory
  factory ResidenceCreationModelBuilder() {
    return _instance;
  }

  ResidenceCreationModel build() {
    return ResidenceCreationModel(
      miniature: miniature,
      nom: nom,
      typeResidence: typeResidence,
      description: description,
      prixReservation: prixReservation,
      adresse: adresse,
      ville: ville,
      commune: commune,
      position: position,
      video: video,
      images: List<String>.from(images),
      commodites: List<CommoditeModel>.from(commodites),
      pieces: List<PieceModel>.from(pieces),
      dureeMinSejour: dureeMinSejour,
      dureeMaxSejour: dureeMaxSejour,
      //metadata: Map<String, dynamic>.from(metadata),
      heureEntree: heureEntree,
      heureDepart: heureDepart,
      nombreMaxOccupants: nombreMaxOccupants,
      animauxAutorises: animauxAutorises,
      fetesAutorises: fetesAutorises,
      reglesSupplementaires: reglesSupplementaires,
      residenceDisponible: residenceDisponible,
    );
  }

  void fromModel(ResidenceModel model) {
    miniature = model.miniature;
    nom = model.nom;
    typeResidence = model.typeResidence;
    description = model.description;
    prixReservation = model.prixReservation;
    adresse = model.adresse;
    ville = model.ville;
    commune = model.commune;
    position = model.position;
    video = model.video;
    images = List<String>.from(model.images);
    commodites = List<CommoditeModel>.from(model.commodites);
    pieces = List<PieceModel>.from(model.pieces);
    dureeMinSejour = model.dureeMinSejour;
    dureeMaxSejour = model.dureeMaxSejour;
    heureEntree = model.heureEntree;
    heureDepart = model.heureDepart;
    nombreMaxOccupants = model.nombreMaxOccupants;
    animauxAutorises = model.animauxAutorises;
    fetesAutorises = model.fetesAutorises;
    reglesSupplementaires = model.reglesSupplementaires;
    residenceDisponible = model.residenceDisponible;
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
    typeResidence = '';
    description = '';
    prixReservation = 0;
    adresse = '';
    ville = '';
    commune = '';
    position = const PositionModel();
    video = '';
    images = [];
    commodites = [];
    pieces = [];
    dureeMinSejour = 0;
    dureeMaxSejour = 0;
    metadata = {};
    heureEntree = '';
    heureDepart = '';
    nombreMaxOccupants = 0;
    animauxAutorises = false;
    fetesAutorises = false;
    reglesSupplementaires = '';
    residenceDisponible = true;
    editing = false;
    id = '';
    uploadingImages = [];
  }
}
