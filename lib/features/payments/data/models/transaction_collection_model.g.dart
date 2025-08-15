// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_collection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransactionCollectionModelImpl _$$TransactionCollectionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionCollectionModelImpl(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 1,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      hasNext: json['hasNext'] as bool? ?? false,
      hasPrevious: json['hasPrevious'] as bool? ?? false,
    );

Map<String, dynamic> _$$TransactionCollectionModelImplToJson(
        _$TransactionCollectionModelImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'currentPage': instance.currentPage,
      'totalPages': instance.totalPages,
      'pageSize': instance.pageSize,
      'totalCount': instance.totalCount,
      'hasNext': instance.hasNext,
      'hasPrevious': instance.hasPrevious,
    };
