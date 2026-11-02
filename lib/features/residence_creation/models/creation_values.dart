/// Référence choisie dans une liste (ville, commune).
class SelectedRef {
  const SelectedRef({required this.id, required this.label});

  final String id;
  final String label;
}

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
