import 'package:freezed_annotation/freezed_annotation.dart';

part 'pin_request_model.freezed.dart';
part 'pin_request_model.g.dart';

@freezed
class PinRequestModel with _$PinRequestModel {
  const factory PinRequestModel({
    @Default('') String pin,
  }) = _PinRequestModel;

  factory PinRequestModel.fromJson(Map<String, dynamic> json) =>
      _$PinRequestModelFromJson(json);
}
