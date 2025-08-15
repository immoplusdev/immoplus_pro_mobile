// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletResponseModelImpl _$$WalletResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$WalletResponseModelImpl(
      data: json['data'] == null
          ? null
          : WalletModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$WalletResponseModelImplToJson(
        _$WalletResponseModelImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
    };
