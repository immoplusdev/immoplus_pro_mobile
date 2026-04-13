class NotificationDto {
  final String id;
  final String type;
  final String title;
  final String message;
  final String? entityId;
  final bool isRead;
  final DateTime createdAt;

  NotificationDto({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.entityId,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationDto.fromJson(Map<String, dynamic> json) {
    return NotificationDto(
      id: json['id'] as String,
      type: json['type'] as String? ?? 'general',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      entityId: json['entityId'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  NotificationDto copyWith({bool? isRead}) {
    return NotificationDto(
      id: id,
      type: type,
      title: title,
      message: message,
      entityId: entityId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}

class NotificationResponse {
  final List<NotificationDto> data;
  final int unreadCount;

  NotificationResponse({
    required this.data,
    required this.unreadCount,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List<dynamic>?)
            ?.map((e) => NotificationDto.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    return NotificationResponse(
      data: list,
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }
}
