import 'dart:io';

import 'package:immoplus_pro/features/create_residence/entity/image_upload_item.dart';
import 'package:immoplus_pro/features/residence_creation/models/residence_field_keys.dart';

/// Résumé de la résidence créée, affiché sur l'écran de confirmation.
class ResidenceRecap {
  const ResidenceRecap({
    required this.name,
    required this.propertyTypeLabel,
    required this.bedrooms,
    required this.nightlyPrice,
    this.coverPhoto,
  });

  final String name;
  final String propertyTypeLabel;
  final int bedrooms;
  final int nightlyPrice;
  final File? coverPhoto;

  /// Construit le résumé à partir des valeurs saisies dans le formulaire.
  factory ResidenceRecap.fromValues(Map<String, dynamic> values) {
    final type = values[ResidenceFieldKeys.propertyType] as String? ?? '';
    final composition =
        values[ResidenceFieldKeys.composition] as Map<String, int>? ?? const {};
    final photos =
        values[ResidenceFieldKeys.photos] as List<ImageUploadItem>? ?? const [];

    return ResidenceRecap(
      name: (values[ResidenceFieldKeys.name] as String? ?? '').trim(),
      // Les codes du catalogue sont des mots français en majuscules.
      propertyTypeLabel:
          type.isEmpty ? '' : '${type[0]}${type.substring(1).toLowerCase()}',
      bedrooms: composition['bedrooms'] ?? 0,
      nightlyPrice:
          (values[ResidenceFieldKeys.baseNightlyPrice] as num?)?.toInt() ?? 0,
      coverPhoto: photos.where((p) => p.isUploaded).firstOrNull?.file,
    );
  }
}
