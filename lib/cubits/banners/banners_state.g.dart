// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banners_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BANNERS_INITIALImpl _$$BANNERS_INITIALImplFromJson(
        Map<String, dynamic> json) =>
    _$BANNERS_INITIALImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$BANNERS_INITIALImplToJson(
        _$BANNERS_INITIALImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$BANNERS_LOADINGImpl _$$BANNERS_LOADINGImplFromJson(
        Map<String, dynamic> json) =>
    _$BANNERS_LOADINGImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$BANNERS_LOADINGImplToJson(
        _$BANNERS_LOADINGImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$BANNERS_ERRORImpl _$$BANNERS_ERRORImplFromJson(Map<String, dynamic> json) =>
    _$BANNERS_ERRORImpl(
      message: json['message'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$BANNERS_ERRORImplToJson(_$BANNERS_ERRORImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'runtimeType': instance.$type,
    };

_$BANNERS_SUCCESSImpl _$$BANNERS_SUCCESSImplFromJson(
        Map<String, dynamic> json) =>
    _$BANNERS_SUCCESSImpl(
      banners: (json['banners'] as List<dynamic>)
          .map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$BANNERS_SUCCESSImplToJson(
        _$BANNERS_SUCCESSImpl instance) =>
    <String, dynamic>{
      'banners': instance.banners,
      'runtimeType': instance.$type,
    };
