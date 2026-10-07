import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversation_model.freezed.dart';
part 'conversation_model.g.dart';

enum ConversationStatus {
  active('active'),
  blocked('blocked');

  final String value;
  const ConversationStatus(this.value);

  static ConversationStatus fromString(String? value) {
    return ConversationStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ConversationStatus.active,
    );
  }
}

enum ConversationType {
  reservation('reservation'),
  visite('visite'),
  relais('relais'),
  support('support');

  final String value;
  const ConversationType(this.value);

  static ConversationType fromString(String? value) {
    return ConversationType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ConversationType.reservation,
    );
  }
}

Object? _readReservationId(Map json, String key) {
  final direct = json['reservationId'] ?? json['reservation_id'];
  if (direct != null && direct.toString().isNotEmpty) {
    return direct.toString();
  }
  final reservation = json['reservation'];
  if (reservation is Map && reservation['id'] != null) {
    return reservation['id'].toString();
  }
  return null;
}

Object? _readPendingActionFor(Map json, String key) {
  return json['pendingActionFor'] ?? json['pending_action_for'];
}

Object? _readRelaisId(Map json, String key) {
  return json['relaisId'] ?? json['relais_id'];
}

Object? _readReadOnly(Map json, String key) {
  return json['readOnly'] ?? json['read_only'] ?? false;
}

@freezed
class ConversationModel with _$ConversationModel {
  const ConversationModel._();

  const factory ConversationModel({
    required String id,
    @Default('reservation') String type,

    /// Non-null seulement pour `type == reservation`.
    String? residenceId,

    /// Non-null seulement pour `type == visite`.
    String? visiteId,

    /// Toujours `null` pour `type == support` (boîte partagée, pas
    /// d'interlocuteur fixe).
    String? proId,
    required String clientId,
    @Default('active') String status,
    @Default(0) int unreadCountClient,
    @Default(0) int unreadCountPro,
    String? lastMessagePreview,
    DateTime? lastMessageAt,
    DateTime? createdAt,
    String? stage,
    @JsonKey(readValue: _readPendingActionFor) String? pendingActionFor,
    @JsonKey(readValue: _readRelaisId) String? relaisId,
    @JsonKey(readValue: _readReservationId) String? reservationId,
    List<Map<String, dynamic>>? actions,
    @Default(false) @JsonKey(readValue: _readReadOnly) bool readOnly,
  }) = _ConversationModel;

  factory ConversationModel.fromJson(Map<String, dynamic> json) =>
      _$ConversationModelFromJson(json);

  ConversationStatus get statusEnum => ConversationStatus.fromString(status);
  ConversationType get typeEnum => ConversationType.fromString(type);

  bool get isReadOnly => readOnly || status == 'blocked';
}
