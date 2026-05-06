import 'dart:io';
import 'package:uuid/uuid.dart';

enum UploadStatus {
  uploading,
  success,
  failed,
}

class ImageUploadItem {
  final String id;
  final File? file;
  UploadStatus status;
  String? uploadedId;
  String? errorMessage;

  ImageUploadItem({
    String? id,
    this.file,
    required this.status,
    this.uploadedId,
    this.errorMessage,
  }) : id = id ?? const Uuid().v4();

  ImageUploadItem copyWith({
    UploadStatus? status,
    String? uploadedId,
    String? errorMessage,
  }) {
    return ImageUploadItem(
      id: id,
      file: file,
      status: status ?? this.status,
      uploadedId: uploadedId ?? this.uploadedId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isLocal => file != null;
  bool get isOnLine => uploadedId != null;

  bool get isUploaded => status == UploadStatus.success && isOnLine;
  bool get canUploadToServer => status == UploadStatus.uploading && isLocal;
}
