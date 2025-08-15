import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet_model.freezed.dart';
part 'wallet_model.g.dart';

@freezed
class WalletModel with _$WalletModel {
  const factory WalletModel({
    @Default('') String id,
    @JsonKey(fromJson: _toInt, toJson: _fromInt)
    @Default(0)
    int availableBalance,
    @JsonKey(fromJson: _toInt, toJson: _fromInt) @Default(0) int pendingBalance,
    @Default('XOF') String currency,
    @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate) DateTime? createdAt,
    @JsonKey(fromJson: _fromJsonDate, toJson: _toJsonDate) DateTime? updatedAt,
  }) = _WalletModel;

  factory WalletModel.fromJson(Map<String, dynamic> json) =>
      _$WalletModelFromJson(json);
}

/// Convertir String ou double en int
int _toInt(dynamic value) =>
    value == null ? 0 : int.tryParse(value.toString().split('.').first) ?? 0;

/// Convertir int en String
String _fromInt(int value) => value.toString();

/// Convertir String en DateTime
DateTime? _fromJsonDate(String? date) =>
    date == null ? null : DateTime.tryParse(date);

/// Convertir DateTime en String
String? _toJsonDate(DateTime? date) => date?.toIso8601String();
