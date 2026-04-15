import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus_pro/data/models/furniture/furniture_status.dart';
import 'package:immoplus_pro/data/models/furniture/geo_json_point.dart';

part 'furniture_creation_model.freezed.dart';
part 'furniture_creation_model.g.dart';


@freezed
class FurnitureCreationModel with _$FurnitureCreationModel {
  const factory FurnitureCreationModel({
    required String titre,
    required String description,
    required int prix,
    required String adresse,
    @JsonKey(includeIfNull: false) String? ville,
    @JsonKey(includeIfNull: false) String? commune,
    GeoJsonPoint? position,
    double? lat,
    double? lng,
    @Default([]) List<String>? images,
    String? video,
    String? type,
    String? category,
    String? etat,
    @Default(FurnitureStatus.active) FurnitureStatus? status,
    Map<String, dynamic>? metadata,
  }) = _FurnitureCreationModel;

  factory FurnitureCreationModel.fromJson(Map<String, dynamic> json) =>
      _$FurnitureCreationModelFromJson(json);
}
