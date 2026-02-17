import 'package:json_annotation/json_annotation.dart';

part 'geo_json_point.g.dart';

/// Représente un point GeoJSON conforme à la spec RFC 7946.
///
/// ⚠️ ATTENTION : [coordinates] est au format **[longitude, latitude]**,
/// PAS [lat, lng] ! C'est le standard GeoJSON.
///
/// Exemple JSON :
/// ```json
/// { "type": "Point", "coordinates": [-3.9628, 5.3364] }
/// ```
@JsonSerializable()
class GeoJsonPoint {
  /// Toujours "Point" pour un point GeoJSON.
  final String type;

  /// Coordonnées au format [longitude, latitude].
  final List<double> coordinates;

  const GeoJsonPoint({
    this.type = 'Point',
    required this.coordinates,
  });

  /// Crée un [GeoJsonPoint] à partir de latitude et longitude.
  ///
  /// Convertit automatiquement dans l'ordre GeoJSON [lng, lat].
  factory GeoJsonPoint.fromLatLng({
    required double latitude,
    required double longitude,
  }) {
    return GeoJsonPoint(coordinates: [longitude, latitude]);
  }

  /// Retourne la longitude (premier élément).
  double get longitude => coordinates.isNotEmpty ? coordinates[0] : 0;

  /// Retourne la latitude (second élément).
  double get latitude => coordinates.length > 1 ? coordinates[1] : 0;

  factory GeoJsonPoint.fromJson(Map<String, dynamic> json) =>
      _$GeoJsonPointFromJson(json);

  Map<String, dynamic> toJson() => _$GeoJsonPointToJson(this);
}
