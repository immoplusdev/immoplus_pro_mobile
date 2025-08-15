// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdrawal_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WithdrawalRequestDtoImpl _$$WithdrawalRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$WithdrawalRequestDtoImpl(
      amount: (json['amount'] as num).toInt(),
      currency: json['currency'] as String,
      phoneNumber: json['phoneNumber'] as String,
      operator: json['operator'] as String,
      status: json['status'] as String,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$WithdrawalRequestDtoImplToJson(
        _$WithdrawalRequestDtoImpl instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'currency': instance.currency,
      'phoneNumber': instance.phoneNumber,
      'operator': instance.operator,
      'status': instance.status,
      'note': instance.note,
    };
