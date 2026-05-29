import 'package:flutter/material.dart';

// ── Notification type enum ──────────────────────────────────────────────────
// Résolution basée sur "pushType" (plus précis que "type" qui vaut toujours "info")

enum NotificationType {
  alert('alert', Icons.notifications_active, Colors.orange),
  proposal('proposal', Icons.home_work, Colors.blue),
  visit('visit', Icons.calendar_month, Colors.purple),
  payment('payment', Icons.account_balance_wallet, Colors.green),
  message('message', Icons.chat_bubble, Colors.indigo),
  reservation('reservation', Icons.calendar_today, Color(0xFF2744DE)),
  system('system', Icons.info, Colors.grey);

  final String value;
  final IconData icon;
  final Color color;

  const NotificationType(this.value, this.icon, this.color);

  Color get backgroundColor => color.withValues(alpha: 0.10);

  /// Résolution depuis [pushType] d'abord, puis [type]
  static NotificationType fromString(String? value) {
    if (value == null) return NotificationType.system;
    final lower = value.toLowerCase();
    return NotificationType.values.firstWhere(
      (e) => lower.contains(e.value),
      orElse: () => NotificationType.system,
    );
  }
}

// ── DTO ─────────────────────────────────────────────────────────────────────

class NotificationDto {
  final String id;

  /// "info" | "warning" | "error" — valeur brute du champ "type"
  final String type;

  /// "reservation_accepted" | "new_reservation_waiting" | … — discriminant métier
  final String? pushType;

  /// Titre affiché (ex : "✅ Demande de réservation acceptée !")
  final String? subject;

  /// Corps du message
  final String message;

  /// Nom de la collection liée (ex : "reservation_accepted")
  final String? collection;

  /// ID de l'entité liée
  final String? item;

  /// null = non lu, sinon date de lecture
  final DateTime? readAt;

  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationDto({
    required this.id,
    required this.type,
    this.pushType,
    this.subject,
    required this.message,
    this.collection,
    this.item,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  // ── Computed ──────────────────────────────────────────────────────────────

  /// Résout le type via pushType d'abord, puis collection, puis type
  NotificationType get typeEnum =>
      NotificationType.fromString(pushType ?? collection ?? type);

  /// true si déjà lu (readAt non null)
  bool get isRead => readAt != null;

  /// Alias utilisé par les widgets
  bool get readStatus => isRead;

  // ── Parsing ───────────────────────────────────────────────────────────────

  factory NotificationDto.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic v) =>
        v == null ? null : DateTime.tryParse(v as String);

    return NotificationDto(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'info',
      pushType: json['pushType'] as String?,
      subject: json['subject'] as String?,
      message: json['message'] as String? ?? '',
      collection: json['collection'] as String?,
      item: json['item'] as String?,
      readAt: parseDate(json['readAt']),
      createdAt: parseDate(json['createdAt']) ?? DateTime.now(),
      updatedAt: parseDate(json['updatedAt']) ?? DateTime.now(),
    );
  }

  NotificationDto copyWith({bool? isRead}) {
    return NotificationDto(
      id: id,
      type: type,
      pushType: pushType,
      subject: subject,
      message: message,
      collection: collection,
      item: item,
      // marquer comme lu = fixer readAt à maintenant, sinon garder la valeur courante
      readAt: isRead == true ? (readAt ?? DateTime.now()) : null,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

// ── Paginated response ───────────────────────────────────────────────────────
// Structure exacte renvoyée par l'API :
// { data, currentPage, totalPages, pageSize, totalCount, hasNext, hasPrevious }

class NotificationResponse {
  final List<NotificationDto> data;
  final int currentPage;
  final int totalPages;
  final int pageSize;
  final int totalCount;
  final bool hasNext;
  final bool hasPrevious;

  const NotificationResponse({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
    required this.totalCount,
    required this.hasNext,
    required this.hasPrevious,
  });

  /// Nombre de notifications non lues (readAt == null)
  int get unreadCount => data.where((n) => !n.isRead).length;

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    final rawList = json['data'] as List<dynamic>? ?? [];
    final list = rawList
        .map((e) => NotificationDto.fromJson(e as Map<String, dynamic>))
        .toList();

    return NotificationResponse(
      data: list,
      currentPage: json['currentPage'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
      totalCount: json['totalCount'] as int? ?? list.length,
      hasNext: json['hasNext'] as bool? ?? false,
      hasPrevious: json['hasPrevious'] as bool? ?? false,
    );
  }

  NotificationResponse copyWith({
    List<NotificationDto>? data,
    int? currentPage,
    int? totalPages,
    int? pageSize,
    int? totalCount,
    bool? hasNext,
    bool? hasPrevious,
  }) {
    return NotificationResponse(
      data: data ?? this.data,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
    );
  }
}
