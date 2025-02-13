// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crate_payement_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CratePayementRequestDtoImpl _$$CratePayementRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$CratePayementRequestDtoImpl(
      reservationId: json['reservationId'] as String,
      paymentMethod: json['paymentMethod'] as String,
      paymentAddress: json['paymentAddress'] as String,
    );

Map<String, dynamic> _$$CratePayementRequestDtoImplToJson(
        _$CratePayementRequestDtoImpl instance) =>
    <String, dynamic>{
      'reservationId': instance.reservationId,
      'paymentMethod': instance.paymentMethod,
      'paymentAddress': instance.paymentAddress,
    };
