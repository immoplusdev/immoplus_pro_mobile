import 'package:freezed_annotation/freezed_annotation.dart';

part 'motif_echec_reponse_model.freezed.dart';
part 'motif_echec_reponse_model.g.dart';

@freezed
class MotifEchecReponseModel with _$MotifEchecReponseModel {
  const factory MotifEchecReponseModel({
    required MotifEchecReponseData data,
  }) = _MotifEchecReponseModel;

  factory MotifEchecReponseModel.fromJson(Map<String, dynamic> json) =>
      _$MotifEchecReponseModelFromJson(json);
}

@freezed
class MotifEchecReponseData with _$MotifEchecReponseData {
  const factory MotifEchecReponseData({
    String? actor,
    String? status,
    required String reasonCode,
    String? comment,
    DateTime? respondedAt,
  }) = _MotifEchecReponseData;

  factory MotifEchecReponseData.fromJson(Map<String, dynamic> json) =>
      _$MotifEchecReponseDataFromJson(json);
}
