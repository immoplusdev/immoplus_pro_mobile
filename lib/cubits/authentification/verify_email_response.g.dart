// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_email_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VerifyEmailResponseImpl _$$VerifyEmailResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$VerifyEmailResponseImpl(
      data: VerifyEmailData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$VerifyEmailResponseImplToJson(
        _$VerifyEmailResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

_$VerifyEmailDataImpl _$$VerifyEmailDataImplFromJson(
        Map<String, dynamic> json) =>
    _$VerifyEmailDataImpl(
      success: json['success'] as bool? ?? false,
      token: json['token'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
    );

Map<String, dynamic> _$$VerifyEmailDataImplToJson(
        _$VerifyEmailDataImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'token': instance.token,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
    };
