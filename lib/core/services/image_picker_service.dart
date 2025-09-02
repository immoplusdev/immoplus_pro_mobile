import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:immoplus_pro/core/logger/immo_logger.dart';

class ImagePickerService {
  // Instance privée pour le pattern singleton (optionnel)
  static final ImagePicker _picker = ImagePicker();

  /// Permet à l'utilisateur de sélectionner plusieurs images depuis la galerie
  ///
  /// Retourne une liste de [File] représentant les images sélectionnées.
  /// La qualité des images est réduite à 60% pour optimiser les performances.
  ///
  /// Retourne une liste vide si aucune image n'est sélectionnée ou en cas d'erreur.
  static Future<List<File>> pickMultipleImages({int? imageQuality = 60}) async {
    try {
      final List<XFile> xFiles =
          await _picker.pickMultiImage(imageQuality: imageQuality);
      return xFiles.map((xFile) => File(xFile.path)).toList();
    } catch (e) {
      // Log l'erreur ou gérez-la selon vos besoins
      ImmoLogger.e('Erreur lors de la sélection des images: $e');
      return [];
    }
  }
}
