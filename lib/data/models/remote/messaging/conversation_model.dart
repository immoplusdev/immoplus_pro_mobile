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

@freezed
class ConversationModel with _$ConversationModel {
  const ConversationModel._();

  static final Map<String, Map<String, dynamic>> _extraData = {};

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
  }) = _ConversationModel;

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    final model = _$ConversationModelFromJson(json);
    _extraData[model.id] = json;
    return model;
  }

  ConversationStatus get statusEnum => ConversationStatus.fromString(status);
  ConversationType get typeEnum => ConversationType.fromString(type);

  String? get stage => _extraData[id]?['stage']?.toString();
  String? get pendingActionFor => _extraData[id]?['pendingActionFor']?.toString();
  String? get relaisId => _extraData[id]?['relaisId']?.toString();

  /// Identifiant de la réservation liée au fil. Le champ est conservé dans
  /// les données brutes afin de rester compatible avec les réponses qui
  /// exposent `reservationId`, `reservation_id` ou l'objet `reservation`.
  String? get reservationId {
    final data = _extraData[id];
    final direct = data?['reservationId'] ?? data?['reservation_id'];
    if (direct != null && direct.toString().isNotEmpty) {
      return direct.toString();
    }
    final reservation = data?['reservation'];
    if (reservation is Map && reservation['id'] != null) {
      return reservation['id'].toString();
    }
    return null;
  }
  List<Map<String, dynamic>>? get actions {
    final raw = _extraData[id]?['actions'];
    if (raw is List) {
      return raw.map((e) => Map<String, dynamic>.from(e is Map ? e : {})).toList();
    }
    return null;
  }

  bool get isReadOnly =>
      (_extraData[id]?['readOnly'] == true) || status == 'blocked';
}
