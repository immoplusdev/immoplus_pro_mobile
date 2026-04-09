// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'furniture_collection_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FurnitureCollectionResponseImpl _$$FurnitureCollectionResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$FurnitureCollectionResponseImpl(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => FurnitureModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      hasPrevious: json['hasPrevious'] as bool? ?? false,
      hasNext: json['hasNext'] as bool? ?? false,
    );

Map<String, dynamic> _$$FurnitureCollectionResponseImplToJson(
        _$FurnitureCollectionResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'pageSize': instance.pageSize,
      'totalCount': instance.totalCount,
      'hasPrevious': instance.hasPrevious,
      'hasNext': instance.hasNext,
    };
