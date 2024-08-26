import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus_pro/data/models/residence/commodite_model.dart';
import 'package:immoplus_pro/data/models/residence/position_model.dart';

part 'bien_immobilier_model.freezed.dart';
part 'bien_immobilier_model.g.dart';

@freezed
class BienImmobilierModel with _$BienImmobilierModel {
  factory BienImmobilierModel({
    @Default('') String id,
    @Default('Unknown Name') String nom,
    @Default('Unknown Type') String typeBienImmobilier,
    @Default('No Description') String description,
    @Default([]) List<CommoditeModel> amentities,
    @Default([]) List<String> tags,
    @Default([]) List<String> images,
    @Default('Unknown Address') String adresse,
    @Default(PositionModel()) PositionModel position,
    @Default('pending_validation') String statusValidation,
    @Default(0) int prix,
    @Default(false) bool featured,
    @Default(true) bool bienImmobilierDisponible,
    @Default(1) int nombreMaxOccupants,
    @Default(false) bool animauxAutorises,
    @Default(false) bool fetesAutorises,
    @Default('No Additional Rules') String reglesSupplementaires,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    @Default('') String miniatureId,
  }) = _BienImmobilierModel;

  factory BienImmobilierModel.fromJson(Map<String, dynamic> json) =>
      _$BienImmobilierModelFromJson(json);
}
