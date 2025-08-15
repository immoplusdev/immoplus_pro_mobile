// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionModelImpl _$$TransactionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionModelImpl(
      id: json['id'] as String? ?? '',
      owner: json['owner'] as String? ?? '',
      amount: json['amount'] == null ? 0.0 : parseDouble(json['amount']),
      currency: json['currency'] as String? ?? '',
      reference: json['reference'] as String? ?? '',
      type: json['type'] as String? ?? '',
      note: json['note'] as String? ?? '',
      operator: json['operator'] as String? ?? '',
      source: json['source'] as String? ?? '',
      sourceId: json['sourceId'] as String? ?? '',
      createdAt: _dateTimeFromJson(json['createdAt'] as String?),
      updatedAt: _dateTimeFromJson(json['updatedAt'] as String?),
      deletedAt: _dateTimeFromJson(json['deletedAt'] as String?),
      createdBy: json['createdBy'] as String? ?? '',
      releaseDate: _dateTimeFromJson(json['releaseDate'] as String?),
      isRealeased: json['isRealeased'] as bool? ?? false,
      releasedAt: _dateTimeFromJson(json['releasedAt'] as String?),
    );

Map<String, dynamic> _$$TransactionModelImplToJson(
        _$TransactionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner': instance.owner,
      'amount': instance.amount,
      'currency': instance.currency,
      'reference': instance.reference,
      'type': instance.type,
      'note': instance.note,
      'operator': instance.operator,
      'source': instance.source,
      'sourceId': instance.sourceId,
      'createdAt': _dateTimeToJson(instance.createdAt),
      'updatedAt': _dateTimeToJson(instance.updatedAt),
      'deletedAt': _dateTimeToJson(instance.deletedAt),
      'createdBy': instance.createdBy,
      'releaseDate': _dateTimeToJson(instance.releaseDate),
      'isRealeased': instance.isRealeased,
      'releasedAt': _dateTimeToJson(instance.releasedAt),
    };
