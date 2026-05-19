// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'particulier_registration_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ParticulierRegistrationBodyImpl _$$ParticulierRegistrationBodyImplFromJson(
        Map<String, dynamic> json) =>
    _$ParticulierRegistrationBodyImpl(
      avatar: json['avatar'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      password: json['password'] as String?,
      activite: json['activite'] as String?,
      photoIdentiteId: json['photoIdentiteId'] as String?,
      pieceIdentiteId: json['pieceIdentiteId'] as String?,
      pieceIdentiteVersoId: json['pieceIdentiteVersoId'] as String?,
      token: json['token'] as String?,
      provider: json['provider'] as String?,
    );

Map<String, dynamic> _$$ParticulierRegistrationBodyImplToJson(
        _$ParticulierRegistrationBodyImpl instance) =>
    <String, dynamic>{
      'avatar': instance.avatar,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'password': instance.password,
      'activite': instance.activite,
      'photoIdentiteId': instance.photoIdentiteId,
      'pieceIdentiteId': instance.pieceIdentiteId,
      'pieceIdentiteVersoId': instance.pieceIdentiteVersoId,
      'token': instance.token,
      'provider': instance.provider,
    };
