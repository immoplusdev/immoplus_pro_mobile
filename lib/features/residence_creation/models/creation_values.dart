/// Point GPS choisi sur la carte.
class GeoPoint {
  const GeoPoint({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  /// GeoJSON : l'ordre attendu par l'API est `[longitude, latitude]`.
  Map<String, dynamic> toGeoJson() => {
        'type': 'Point',
        'coordinates': [longitude, latitude],
      };
}

/// Adresse choisie dans les suggestions Google : le texte affiché et le
/// point GPS correspondant.
class PlaceSelection {
  const PlaceSelection({required this.address, required this.position});

  final String address;
  final GeoPoint position;
}

/// Résultat de `POST /residences`.
class CreatedResidence {
  const CreatedResidence({
    required this.id,
    required this.statusValidation,
    required this.residenceDisponible,
  });

  final String id;
  final String? statusValidation;
  final bool residenceDisponible;

  factory CreatedResidence.fromJson(Map<String, dynamic> json) =>
      CreatedResidence(
        id: json['id'] as String,
        statusValidation: json['statusValidation'] as String?,
        residenceDisponible: json['residenceDisponible'] as bool? ?? false,
      );
}
