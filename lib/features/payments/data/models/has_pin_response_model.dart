import 'package:freezed_annotation/freezed_annotation.dart';

part 'has_pin_response_model.freezed.dart';
part 'has_pin_response_model.g.dart';

@freezed
class HasPinResponseModel with _$HasPinResponseModel {
  const factory HasPinResponseModel({
    required HasPinDataModel data,
  }) = _HasPinResponseModel;

  factory HasPinResponseModel.fromJson(Map<String, dynamic> json) =>
      _$HasPinResponseModelFromJson(json);
}

@freezed
class HasPinDataModel with _$HasPinDataModel {
  const factory HasPinDataModel({
    @Default(false) bool hasPin,
  }) = _HasPinDataModel;

  factory HasPinDataModel.fromJson(Map<String, dynamic> json) =>
      _$HasPinDataModelFromJson(json);
}
