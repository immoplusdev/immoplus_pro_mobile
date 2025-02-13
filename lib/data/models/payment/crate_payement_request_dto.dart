import 'package:freezed_annotation/freezed_annotation.dart';

part 'crate_payement_request_dto.freezed.dart';
part 'crate_payement_request_dto.g.dart';

@freezed
class CratePayementRequestDto with _$CratePayementRequestDto {
  factory CratePayementRequestDto({
    required String reservationId,
    required String paymentMethod,
    required String paymentAddress,
  }) = _CratePayementRequestDto;

  factory CratePayementRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CratePayementRequestDtoFromJson(json);
}
