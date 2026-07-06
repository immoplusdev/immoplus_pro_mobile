import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:immoplus_pro/data/models/files/file_data_model.dart';
import 'package:immoplus_pro/data/repositories/auth_repository.dart';

enum FileUploadStatus { idle, uploading, uploaded, error }

class FileUploaderController {
  String? filePath;
  File? file;

  /// Statut de l'upload en arrière-plan, observable par l'UI (badge sur la carte).
  final ValueNotifier<FileUploadStatus> status =
      ValueNotifier(FileUploadStatus.idle);

  /// ID renvoyé par le serveur une fois l'upload terminé.
  String? uploadedId;

  Future<FileDataModel>? _uploadFuture;

  Future<FileDataModel> upladFile() async {
    return await AuthRepository.uplaodFile(file: file!);
  }

  /// Démarre l'upload en arrière-plan dès que [file] est défini, sans
  /// bloquer l'UI (ex: pendant que l'utilisateur remplit le reste du
  /// formulaire). Un nouvel appel (fichier remplacé) invalide le précédent.
  void startBackgroundUpload() {
    uploadedId = null;
    status.value = FileUploadStatus.uploading;

    final future = upladFile();
    _uploadFuture = future;

    future.then((result) {
      if (!identical(_uploadFuture, future)) return; // remplacé entre-temps
      uploadedId = result.data?.id;
      status.value = FileUploadStatus.uploaded;
    }).catchError((_) {
      if (!identical(_uploadFuture, future)) return;
      _uploadFuture = null;
      status.value = FileUploadStatus.error;
    });
  }

  /// Retourne l'ID du fichier uploadé : réutilise le résultat de l'upload
  /// en arrière-plan (déjà terminé ou encore en cours), ou relance un
  /// upload si aucun n'a été démarré ou si le précédent a échoué.
  Future<String?> ensureUploaded() async {
    if (uploadedId != null) return uploadedId;

    if (_uploadFuture != null) {
      final result = await _uploadFuture!;
      uploadedId = result.data?.id;
      status.value = FileUploadStatus.uploaded;
      return uploadedId;
    }

    status.value = FileUploadStatus.uploading;
    final result = await upladFile();
    uploadedId = result.data?.id;
    status.value = FileUploadStatus.uploaded;
    return uploadedId;
  }

  void dispose() {
    status.dispose();
  }
}
