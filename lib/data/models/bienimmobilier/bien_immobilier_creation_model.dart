import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus_pro/data/models/residence/commodite_model.dart';
import 'package:immoplus_pro/data/models/residence/position_model.dart';

part 'bien_immobilier_creation_model.freezed.dart';
part 'bien_immobilier_creation_model.g.dart';

@freezed
class BienImmobilierCreationModel with _$BienImmobilierCreationModel {
  const factory BienImmobilierCreationModel({
    @Default('') String miniature,
    @Default('Unnamed Property') String? nom,
    @Default('Unknown Type') String? typeBienImmobilier,
    @Default('No Description') String? description,
    @Default([]) List<CommoditeModel>? amentities,
    @Default([]) List<String>? tags,
    @Default([]) List<String>? images,
    @Default('') String? video,
    @Default('') String? ville,
    @Default('') String? commune,
    @Default('') String? adresse,
    @Default(PositionModel()) PositionModel? position,
    @Default(0) int? prix,
    //@Default(Metadata()) Metadata metadata,
    @Default(1) int? nombreMaxOccupants,
    @Default(false) bool? animauxAutorises,
    @Default(true) bool? bienImmobilierDisponible,
    @Default(false) bool? fetesAutorises,
    @Default('') String? reglesSupplementaires,
  }) = _BienImmobilierCreationModel;

  factory BienImmobilierCreationModel.fromJson(Map<String, dynamic> json) =>
      _$BienImmobilierCreationModelFromJson(json);
}
