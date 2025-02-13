import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdraw_booking_history_dto.freezed.dart';
part 'withdraw_booking_history_dto.g.dart';

@freezed
class WithdrawBookingHistoryDto with _$WithdrawBookingHistoryDto {
  const factory WithdrawBookingHistoryDto({
    @Default(0) int montantNonRetire,
    @Default(0) int montantRetire,
    @Default(0) int montantTotal,
  }) = _WithdrawBookingHistoryDto;

  factory WithdrawBookingHistoryDto.fromJson(Map<String, dynamic> json) =>
      _$WithdrawBookingHistoryDtoFromJson(json);
}
