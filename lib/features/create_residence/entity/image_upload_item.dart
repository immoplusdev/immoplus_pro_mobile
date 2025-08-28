import 'dart:io';

enum UploadStatus {
  uploading,
  success,
  failed,
}

class ImageUploadItem {
  final String id = DateTime.now().microsecondsSinceEpoch.toString();
  final File? file;
  UploadStatus status;
  String? uploadedId;
  String? errorMessage;

  ImageUploadItem({
    this.file,
    required this.status,
    this.uploadedId,
    this.errorMessage,
  });

  ImageUploadItem copyWith({
    UploadStatus? status,
    String? uploadedId,
    String? errorMessage,
  }) {
    return ImageUploadItem(
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
