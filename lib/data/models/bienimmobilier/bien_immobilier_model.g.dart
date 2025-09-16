// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bien_immobilier_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BienImmobilierModelImpl _$$BienImmobilierModelImplFromJson(
        Map<String, dynamic> json) =>
    _$BienImmobilierModelImpl(
      id: json['id'] as String? ?? '',
      nom: json['nom'] as String? ?? '',
      typeBienImmobilier: json['typeBienImmobilier'] as String? ?? '',
      description: json['description'] as String? ?? '',
      amentities: (json['amentities'] as List<dynamic>?)
              ?.map((e) => CommoditeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      adresse: json['adresse'] as String? ?? '',
      position: json['position'] == null
          ? const PositionModel()
          : PositionModel.fromJson(json['position'] as Map<String, dynamic>),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      statusValidation: json['statusValidation'] as String? ?? '',
      prix: (json['prix'] as num?)?.toInt() ?? 0,
      aLouer: json['aLouer'] as bool? ?? false,
      typeLocation: json['typeLocation'] as String? ?? '',
      pieces: (json['pieces'] as List<dynamic>?)
              ?.map((e) => PieceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      bienImmobilierDisponible:
          json['bienImmobilierDisponible'] as bool? ?? false,
      nombreMaxOccupants: (json['nombreMaxOccupants'] as num?)?.toInt(),
      fetesAutorises: json['fetesAutorises'] as bool?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      miniatureId: json['miniatureId'] as String? ?? '',
      miniature: json['miniature'] as String?,
      video: json['video'] as String?,
      ville: json['ville'] as String? ?? '',
      commune: json['commune'] as String? ?? '',
      featured: json['featured'] as bool? ?? false,
    );

Map<String, dynamic> _$$BienImmobilierModelImplToJson(
        _$BienImmobilierModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nom': instance.nom,
      'typeBienImmobilier': instance.typeBienImmobilier,
      'description': instance.description,
      'amentities': instance.amentities,
      'tags': instance.tags,
      'images': instance.images,
      'adresse': instance.adresse,
      'position': instance.position,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'statusValidation': instance.statusValidation,
      'prix': instance.prix,
      'aLouer': instance.aLouer,
      'typeLocation': instance.typeLocation,
      'pieces': instance.pieces,
      'bienImmobilierDisponible': instance.bienImmobilierDisponible,
      'nombreMaxOccupants': instance.nombreMaxOccupants,
      'fetesAutorises': instance.fetesAutorises,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'miniatureId': instance.miniatureId,
      'miniature': instance.miniature,
      'video': instance.video,
      'ville': instance.ville,
      'commune': instance.commune,
      'featured': instance.featured,
    };
