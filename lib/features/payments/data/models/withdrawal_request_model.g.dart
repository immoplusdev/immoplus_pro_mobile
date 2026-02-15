// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'withdrawal_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WithdrawalRequestModelImpl _$$WithdrawalRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$WithdrawalRequestModelImpl(
      id: json['id'] as String? ?? '',
      owner: json['owner'] as String? ?? '',
      amount: json['amount'] == null ? 0.0 : parseDouble(json['amount']),
      currency: json['currency'] as String? ?? '',
      operator: json['operator'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      status: json['status'] as String?,
      note: json['note'] as String? ?? '',
      createdAt: _dateTimeFromJson(json['createdAt'] as String?),
      updatedAt: _dateTimeFromJson(json['updatedAt'] as String?),
      deletedAt: _dateTimeFromJson(json['deletedAt'] as String?),
    );

Map<String, dynamic> _$$WithdrawalRequestModelImplToJson(
        _$WithdrawalRequestModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner': instance.owner,
      'amount': instance.amount,
      'currency': instance.currency,
      'operator': instance.operator,
      'phoneNumber': instance.phoneNumber,
      'status': instance.status,
      'note': instance.note,
      'createdAt': _dateTimeToJson(instance.createdAt),
      'updatedAt': _dateTimeToJson(instance.updatedAt),
      'deletedAt': _dateTimeToJson(instance.deletedAt),
    };
