// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motifs_echec_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MotifsEchecResponseImpl _$$MotifsEchecResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$MotifsEchecResponseImpl(
      data: MotifsEchecData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$MotifsEchecResponseImplToJson(
        _$MotifsEchecResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

_$MotifsEchecDataImpl _$$MotifsEchecDataImplFromJson(
        Map<String, dynamic> json) =>
    _$MotifsEchecDataImpl(
      reservationId: json['reservationId'] as String,
      status: json['status'] as String?,
      actorInterroge: json['actorInterroge'] as String?,
      dejaRepondu: json['dejaRepondu'] as bool? ?? false,
      motifs: (json['motifs'] as List<dynamic>?)
              ?.map((e) => MotifItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$MotifsEchecDataImplToJson(
        _$MotifsEchecDataImpl instance) =>
    <String, dynamic>{
      'reservationId': instance.reservationId,
      'status': instance.status,
      'actorInterroge': instance.actorInterroge,
      'dejaRepondu': instance.dejaRepondu,
      'motifs': instance.motifs,
    };
