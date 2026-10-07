// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motif_echec_reponse_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MotifEchecReponseModelImpl _$$MotifEchecReponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MotifEchecReponseModelImpl(
      data:
          MotifEchecReponseData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$MotifEchecReponseModelImplToJson(
        _$MotifEchecReponseModelImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

_$MotifEchecReponseDataImpl _$$MotifEchecReponseDataImplFromJson(
        Map<String, dynamic> json) =>
    _$MotifEchecReponseDataImpl(
      actor: json['actor'] as String?,
      status: json['status'] as String?,
      reasonCode: json['reasonCode'] as String,
      comment: json['comment'] as String?,
      respondedAt: json['respondedAt'] == null
          ? null
          : DateTime.parse(json['respondedAt'] as String),
    );

Map<String, dynamic> _$$MotifEchecReponseDataImplToJson(
        _$MotifEchecReponseDataImpl instance) =>
    <String, dynamic>{
      'actor': instance.actor,
      'status': instance.status,
      'reasonCode': instance.reasonCode,
      'comment': instance.comment,
      'respondedAt': instance.respondedAt?.toIso8601String(),
    };
