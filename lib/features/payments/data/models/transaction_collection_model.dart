import 'package:freezed_annotation/freezed_annotation.dart';

import 'transaction_model.dart';

part 'transaction_collection_model.freezed.dart';
part 'transaction_collection_model.g.dart';

@freezed
class TransactionCollectionModel with _$TransactionCollectionModel {
  factory TransactionCollectionModel({
    @Default([]) List<TransactionModel>? data,
    @Default(1) int? currentPage,
    @Default(1) int? totalPages,
    @Default(0) int? pageSize,
    @Default(0) int? totalCount,
    @Default(false) bool? hasNext,
    @Default(false) bool? hasPrevious,
  }) = _TransactionCollectionModel;

  factory TransactionCollectionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionCollectionModelFromJson(json);
}
