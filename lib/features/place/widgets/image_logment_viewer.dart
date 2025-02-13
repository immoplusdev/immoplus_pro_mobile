import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageLogmentViewer extends StatelessWidget {
  ImageLogmentViewer({
    super.key,
    required this.tag,
    required this.imagePath,
  });
  final String
      imagePath; // Remplacez ceci par votre propre chemin d'accès à l'image
  final String tag;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
        ),
        body: Center(
          child: PhotoView(
            imageProvider: FileImage(
              File(imagePath),
            ),
            backgroundDecoration: BoxDecoration(
              color: Colors.black,
            ),
            loadingBuilder: (context, event) => Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
