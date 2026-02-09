import 'package:freezed_annotation/freezed_annotation.dart';

part 'date_reservation_model.freezed.dart';
part 'date_reservation_model.g.dart';

@freezed
class DateReservationModel with _$DateReservationModel {
  const factory DateReservationModel({
    required String date,
  }) = _DateReservationModel;

  factory DateReservationModel.fromJson(Map<String, dynamic> json) =>
      _$DateReservationModelFromJson(json);
}
