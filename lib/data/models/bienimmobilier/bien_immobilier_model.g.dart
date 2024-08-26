// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bien_immobilier_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BienImmobilierModelImpl _$$BienImmobilierModelImplFromJson(
        Map<String, dynamic> json) =>
    _$BienImmobilierModelImpl(
      id: json['id'] as String? ?? '',
      nom: json['nom'] as String? ?? 'Unknown Name',
      typeBienImmobilier:
          json['typeBienImmobilier'] as String? ?? 'Unknown Type',
      description: json['description'] as String? ?? 'No Description',
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
      adresse: json['adresse'] as String? ?? 'Unknown Address',
      position: json['position'] == null
          ? const PositionModel()
          : PositionModel.fromJson(json['position'] as Map<String, dynamic>),
      statusValidation:
          json['statusValidation'] as String? ?? 'pending_validation',
      prix: (json['prix'] as num?)?.toInt() ?? 0,
      featured: json['featured'] as bool? ?? false,
      bienImmobilierDisponible:
          json['bienImmobilierDisponible'] as bool? ?? true,
      nombreMaxOccupants: (json['nombreMaxOccupants'] as num?)?.toInt() ?? 1,
      animauxAutorises: json['animauxAutorises'] as bool? ?? false,
      fetesAutorises: json['fetesAutorises'] as bool? ?? false,
      reglesSupplementaires:
          json['reglesSupplementaires'] as String? ?? 'No Additional Rules',
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
      'statusValidation': instance.statusValidation,
      'prix': instance.prix,
      'featured': instance.featured,
      'bienImmobilierDisponible': instance.bienImmobilierDisponible,
      'nombreMaxOccupants': instance.nombreMaxOccupants,
      'animauxAutorises': instance.animauxAutorises,
      'fetesAutorises': instance.fetesAutorises,
      'reglesSupplementaires': instance.reglesSupplementaires,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'miniatureId': instance.miniatureId,
    };
