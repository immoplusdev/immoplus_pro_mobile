// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_password_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatePasswordBody _$UpdatePasswordBodyFromJson(Map<String, dynamic> json) =>
    UpdatePasswordBody(
      oldPassword: json['oldPassword'] as String,
      newPassword: json['newPassword'] as String,
    );

Map<String, dynamic> _$UpdatePasswordBodyToJson(UpdatePasswordBody instance) =>
    <String, dynamic>{
      'oldPassword': instance.oldPassword,
      'newPassword': instance.newPassword,
    };
