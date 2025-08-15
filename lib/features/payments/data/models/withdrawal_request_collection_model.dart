import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus_pro/features/payments/data/models/withdrawal_request_model.dart';

part 'withdrawal_request_collection_model.freezed.dart';
part 'withdrawal_request_collection_model.g.dart';

@freezed
class WithdrawalRequestCollectionModel with _$WithdrawalRequestCollectionModel {
  factory WithdrawalRequestCollectionModel({
    @Default([]) List<WithdrawalRequestModel>? data,
    @Default(1) int? currentPage,
    @Default(1) int? totalPages,
    @Default(0) int? pageSize,
    @Default(0) int? totalCount,
    @Default(false) bool? hasNext,
    @Default(false) bool? hasPrevious,
  }) = _WithdrawalRequestCollectionModel;

  factory WithdrawalRequestCollectionModel.fromJson(
          Map<String, dynamic> json) =>
      _$WithdrawalRequestCollectionModelFromJson(json);
}
