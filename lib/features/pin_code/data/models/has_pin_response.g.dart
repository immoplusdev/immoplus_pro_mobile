// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'has_pin_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HasPinResponseImpl _$$HasPinResponseImplFromJson(Map<String, dynamic> json) =>
    _$HasPinResponseImpl(
      data: HasPinData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$HasPinResponseImplToJson(
        _$HasPinResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

_$HasPinDataImpl _$$HasPinDataImplFromJson(Map<String, dynamic> json) =>
    _$HasPinDataImpl(
      hasPin: json['hasPin'] as bool,
    );

Map<String, dynamic> _$$HasPinDataImplToJson(_$HasPinDataImpl instance) =>
    <String, dynamic>{
      'hasPin': instance.hasPin,
    };
