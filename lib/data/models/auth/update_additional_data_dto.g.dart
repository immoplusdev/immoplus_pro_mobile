// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_additional_data_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UpdateAdditionalDataDtoImpl _$$UpdateAdditionalDataDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$UpdateAdditionalDataDtoImpl(
      lieuNaissance: json['lieuNaissance'] as String?,
      activite: json['activite'] as String?,
      photoIdentite: json['photoIdentite'] as String?,
      pieceIdentite: json['pieceIdentite'] as String?,
      pieceIdentiteVerso: json['pieceIdentiteVerso'] as String?,
      nomEntreprise: json['nomEntreprise'] as String?,
      emailEntreprise: json['emailEntreprise'] as String?,
      registreCommerce: json['registreCommerce'] as String?,
      numeroContribuable: json['numeroContribuable'] as String?,
      typeEntreprise: json['typeEntreprise'] as String?,
    );

Map<String, dynamic> _$$UpdateAdditionalDataDtoImplToJson(
        _$UpdateAdditionalDataDtoImpl instance) =>
    <String, dynamic>{
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
