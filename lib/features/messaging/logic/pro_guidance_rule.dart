import '../../../data/models/remote/messaging/conversation_model.dart';

class ProGuidanceRule {
  const ProGuidanceRule({
    required this.id,
    required this.enabled,
    required this.priority,
    required this.phrases,
    required this.conversationTypes,
    required this.requiredActions,
    required this.presentation,
    required this.title,
    required this.body,
    required this.ctaLabel,
    required this.intent,
    required this.maxShowsPerConversation,
  });

  final String id;
  final bool enabled;
  final int priority;
  final List<String> phrases;
  final List<String> conversationTypes;
  final List<String> requiredActions;
  final String presentation;
  final String title;
  final String body;
  final String ctaLabel;
  final String intent;
  final int maxShowsPerConversation;

  factory ProGuidanceRule.fromJson(Map<String, dynamic> json) {
    List<String> readStrings(String key) => (json[key] as List? ?? [])
        .map((value) => value.toString())
        .where((value) => value.isNotEmpty)
        .toList();

    return ProGuidanceRule(
      id: json['id']?.toString() ?? '',
      enabled: json['enabled'] == true,
      priority: (json['priority'] as num?)?.toInt() ?? 0,
      phrases: readStrings('phrases'),
      conversationTypes: readStrings('conversationTypes'),
      requiredActions: readStrings('requiresAnyActions'),
      presentation: json['presentation']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      ctaLabel: json['ctaLabel']?.toString() ?? '',
      intent: json['intent']?.toString() ?? '',
      maxShowsPerConversation:
          (json['maxShowsPerConversation'] as num?)?.toInt() ?? 1,
    );
  }

  String? get actionId => switch (intent) {
        'pro_answer_availability' => 'answer_availability',
        'propose_stay' => 'propose_stay',
        'pro_accept_reservation' => 'accept_reservation',
        'pro_reject_reservation' => 'reject_reservation',
        'propose_visit' => 'schedule_visit',
        'pro_open_support' => 'open_support',
        _ => null,
      };

  bool matches({
    required String draft,
    required ConversationType type,
    required List<Map<String, dynamic>> serverActions,
  }) {
    if (!enabled || presentation != 'suggestion' || id.isEmpty) return false;
    if (!conversationTypes.contains(type.value)) return false;
    if (type == ConversationType.support && intent != 'pro_open_support') {
      return false;
    }
    final normalizedDraft = draft.toLowerCase();
    if (!phrases.any((phrase) =>
        phrase.isNotEmpty && normalizedDraft.contains(phrase.toLowerCase()))) {
      return false;
    }
    final action = actionId;
    if (action == null || !requiredActions.contains(action)) return false;
    return serverActions.any((item) => item['id']?.toString() == action);
  }
}
