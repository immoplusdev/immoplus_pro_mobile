import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus_pro/data/models/auth/data_model.dart';

part 'account_creation_response.freezed.dart';
part 'account_creation_response.g.dart';

@freezed
class AccountCreationResponse with _$AccountCreationResponse {
  const factory AccountCreationResponse({
    @JsonKey(name: 'data') required DataModel data,
  }) = _AccountCreationResponse;

  factory AccountCreationResponse.fromJson(Map<String, dynamic> json) =>
      _$AccountCreationResponseFromJson(json);
}
