import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdrawal_request_model.freezed.dart';
part 'withdrawal_request_model.g.dart';

@freezed
class WithdrawalRequestModel with _$WithdrawalRequestModel {
  factory WithdrawalRequestModel({
    @Default('') String? id,
    @Default('') String? owner,
    @JsonKey(fromJson: parseDouble) @Default(0.0) double? amount,
    @Default('') String? currency,
    @Default('') String? operator,
    @Default('') String? phoneNumber,
    String? status,
    @Default('') String? note,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? createdAt,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? updatedAt,
    @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
    DateTime? deletedAt,
    @Default('') String? createdBy,
  }) = _WithdrawalRequestModel;

  factory WithdrawalRequestModel.fromJson(Map<String, dynamic> json) =>
      _$WithdrawalRequestModelFromJson(json);
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
