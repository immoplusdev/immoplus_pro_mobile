import 'package:freezed_annotation/freezed_annotation.dart';

part 'motif_item.freezed.dart';
part 'motif_item.g.dart';

@freezed
class MotifItem with _$MotifItem {
  const factory MotifItem({
    required String code,
    required String label,
  }) = _MotifItem;

  factory MotifItem.fromJson(Map<String, dynamic> json) =>
      _$MotifItemFromJson(json);
}
