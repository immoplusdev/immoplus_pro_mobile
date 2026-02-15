import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus_pro/data/models/furniture/furniture_model.dart';

part 'furniture_single_response.freezed.dart';
part 'furniture_single_response.g.dart';

@freezed
class FurnitureSingleResponse with _$FurnitureSingleResponse {
  factory FurnitureSingleResponse({
    FurnitureModel? data,
  }) = _FurnitureSingleResponse;

  factory FurnitureSingleResponse.fromJson(Map<String, dynamic> json) =>
      _$FurnitureSingleResponseFromJson(json);
}
