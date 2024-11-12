import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/date_demande_visite.dart';

part 'visit_programmer_body.freezed.dart';
part 'visit_programmer_body.g.dart';

@freezed
class VisitProgrammerBody with _$VisitProgrammerBody {
  factory VisitProgrammerBody({
    required List<DateDemandeVisite> datesDemandeVisite,
  }) = _VisitProgrammerBody;

  factory VisitProgrammerBody.fromJson(Map<String, dynamic> json) =>
      _$VisitProgrammerBodyFromJson(json);
}
