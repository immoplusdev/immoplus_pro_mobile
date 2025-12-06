import 'package:freezed_annotation/freezed_annotation.dart';

part 'has_pin_response.freezed.dart';
part 'has_pin_response.g.dart';

@freezed
class HasPinResponse with _$HasPinResponse {
  const factory HasPinResponse({
    required HasPinData data,
  }) = _HasPinResponse;

  factory HasPinResponse.fromJson(Map<String, dynamic> json) =>
      _$HasPinResponseFromJson(json);
}

@freezed
class HasPinData with _$HasPinData {
  const factory HasPinData({
    required bool hasPin,
  }) = _HasPinData;

  factory HasPinData.fromJson(Map<String, dynamic> json) =>
      _$HasPinDataFromJson(json);
}
