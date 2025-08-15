import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus_pro/features/payments/data/models/withdrawal_request_model.dart';

part 'withdrawal_request_response.freezed.dart';
part 'withdrawal_request_response.g.dart';

@freezed
class WithdrawalRequestResponse with _$WithdrawalRequestResponse {
  factory WithdrawalRequestResponse({
    required WithdrawalRequestModel data,
  }) = _WithdrawalRequestResponse;

  factory WithdrawalRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalRequestResponseFromJson(json);
}
