// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_history_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RatingHistoryResponseModelImpl _$$RatingHistoryResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RatingHistoryResponseModelImpl(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => RatingModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      hasPrevious: json['hasPrevious'] as bool? ?? false,
      hasNext: json['hasNext'] as bool? ?? false,
    );

Map<String, dynamic> _$$RatingHistoryResponseModelImplToJson(
        _$RatingHistoryResponseModelImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'pageSize': instance.pageSize,
      'totalCount': instance.totalCount,
      'hasPrevious': instance.hasPrevious,
      'hasNext': instance.hasNext,
    };
