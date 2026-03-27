// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_change_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RequestContactChangeBodyImpl _$$RequestContactChangeBodyImplFromJson(
        Map<String, dynamic> json) =>
    _$RequestContactChangeBodyImpl(
      type: json['type'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$$RequestContactChangeBodyImplToJson(
        _$RequestContactChangeBodyImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
    };

_$ConfirmContactChangeBodyImpl _$$ConfirmContactChangeBodyImplFromJson(
        Map<String, dynamic> json) =>
    _$ConfirmContactChangeBodyImpl(
      type: json['type'] as String,
      otp: json['otp'] as String,
    );

Map<String, dynamic> _$$ConfirmContactChangeBodyImplToJson(
        _$ConfirmContactChangeBodyImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'otp': instance.otp,
    };

_$ContactChangeResponseImpl _$$ContactChangeResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ContactChangeResponseImpl(
      data: ContactChangeResponseData.fromJson(
          json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ContactChangeResponseImplToJson(
        _$ContactChangeResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

_$ContactChangeResponseDataImpl _$$ContactChangeResponseDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ContactChangeResponseDataImpl(
      message: json['message'] as String,
    );

Map<String, dynamic> _$$ContactChangeResponseDataImplToJson(
        _$ContactChangeResponseDataImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
    };
