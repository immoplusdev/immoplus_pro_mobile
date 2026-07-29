import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_additional_data_response_model.freezed.dart';
part 'update_additional_data_response_model.g.dart';

@freezed
class UpdateAdditionalDataResponseModel with _$UpdateAdditionalDataResponseModel {
  factory UpdateAdditionalDataResponseModel({
    required UpdateAdditionalDataResult data,
  }) = _UpdateAdditionalDataResponseModel;

  factory UpdateAdditionalDataResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UpdateAdditionalDataResponseModelFromJson(json);
}

@freezed
class UpdateAdditionalDataResult with _$UpdateAdditionalDataResult {
  const factory UpdateAdditionalDataResult({
    String? lieuNaissance,
    String? activite,
    String? photoIdentite,
    String? pieceIdentite,
    String? pieceIdentiteVerso,
    String? nomEntreprise,
    String? emailEntreprise,
    String? registreCommerce,
    String? numeroContribuable,
    String? typeEntreprise,
  }) = _UpdateAdditionalDataResult;

  factory UpdateAdditionalDataResult.fromJson(Map<String, dynamic> json) =>
      _$UpdateAdditionalDataResultFromJson(json);
}
