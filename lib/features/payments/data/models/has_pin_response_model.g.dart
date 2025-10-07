// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'has_pin_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HasPinResponseModelImpl _$$HasPinResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$HasPinResponseModelImpl(
      data: HasPinDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$HasPinResponseModelImplToJson(
        _$HasPinResponseModelImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

_$HasPinDataModelImpl _$$HasPinDataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$HasPinDataModelImpl(
      hasPin: json['hasPin'] as bool? ?? false,
    );

Map<String, dynamic> _$$HasPinDataModelImplToJson(
        _$HasPinDataModelImpl instance) =>
    <String, dynamic>{
      'hasPin': instance.hasPin,
    };
