// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdraw_booking_history_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WithdrawBookingHistoryDtoImpl _$$WithdrawBookingHistoryDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$WithdrawBookingHistoryDtoImpl(
      montantNonRetire: (json['montantNonRetire'] as num?)?.toInt() ?? 0,
      montantRetire: (json['montantRetire'] as num?)?.toInt() ?? 0,
      montantTotal: (json['montantTotal'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$WithdrawBookingHistoryDtoImplToJson(
        _$WithdrawBookingHistoryDtoImpl instance) =>
    <String, dynamic>{
      'montantNonRetire': instance.montantNonRetire,
      'montantRetire': instance.montantRetire,
      'montantTotal': instance.montantTotal,
    };
