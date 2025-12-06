import 'package:freezed_annotation/freezed_annotation.dart';

part 'is_valid_response.freezed.dart';
part 'is_valid_response.g.dart';

@freezed
class IsValidResponse with _$IsValidResponse {
  const factory IsValidResponse({
    required IsValidData data,
  }) = _IsValidResponse;

  factory IsValidResponse.fromJson(Map<String, dynamic> json) =>
      _$IsValidResponseFromJson(json);
}

@freezed
class IsValidData with _$IsValidData {
  const factory IsValidData({
    required bool isValid,
  }) = _IsValidData;

  factory IsValidData.fromJson(Map<String, dynamic> json) =>
      _$IsValidDataFromJson(json);
}
