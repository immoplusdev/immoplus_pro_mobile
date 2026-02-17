// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_json_point.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoJsonPoint _$GeoJsonPointFromJson(Map<String, dynamic> json) => GeoJsonPoint(
      type: json['type'] as String? ?? 'Point',
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$GeoJsonPointToJson(GeoJsonPoint instance) =>
    <String, dynamic>{
      'type': instance.type,
      'coordinates': instance.coordinates,
    };
