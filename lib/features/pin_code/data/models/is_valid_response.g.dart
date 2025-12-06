// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'is_valid_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IsValidResponseImpl _$$IsValidResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$IsValidResponseImpl(
      data: IsValidData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$IsValidResponseImplToJson(
        _$IsValidResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

_$IsValidDataImpl _$$IsValidDataImplFromJson(Map<String, dynamic> json) =>
    _$IsValidDataImpl(
      isValid: json['isValid'] as bool,
    );

Map<String, dynamic> _$$IsValidDataImplToJson(_$IsValidDataImpl instance) =>
    <String, dynamic>{
      'isValid': instance.isValid,
    };
