import 'dart:io';
import 'package:immoplus_pro/data/repositories/auth_repository.dart';
import 'package:immoplus_pro/data/models/files/file_data_model.dart';

class ImageUploadService {
  /// Upload une image vers le serveur
  static Future<ImageUploadResult> uploadImage(File file) async {
    try {
      final FileDataModel response =
          await AuthRepository.uplaodFile(file: file);

      if (response.data?.id != null) {
        return ImageUploadResult.success(response.data!.id!);
      } else {
        return ImageUploadResult.failure("Réponse invalide du serveur");
      }
    } catch (e) {
      return ImageUploadResult.failure(_getErrorMessage(e));
    }
  }

  static String _getErrorMessage(Object error) {
    if (error is Exception) {
      return error.toString();
    }
    return 'Une erreur inconnue est survenue';
  }
}

/// Résultat d'un upload d'image
class ImageUploadResult {
  final bool isSuccess;
  final String? imageId;
  final String? errorMessage;

  const ImageUploadResult._({
    required this.isSuccess,
    this.imageId,
    this.errorMessage,
  });

  /// Constructeur pour un upload réussi
  factory ImageUploadResult.success(String imageId) {
    return ImageUploadResult._(
      isSuccess: true,
      imageId: imageId,
    );
  }

  /// Constructeur pour un upload échoué
  factory ImageUploadResult.failure(String errorMessage) {
    return ImageUploadResult._(
      isSuccess: false,
      errorMessage: errorMessage,
    );
  }
}
