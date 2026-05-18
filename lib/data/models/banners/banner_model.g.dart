// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BannerResponseImpl _$$BannerResponseImplFromJson(Map<String, dynamic> json) =>
    _$BannerResponseImpl(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => BannerModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$BannerResponseImplToJson(
        _$BannerResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

_$BannerModelImpl _$$BannerModelImplFromJson(Map<String, dynamic> json) =>
    _$BannerModelImpl(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      ctaLabel: json['cta_label'] as String?,
      ctaUrl: json['cta_url'] as String?,
      cta2Label: json['cta2_label'] as String?,
      cta2Url: json['cta2_url'] as String?,
      icon: json['icon'] as String?,
      bgColor: json['bg_color'] as String?,
      type: json['type'] as String?,
      audience: json['audience'] as String?,
      order: (json['order'] as num?)?.toInt(),
      active: json['active'] as bool?,
      dismissible: json['dismissible'] as bool?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$BannerModelImplToJson(_$BannerModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'cta_label': instance.ctaLabel,
      'cta_url': instance.ctaUrl,
      'cta2_label': instance.cta2Label,
      'cta2_url': instance.cta2Url,
      'icon': instance.icon,
      'bg_color': instance.bgColor,
      'type': instance.type,
      'audience': instance.audience,
      'order': instance.order,
      'active': instance.active,
      'dismissible': instance.dismissible,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'metadata': instance.metadata,
    };
