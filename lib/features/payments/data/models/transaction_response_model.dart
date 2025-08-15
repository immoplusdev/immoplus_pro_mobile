import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus_pro/features/payments/data/models/transaction_model.dart';

part 'transaction_response_model.freezed.dart';
part 'transaction_response_model.g.dart';

@freezed
class TransactionResponseModel with _$TransactionResponseModel {
  factory TransactionResponseModel({
    TransactionModel? data,
  }) = _TransactionResponseModel;

  factory TransactionResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseModelFromJson(json);
}
