import 'package:immoplus_pro/features/create_residence/entity/image_upload_item.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_values.dart';
import 'package:immoplus_pro/features/residence_creation/models/residence_field_keys.dart';

/// Construit le payload de `POST /residences` à partir des valeurs saisies.
/// Un champ masqué par sa condition `visibleWhen` est envoyé à `null`.
abstract class ResidencePayloadBuilder {
  static Map<String, dynamic> build(
    CreationFlow flow,
    Map<String, dynamic> values,
  ) {
    final payload = <String, dynamic>{};

    for (final field in flow.allFields) {
      final value = field.isVisible(values) ? values[field.key] : null;

      if (field.type == CreationFieldType.googlePlacesAutocomplete) {
        _putLocation(payload, field, value as PlaceSelection?);
        continue;
      }

      switch (field.key) {
        case ResidenceFieldKeys.name:
          payload['nom'] = _trimmed(value);
        case ResidenceFieldKeys.propertyType:
          payload['propertyType'] = value;
          payload['typeResidence'] = (value as String?)?.toLowerCase();
        case ResidenceFieldKeys.composition:
          payload['capacity'] = value;
        case ResidenceFieldKeys.roomsAndBeds:
          payload['roomCounts'] = {
            for (final e in (value as Map<String, int>? ?? {}).entries)
              if (e.value > 0) e.key: e.value,
          };
        case ResidenceFieldKeys.photos:
          final ids = _uploadedIds(value);
          payload['images'] = ids;
          payload['miniature'] = ids.isEmpty ? null : ids.first;
        case ResidenceFieldKeys.amenityCodes:
          payload['amenityCodes'] = (value as Iterable?)?.toList() ?? [];
        default:
          payload[field.key] = value is String ? _trimmed(value) : value;
      }
    }
    return payload;
  }

  /// Une sortie par clé de `outputs` : `address` -> texte, `position` ->
  /// GeoJSON.
  static void _putLocation(
    Map<String, dynamic> payload,
    CreationField field,
    PlaceSelection? place,
  ) {
    final address = field.outputs['address'];
    final position = field.outputs['position'];
    if (address != null) payload[address] = place?.address.trim();
    if (position != null) payload[position] = place?.position.toGeoJson();
  }

  static String? _trimmed(Object? value) => (value as String?)?.trim();

  static List<String> _uploadedIds(Object? value) => [
        for (final item in value as List<ImageUploadItem>? ?? const [])
          if (item.isUploaded) item.uploadedId!,
      ];
}
