import 'package:dio/dio.dart';

/// Erreurs de validation renvoyées par le serveur, rattachées (quand c'est
/// possible) à une clé du payload.
class ServerValidationErrors {
  const ServerValidationErrors({
    this.byPayloadKey = const {},
    this.general = const [],
  });

  /// Clé du payload (ex. `nom`, `capacity`) -> premier message d'erreur.
  final Map<String, String> byPayloadKey;

  /// Messages qu'on n'a pas su rattacher à un champ.
  final List<String> general;

  bool get isEmpty => byPayloadKey.isEmpty && general.isEmpty;

  /// Lit le corps d'erreur (`message` en texte ou liste, `errors` en map ou
  /// liste). [knownPayloadKey] indique si un mot est une clé du payload, pour
  /// rattacher des messages du type « baseNightlyPrice must be ... ».
  factory ServerValidationErrors.fromDioException(
    DioException error, {
    required bool Function(String) knownPayloadKey,
  }) {
    final byKey = <String, String>{};
    final general = <String>[];

    void add(String? field, String message) {
      final root = field?.split(RegExp(r'[.\[]')).first;
      if (root != null && root.isNotEmpty && knownPayloadKey(root)) {
        byKey.putIfAbsent(root, () => message);
      } else {
        general.add(message);
      }
    }

    void addFromMessage(String message) {
      final firstWord = message.split(RegExp(r'\s')).first;
      add(firstWord, message);
    }

    String joined(Object? value) => value is List ? value.join('\n') : '$value';

    final data = error.response?.data;
    if (data is Map) {
      final errors = data['errors'] ?? data['details'];
      if (errors is Map) {
        errors.forEach((field, value) => add('$field', joined(value)));
      } else if (errors is List) {
        for (final item in errors) {
          if (item is Map) {
            final field = item['field'] ?? item['property'] ?? item['path'];
            final message = item['message'] ?? item['constraints'];
            add(field is List ? field.join('.') : field?.toString(),
                joined(message is Map ? message.values.toList() : message));
          } else if (item is String) {
            addFromMessage(item);
          }
        }
      }

      final message = data['message'];
      if (message is List) {
        for (final m in message) {
          addFromMessage('$m');
        }
      } else if (message is String && byKey.isEmpty && general.isEmpty) {
        general.add(message);
      }
    }

    return ServerValidationErrors(byPayloadKey: byKey, general: general);
  }
}
