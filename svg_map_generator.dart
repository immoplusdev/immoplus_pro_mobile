import 'dart:io';

void main() {
  final directory = Directory(
      './assets/svgs/icons/'); // Remplacez par le chemin de votre dossier SVG
  final outputFilePath =
      './lib/svgs_icons.dart'; // Chemin de sortie du fichier Dart

  final map = <String, String>{};

  if (directory.existsSync()) {
    directory.listSync().forEach((entity) {
      if (entity is File && entity.path.toLowerCase().endsWith('.svg')) {
        final fileName = entity.path.split('/').last;
        final fileNameWithoutExtension = fileName.split('.').first;
        map[fileNameWithoutExtension] = entity.path;
      }
    });

    _generateDartFile(outputFilePath, map);
    print('Fichier Dart généré avec succès à : $outputFilePath');
  } else {
    print('Le dossier spécifié n\'existe pas.');
  }
}

void _generateDartFile(String outputPath, Map<String, String> map) {
  final buffer = StringBuffer();

  buffer.writeln("class SVGMap {");
  buffer.writeln("  static Map<String, String> map = {");

  map.forEach((key, value) {
    buffer.writeln("    '$key': '$value',");
  });

  buffer.writeln("  };");
  buffer.writeln("}");

  File(outputPath).writeAsStringSync(buffer.toString());
}
