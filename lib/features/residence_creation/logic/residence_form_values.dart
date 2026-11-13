import 'package:immoplus_pro/features/create_residence/entity/image_upload_item.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_values.dart';
import 'package:immoplus_pro/features/residence_creation/models/residence_field_keys.dart';

/// Valeurs du formulaire : valeurs par défaut de la configuration, ou valeurs
/// d'une résidence existante (édition).
abstract class ResidenceFormValues {
  /// Valeurs par défaut issues de la configuration.
  static Map<String, dynamic> initial(CreationFlow flow) {
    final values = <String, dynamic>{};
    for (final field in flow.allFields) {
      values[field.key] = switch (field.type) {
        CreationFieldType.counters => {
            for (final item in field.items) item.key: item.min,
          },
        CreationFieldType.bottomSheetCatalog => <String, int>{},
        CreationFieldType.multiSelectCatalog => <String>[],
        CreationFieldType.mediaUpload =>
          field.key == ResidenceFieldKeys.video ? null : <ImageUploadItem>[],
        CreationFieldType.toggle => field.defaultValue as bool? ?? false,
        _ => field.defaultValue,
      };
    }
    return values;
  }

  /// Préremplit le formulaire avec la réponse brute de `GET /residences/{id}`.
  /// Les résidences créées avant le nouveau format n'ont pas tous les champs
  /// (`propertyTypeCode`, `capacity`...) : on retombe alors sur l'ancien
  /// format, puis sur la valeur par défaut de la configuration.
  static Map<String, dynamic> fromResidence(
    CreationFlow flow,
    Map<String, dynamic> json,
  ) {
    final values = initial(flow);

    for (final field in flow.allFields) {
      final value = _valueFor(field, json);
      if (value != null) values[field.key] = value;
    }
    return values;
  }

  static Object? _valueFor(CreationField field, Map<String, dynamic> json) {
    switch (field.key) {
      case ResidenceFieldKeys.name:
        return json['nom'];
      case ResidenceFieldKeys.propertyType:
        final code = json['propertyTypeCode'] as String? ??
            (json['typeResidence'] as String?)?.toUpperCase();
        return (code == null || code.isEmpty) ? null : code;
      case ResidenceFieldKeys.composition:
        return _counters(field, json['capacity'], json['nombreMaxOccupants']);
      case ResidenceFieldKeys.roomsAndBeds:
        return _intMap(json['roomCounts']);
      case ResidenceFieldKeys.location:
        return _place(json['adresse'], json['position']);
      case ResidenceFieldKeys.amenityCodes:
        final codes = json['amenityCodes'];
        return codes is List ? codes.whereType<String>().toList() : null;
      case ResidenceFieldKeys.photos:
        final images = json['images'];
        if (images is! List) return null;
        return [
          for (final id in images.whereType<String>())
            ImageUploadItem(status: UploadStatus.success, uploadedId: id),
        ];
      case ResidenceFieldKeys.video:
        return json['video'];
      case 'description':
        return json['description'];
      case 'checkInFrom':
        return _time(json['heureEntree']);
      case 'checkOutBefore':
        return _time(json['heureDepart']);
      case 'petsAllowed':
        return json['animauxAutorises'];
      case 'partiesAllowed':
        return json['fetesAutorises'];
      case ResidenceFieldKeys.baseNightlyPrice:
        return json['prixReservation'];
      case 'minNights':
        return json['dureeMinSejour'];
      case 'maxNights':
        return json['dureeMaxSejour'];
      case 'weekendPricingEnabled':
        return json['weekendNightlyPrice'] != null;
      default:
        return json[field.key];
    }
  }

  /// `capacity` : un entier par compteur ; le nombre d'occupants vient de
  /// l'ancien champ `nombreMaxOccupants` quand `capacity` est absent.
  static Map<String, int> _counters(
    CreationField field,
    Object? capacity,
    Object? legacyMaxGuests,
  ) {
    final source = capacity is Map ? capacity : const {};
    return {
      for (final item in field.items)
        item.key: _clamp(
          (source[item.key] as num?)?.toInt() ??
              (item.key == 'maxGuests'
                  ? (legacyMaxGuests as num?)?.toInt()
                  : null) ??
              item.min,
          item,
        ),
    };
  }

  static int _clamp(int value, CounterItem item) {
    final max = item.max;
    return value.clamp(item.min, max ?? (value < item.min ? item.min : value));
  }

  static Map<String, int>? _intMap(Object? raw) => raw is Map
      ? {
          for (final e in raw.entries)
            if (e.value is num) '${e.key}': (e.value as num).toInt(),
        }
      : null;

  static PlaceSelection? _place(Object? address, Object? position) {
    final point = _point(position);
    if (address is! String || address.trim().isEmpty || point == null) {
      return null;
    }
    return PlaceSelection(address: address, position: point);
  }

  static GeoPoint? _point(Object? raw) {
    final coordinates = raw is Map ? raw['coordinates'] : null;
    if (coordinates is! List || coordinates.length < 2) return null;
    // GeoJSON : [longitude, latitude].
    return GeoPoint(
      latitude: (coordinates[1] as num).toDouble(),
      longitude: (coordinates[0] as num).toDouble(),
    );
  }

  /// `14:00:00` -> `14:00`.
  static String? _time(Object? raw) {
    final value = raw as String?;
    if (value == null || value.length < 5) return null;
    return value.substring(0, 5);
  }
}
