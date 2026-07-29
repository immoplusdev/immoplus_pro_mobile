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

Map<String, dynamic> _$$UpdateAdditionalDataResultImplToJson(
        _$UpdateAdditionalDataResultImpl instance) =>
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
