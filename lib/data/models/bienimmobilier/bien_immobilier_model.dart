import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus_pro/common/validation_status.dart';
import 'package:immoplus_pro/data/models/residence/commodite_model.dart';
import 'package:immoplus_pro/data/models/residence/piece_model.dart';
import 'package:immoplus_pro/data/models/residence/position_model.dart';

part 'bien_immobilier_model.freezed.dart';
part 'bien_immobilier_model.g.dart';

@freezed
class BienImmobilierModel with _$BienImmobilierModel {
  factory BienImmobilierModel({
    @Default('') String id,
    @Default('') String nom,
    @Default('') String typeBienImmobilier,
    @Default('') String description,
    @Default([]) List<CommoditeModel> amentities,
    @Default([]) List<String> tags,
    @Default([]) List<String> images,
    @Default('') String adresse,
    @Default(PositionModel()) PositionModel position,
    double? latitude,
    double? longitude,
    @Default('') String statusValidation,
    @Default(0) int prix,
    @Default(false) bool aLouer,
    @Default('') String typeLocation,
    @Default([]) List<PieceModel> pieces,
    @Default(false) bool bienImmobilierDisponible,
    int? nombreMaxOccupants,
    //  bool? animauxAutorises,
    bool? fetesAutorises,
    //  bool? reglesSupplementaires

    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    @Default('') String miniatureId,
    String? miniature,
    String? video,
    @Default('') String ville,
    @Default('') String commune,
    @Default(false) bool featured,
  }) = _BienImmobilierModel;

  factory BienImmobilierModel.fromJson(Map<String, dynamic> json) =>
      _$BienImmobilierModelFromJson(json);
}

extension BienImmobilierModelX on BienImmobilierModel {
  ValidationStatus get validationStatus =>
      ValidationStatus.fromString(statusValidation);
}
