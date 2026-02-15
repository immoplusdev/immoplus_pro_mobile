import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus_pro/data/models/furniture/furniture_model.dart';

part 'furniture_collection_response.freezed.dart';
part 'furniture_collection_response.g.dart';

@freezed
class FurnitureCollectionResponse with _$FurnitureCollectionResponse {
  factory FurnitureCollectionResponse({
    @Default([]) List<FurnitureModel>? data,
    @Default(0) int? currentPage,
    @Default(0) int? totalPages,
    @Default(0) int? pageSize,
    @Default(0) int? totalCount,
    @Default(false) bool? hasPrevious,
    @Default(false) bool? hasNext,
  }) = _FurnitureCollectionResponse;

  factory FurnitureCollectionResponse.fromJson(Map<String, dynamic> json) =>
      _$FurnitureCollectionResponseFromJson(json);
}
