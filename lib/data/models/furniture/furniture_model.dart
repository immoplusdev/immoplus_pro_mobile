import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus_pro/data/models/furniture/furniture_status.dart';
import 'package:immoplus_pro/data/models/furniture/geo_json_point.dart';

part 'furniture_model.freezed.dart';
part 'furniture_model.g.dart';

@freezed
class FurnitureModel with _$FurnitureModel {
  factory FurnitureModel({
    required String id,
    required String owner,
    required String titre,
    required String description,
    required String adresse,
    required int prix,
    String? ville,
    String? commune,
    GeoJsonPoint? position,
    double? lat,
    double? lng,
    @Default([]) List<String>? images,
    String? video,
    String? type,
    String? category,
    String? etat,
    @Default(0) int viewsCount,
    @Default(FurnitureStatus.active) FurnitureStatus status,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? createdBy,
  }) = _FurnitureModel;

  factory FurnitureModel.fromJson(Map<String, dynamic> json) =>
      _$FurnitureModelFromJson(json);
}
