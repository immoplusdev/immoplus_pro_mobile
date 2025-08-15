// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionResponseModelImpl _$$TransactionResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionResponseModelImpl(
      data: json['data'] == null
          ? null
          : TransactionModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TransactionResponseModelImplToJson(
        _$TransactionResponseModelImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
