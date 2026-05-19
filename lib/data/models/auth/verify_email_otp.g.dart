// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_email_otp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyEmailOtp _$VerifyEmailOtpFromJson(Map<String, dynamic> json) =>
    VerifyEmailOtp(
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      otp: json['otp'] as String,
    );

Map<String, dynamic> _$VerifyEmailOtpToJson(VerifyEmailOtp instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'otp': instance.otp,
    };
