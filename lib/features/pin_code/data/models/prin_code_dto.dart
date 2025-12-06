import 'package:freezed_annotation/freezed_annotation.dart';

part 'prin_code_dto.freezed.dart';
part 'prin_code_dto.g.dart';

@freezed
class PrinCodeDto with _$PrinCodeDto {
  const factory PrinCodeDto({
    required String pin,
  }) = _PrinCodeDto;

  factory PrinCodeDto.fromJson(Map<String, dynamic> json) =>
      _$PrinCodeDtoFromJson(json);
}
