// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'furniture_creation_model.dart';


_$FurnitureCreationModelImpl _$$FurnitureCreationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FurnitureCreationModelImpl(
      titre: json['titre'] as String,
      description: json['description'] as String,
      prix: (json['prix'] as num).toInt(),
      adresse: json['adresse'] as String,
      ville: json['ville'] as String?,
      commune: json['commune'] as String?,
      position: json['position'] == null
          ? null
          : GeoJsonPoint.fromJson(json['position'] as Map<String, dynamic>),
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      video: json['video'] as String?,
      type: json['type'] as String?,
      category: json['category'] as String?,
      etat: json['etat'] as String?,
      status: $enumDecodeNullable(_$FurnitureStatusEnumMap, json['status']) ??
          FurnitureStatus.active,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$FurnitureCreationModelImplToJson(
        _$FurnitureCreationModelImpl instance) =>
    <String, dynamic>{
      'titre': instance.titre,
      'description': instance.description,
      'prix': instance.prix,
      'adresse': instance.adresse,
      'ville': instance.ville,
      'commune': instance.commune,
      'position': instance.position,
      'lat': instance.lat,
      'lng': instance.lng,
      'images': instance.images,
      'video': instance.video,
      'type': instance.type,
      'category': instance.category,
      'etat': instance.etat,
      'status': _$FurnitureStatusEnumMap[instance.status],
      'metadata': instance.metadata,
    };

const _$FurnitureStatusEnumMap = {
  FurnitureStatus.active: 'active',
  FurnitureStatus.inactive: 'inactive',
  FurnitureStatus.deleted: 'deleted',
};
