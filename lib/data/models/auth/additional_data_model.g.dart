// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'additional_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdditionalDataModelImpl _$$AdditionalDataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AdditionalDataModelImpl(
      id: json['id'] as String?,
      user: json['user'] as String?,
      lieuNaissance: json['lieuNaissance'] as String?,
      activite: json['activite'] as String?,
      photoIdentiteId:
          _fileIdFromJson(_readPhotoIdentite(json, 'photoIdentiteId')),
      pieceIdentiteId:
          _fileIdFromJson(_readPieceIdentite(json, 'pieceIdentiteId')),
      pieceIdentiteVersoId: _fileIdFromJson(
          _readPieceIdentiteVerso(json, 'pieceIdentiteVersoId')),
      nomEntreprise: json['nomEntreprise'] as String?,
      registreCommerceId:
          _fileIdFromJson(_readRegistreCommerce(json, 'registreCommerceId')),
      emailEntreprise: json['emailEntreprise'] as String?,
      numeroContribuable: _stringFromJson(json['numeroContribuable']),
      typeEntreprise: json['typeEntreprise'] as String?,
    );

Map<String, dynamic> _$$AdditionalDataModelImplToJson(
        _$AdditionalDataModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'lieuNaissance': instance.lieuNaissance,
      'activite': instance.activite,
      'photoIdentiteId': instance.photoIdentiteId,
      'pieceIdentiteId': instance.pieceIdentiteId,
      'pieceIdentiteVersoId': instance.pieceIdentiteVersoId,
      'nomEntreprise': instance.nomEntreprise,
      'registreCommerceId': instance.registreCommerceId,
      'emailEntreprise': instance.emailEntreprise,
      'numeroContribuable': instance.numeroContribuable,
      'typeEntreprise': instance.typeEntreprise,
    };
