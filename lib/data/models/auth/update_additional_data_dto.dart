import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_additional_data_dto.freezed.dart';
part 'update_additional_data_dto.g.dart';

@freezed
class UpdateAdditionalDataDto with _$UpdateAdditionalDataDto {
  const factory UpdateAdditionalDataDto({
    // Pro particulier
    String? lieuNaissance,
    String? activite,
    String? photoIdentite,
    String? pieceIdentite,
    String? pieceIdentiteVerso,
    // Pro entreprise
    String? nomEntreprise,
    String? emailEntreprise,
    String? registreCommerce,
    String? numeroContribuable,
    String? typeEntreprise,
  }) = _UpdateAdditionalDataDto;

  factory UpdateAdditionalDataDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateAdditionalDataDtoFromJson(json);
}
