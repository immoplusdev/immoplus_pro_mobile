// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social_login_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SocialLoginBodyImpl _$$SocialLoginBodyImplFromJson(
        Map<String, dynamic> json) =>
    _$SocialLoginBodyImpl(
      provider: json['provider'] as String,
      token: json['token'] as String,
      email: json['email'] as String,
      source: json['source'] as String,
    );

Map<String, dynamic> _$$SocialLoginBodyImplToJson(
        _$SocialLoginBodyImpl instance) =>
    <String, dynamic>{
      'provider': instance.provider,
      'token': instance.token,
      'email': instance.email,
      'source': instance.source,
    };
