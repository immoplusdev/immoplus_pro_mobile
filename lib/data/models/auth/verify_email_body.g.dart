// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_email_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyEmailBody _$VerifyEmailBodyFromJson(Map<String, dynamic> json) =>
    VerifyEmailBody(
      email: json['email'] as String,
      otp: json['otp'] as String,
    );

Map<String, dynamic> _$VerifyEmailBodyToJson(VerifyEmailBody instance) =>
    <String, dynamic>{
      'email': instance.email,
      'otp': instance.otp,
    };
