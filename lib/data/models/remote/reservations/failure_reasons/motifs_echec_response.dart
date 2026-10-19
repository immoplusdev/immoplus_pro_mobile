import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus_pro/data/models/remote/reservations/failure_reasons/motif_item.dart';

part 'motifs_echec_response.freezed.dart';
part 'motifs_echec_response.g.dart';

@freezed
class MotifsEchecResponse with _$MotifsEchecResponse {
  const factory MotifsEchecResponse({
    required MotifsEchecData data,
  }) = _MotifsEchecResponse;

  factory MotifsEchecResponse.fromJson(Map<String, dynamic> json) =>
      _$MotifsEchecResponseFromJson(json);
}

@freezed
class MotifsEchecData with _$MotifsEchecData {
  const factory MotifsEchecData({
    required String reservationId,
    String? status,
    String? actorInterroge,
    @Default(false) bool dejaRepondu,
    @Default([]) List<MotifItem> motifs,
  }) = _MotifsEchecData;

  factory MotifsEchecData.fromJson(Map<String, dynamic> json) =>
      _$MotifsEchecDataFromJson(json);
}
