// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_additional_data_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateAdditionalDataResponseModelImpl
    _$$UpdateAdditionalDataResponseModelImplFromJson(
            Map<String, dynamic> json) =>
        _$UpdateAdditionalDataResponseModelImpl(
          data: UpdateAdditionalDataResult.fromJson(
              json['data'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$$UpdateAdditionalDataResponseModelImplToJson(
        _$UpdateAdditionalDataResponseModelImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

_$UpdateAdditionalDataResultImpl _$$UpdateAdditionalDataResultImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateAdditionalDataResultImpl(
      id: json['id'] as String?,
      user: json['user'] as String?,
      lieuNaissance: json['lieuNaissance'] as String?,
      activite: json['activite'] as String?,
      photoIdentite: _fileIdFromJson(json['photoIdentite']),
      pieceIdentite: _fileIdFromJson(json['pieceIdentite']),
      pieceIdentiteVerso: _fileIdFromJson(json['pieceIdentiteVerso']),
      nomEntreprise: json['nomEntreprise'] as String?,
      emailEntreprise: json['emailEntreprise'] as String?,
      registreCommerce: _fileIdFromJson(json['registreCommerce']),
      numeroContribuable: _stringFromJson(json['numeroContribuable']),
      typeEntreprise: json['typeEntreprise'] as String?,
    );

Map<String, dynamic> _$$UpdateAdditionalDataResultImplToJson(
        _$UpdateAdditionalDataResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'lieuNaissance': instance.lieuNaissance,
      'activite': instance.activite,
      'photoIdentite': instance.photoIdentite,
      'pieceIdentite': instance.pieceIdentite,
      'pieceIdentiteVerso': instance.pieceIdentiteVerso,
      'nomEntreprise': instance.nomEntreprise,
      'emailEntreprise': instance.emailEntreprise,
      'registreCommerce': instance.registreCommerce,
      'numeroContribuable': instance.numeroContribuable,
      'typeEntreprise': instance.typeEntreprise,
    };
