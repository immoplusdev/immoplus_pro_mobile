import 'package:freezed_annotation/freezed_annotation.dart';

part 'additional_data_model.freezed.dart';
part 'additional_data_model.g.dart';

@freezed
class AdditionalDataModel with _$AdditionalDataModel {
  const factory AdditionalDataModel({
    String? id,
    String? user,
    String? lieuNaissance,
    String? activite,
    @JsonKey(readValue: _readPhotoIdentite, fromJson: _fileIdFromJson)
    String? photoIdentiteId,
    @JsonKey(readValue: _readPieceIdentite, fromJson: _fileIdFromJson)
    String? pieceIdentiteId,
    @JsonKey(readValue: _readPieceIdentiteVerso, fromJson: _fileIdFromJson)
    String? pieceIdentiteVersoId,
    String? nomEntreprise,
    @JsonKey(readValue: _readRegistreCommerce, fromJson: _fileIdFromJson)
    String? registreCommerceId,
    String? emailEntreprise,
    @JsonKey(fromJson: _stringFromJson)
    String? numeroContribuable,
    String? typeEntreprise,
  }) = _AdditionalDataModel;

  factory AdditionalDataModel.fromJson(Map<String, dynamic> json) =>
      _$AdditionalDataModelFromJson(json);
}

Object? _readPhotoIdentite(Map json, String key) =>
    json['photoIdentiteId'] ?? json['photoIdentite'];

Object? _readPieceIdentite(Map json, String key) =>
    json['pieceIdentiteId'] ?? json['pieceIdentite'];

Object? _readPieceIdentiteVerso(Map json, String key) =>
    json['pieceIdentiteVersoId'] ?? json['pieceIdentiteVerso'];

Object? _readRegistreCommerce(Map json, String key) =>
    json['registreCommerceId'] ?? json['registreCommerce'];

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

