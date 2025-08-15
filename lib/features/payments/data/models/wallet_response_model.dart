import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus_pro/features/payments/data/models/wallet_model.dart';

part 'wallet_response_model.freezed.dart';
part 'wallet_response_model.g.dart';

@freezed
class WalletResponseModel with _$WalletResponseModel {
  factory WalletResponseModel({
    WalletModel? data,
  }) = _WalletResponseModel;

  factory WalletResponseModel.fromJson(Map<String, dynamic> json) =>
      _$WalletResponseModelFromJson(json);
}
