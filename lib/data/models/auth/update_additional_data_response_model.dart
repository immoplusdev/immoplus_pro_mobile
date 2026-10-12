import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_additional_data_response_model.freezed.dart';
part 'update_additional_data_response_model.g.dart';

@freezed
class UpdateAdditionalDataResponseModel
    with _$UpdateAdditionalDataResponseModel {
  factory UpdateAdditionalDataResponseModel({
    required UpdateAdditionalDataResult data,
  }) = _UpdateAdditionalDataResponseModel;

  factory UpdateAdditionalDataResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$UpdateAdditionalDataResponseModelFromJson(json);
}

@freezed
class UpdateAdditionalDataResult with _$UpdateAdditionalDataResult {
  const factory UpdateAdditionalDataResult({
    String? id,
    String? user,
    String? lieuNaissance,
    String? activite,
    @JsonKey(fromJson: _fileIdFromJson) String? photoIdentite,
    @JsonKey(fromJson: _fileIdFromJson) String? pieceIdentite,
    @JsonKey(fromJson: _fileIdFromJson) String? pieceIdentiteVerso,
    String? nomEntreprise,
    String? emailEntreprise,
    @JsonKey(fromJson: _fileIdFromJson) String? registreCommerce,
    @JsonKey(fromJson: _stringFromJson) String? numeroContribuable,
    String? typeEntreprise,
  }) = _UpdateAdditionalDataResult;

  factory UpdateAdditionalDataResult.fromJson(Map<String, dynamic> json) =>
      _$UpdateAdditionalDataResultFromJson(json);
}

String? _fileIdFromJson(dynamic json) {
  if (json == null) return null;
  if (json is String) return json;
  if (json is Map) {
    return json['id']?.toString();
  }
  return json.toString();
}

String? _stringFromJson(dynamic json) {
  if (json == null) return null;
  if (json is String) return json;
  return json.toString();
}
