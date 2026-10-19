class PushMessage {
  final String? messageId;
  final String? title;
  final String? body;
  final Map<String, dynamic> data;

  const PushMessage({
    this.messageId,
    this.title,
    this.body,
    this.data = const {},
  });
}
