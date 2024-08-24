import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

class FileUploader {
  final Dio dio;

  FileUploader(this.dio);

  Future<void> uploadImages(List<File> images, String url) async {
    FormData formData = FormData();

    // Ajouter chaque image à la FormData
    for (var i = 0; i < images.length; i++) {
      String fileName = path.basename(images[i].path);
      formData.files.add(MapEntry(
        "images",
        await MultipartFile.fromFile(images[i].path, filename: fileName),
      ));
    }

    // Faire une requête POST pour envoyer les images
    Response response = await dio.post(
      url,
      data: formData,
      onSendProgress: (int sent, int total) {
        double progress = sent / total;
        print("Progress for images: ${progress * 100}%");
      },
    );

    print("Response status: ${response.statusCode}");
    print("Response data: ${response.data}");
  }

  Future<void> uploadVideo(File video, String url) async {
    String fileName = path.basename(video.path);
    FormData formData = FormData.fromMap({
      "video": await MultipartFile.fromFile(video.path, filename: fileName),
    });

    // Faire une requête POST pour envoyer le vidéo
    Response response = await dio.post(
      url,
      data: formData,
      onSendProgress: (int sent, int total) {
        double progress = sent / total;
        print("Progress for video: ${progress * 100}%");
      },
    );

    print("Response status: ${response.statusCode}");
    print("Response data: ${response.data}");
  }
}
