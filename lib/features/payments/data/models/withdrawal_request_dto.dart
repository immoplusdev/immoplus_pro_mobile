import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdrawal_request_dto.freezed.dart';
part 'withdrawal_request_dto.g.dart';

@freezed
class WithdrawalRequestDto with _$WithdrawalRequestDto {
  factory WithdrawalRequestDto({
    required int amount,
    required String currency,
    required String phoneNumber,
    required String operator,
    required String status,
    String? note,
  }) = _WithdrawalRequestDto;

  factory WithdrawalRequestDto.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalRequestDtoFromJson(json);
}
