import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
class TransactionModel with _$TransactionModel {
  factory TransactionModel({
    @Default('') String? id,
    @Default('') String? owner,
    @JsonKey(fromJson: parseDouble) @Default(0.0) double? amount,
    @Default('') String? currency,
    @Default('') String? reference,
    @Default('') String? type,
    @Default('') String? note,
    @Default('') String? operator,
    @Default('') String? source,
    @Default('') String? sourceId,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? updatedAt,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? deletedAt,
    @Default('') String? createdBy,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? releaseDate,
    @Default(false) bool isRealeased,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? releasedAt,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}

DateTime? _dateTimeFromJson(String? date) =>
    date == null ? null : DateTime.parse(date);

String? _dateTimeToJson(DateTime? date) => date?.toUtc().toIso8601String();

double parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}
