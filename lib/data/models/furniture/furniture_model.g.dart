// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'furniture_model.dart';


_$FurnitureModelImpl _$$FurnitureModelImplFromJson(Map<String, dynamic> json) =>
    _$FurnitureModelImpl(
      id: json['id'] as String,
      owner: json['owner'] as String,
      titre: json['titre'] as String,
      description: json['description'] as String,
      adresse: json['adresse'] as String,
      prix: (json['prix'] as num).toInt(),
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
      viewsCount: (json['viewsCount'] as num?)?.toInt() ?? 0,
      status: $enumDecodeNullable(_$FurnitureStatusEnumMap, json['status']) ??
          FurnitureStatus.active,
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String?,
    );

Map<String, dynamic> _$$FurnitureModelImplToJson(
        _$FurnitureModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner': instance.owner,
      'titre': instance.titre,
      'description': instance.description,
      'adresse': instance.adresse,
      'prix': instance.prix,
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
      'viewsCount': instance.viewsCount,
      'status': _$FurnitureStatusEnumMap[instance.status]!,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'createdBy': instance.createdBy,
    };

const _$FurnitureStatusEnumMap = {
  FurnitureStatus.active: 'active',
  FurnitureStatus.inactive: 'inactive',
  FurnitureStatus.deleted: 'deleted',
};
