// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletModelImpl _$$WalletModelImplFromJson(Map<String, dynamic> json) =>
    _$WalletModelImpl(
      id: json['id'] as String? ?? '',
      availableBalance: json['availableBalance'] == null
          ? 0
          : _toInt(json['availableBalance']),
      pendingBalance:
          json['pendingBalance'] == null ? 0 : _toInt(json['pendingBalance']),
      currency: json['currency'] as String? ?? 'XOF',
      createdAt: _fromJsonDate(json['createdAt'] as String?),
      updatedAt: _fromJsonDate(json['updatedAt'] as String?),
    );

Map<String, dynamic> _$$WalletModelImplToJson(_$WalletModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'availableBalance': _fromInt(instance.availableBalance),
      'pendingBalance': _fromInt(instance.pendingBalance),
      'currency': instance.currency,
      'createdAt': _toJsonDate(instance.createdAt),
      'updatedAt': _toJsonDate(instance.updatedAt),
    };
