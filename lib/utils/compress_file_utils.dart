import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:immoplus_pro/core/logger/immo_logger.dart';

class CompressFileUtils {
  static const double MAX_SIZE_IMG = 5; // en Mo
  static const double MIN_QUALITY_IMG = 40; // de 0 à 100

  /// Compress file when size is over [MAX_SIZE_IMG]
  /// Return File
  static Future<XFile> compressFileIfNeeded(XFile image) async {
    try {
      double fileSizeInMB = await getSizeInMBFile(image);

      if (fileSizeInMB > MAX_SIZE_IMG) {
        ImmoLogger.d(
            'L\'image ${image.path} est superieur à $MAX_SIZE_IMG MB.');
        final imgCompres = await _compressFile(image);
        return imgCompres;
      } else {
        ImmoLogger.d(
            'L\'image ${image.path} (${fileSizeInMB.toStringAsFixed(2)} MB) est dans la limite autorisée.');
        return image;
      }
    } catch (e) {
      return image;
    }
  }

  static Future<XFile> _compressFile(XFile file, {int quality = 80}) async {
    ImmoLogger.d(
        "-----------------Compression quality : $quality-------------");
    final filePath = file.path;
    final lastIndex = filePath.lastIndexOf('.');
    final extension = filePath.substring(lastIndex);
    final fileName = filePath.substring(0, lastIndex);
    final outPath = '${fileName}_out$extension';
    ImmoLogger.d("-----------------fichier de sortie : $outPath-------------");

    try {
      var result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        quality: quality,
      );

      if (result != null) {
        final size = await getSizeInMBFile(result);
        if (size > MAX_SIZE_IMG && quality >= MIN_QUALITY_IMG) {
          final newQuality = quality - 10;
          return await _compressFile(file, quality: newQuality);
        }
        return result;
      } else {
        throw "Une erreur est survenue au niveau de la compression";
      }
    } catch (e) {
      ImmoLogger.d(e.toString());
      return file;
    }
  }

  /// Return the size of the file in MB
  static Future<double> getSizeInMBFile(XFile image) async {
    File file = File(image.path);
    int fileSizeInBytes = await file.length();
    double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
    ImmoLogger.d("taille en Mo : $fileSizeInMB");
    return fileSizeInMB;
  }
}
