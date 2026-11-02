/// Types de champs que le formulaire sait afficher. Un type inconnu renvoyé
/// par l'API est ignoré (voir [CreationFieldType.unknown]).
enum CreationFieldType {
  text('text'),
  textarea('textarea'),
  singleSelectCards('single_select_cards'),
  counters('counters'),
  counter('counter'),
  bottomSheetCatalog('bottom_sheet_catalog'),
  select('select'),
  mapPoint('map_point'),
  multiSelectCatalog('multi_select_catalog'),
  mediaUpload('media_upload'),
  time('time'),
  toggle('switch'),
  money('money'),
  chips('chips'),
  timeChips('time_chips'),
  unknown('');

  final String value;
  const CreationFieldType(this.value);

  static CreationFieldType fromValue(String? value) =>
      CreationFieldType.values.firstWhere(
        (e) => e != CreationFieldType.unknown && e.value == value,
        orElse: () => CreationFieldType.unknown,
      );
}

/// Option d'un champ à choix (cartes, chips). Les options désactivées
/// (`enabled: false`) ne sont pas affichées.
class FieldOption {
  const FieldOption({
    required this.value,
    required this.label,
    this.description,
    this.enabled = true,
  });

  final Object value;
  final String label;
  final String? description;
  final bool enabled;

  factory FieldOption.fromJson(Map<String, dynamic> json) => FieldOption(
        value: json['value'] as Object,
        label: json['label'] as String? ?? '${json['value']}',
        description: json['description'] as String?,
        enabled: json['enabled'] as bool? ?? true,
      );
}

/// Compteur d'un champ de type `counters` (chambres, salons, ...).
class CounterItem {
  const CounterItem({
    required this.key,
    required this.label,
    this.min = 0,
    this.max,
  });

  final String key;
  final String label;
  final int min;
  final int? max;

  factory CounterItem.fromJson(Map<String, dynamic> json) => CounterItem(
        key: json['key'] as String,
        label: json['label'] as String? ?? '',
        min: (json['min'] as num?)?.toInt() ?? 0,
        max: (json['max'] as num?)?.toInt(),
      );
}

/// Condition d'affichage : le champ n'est visible que si la valeur du champ
/// [field] vaut [equals].
class VisibleWhen {
  const VisibleWhen({required this.field, required this.equals});

  final String field;
  final Object? equals;

  factory VisibleWhen.fromJson(Map<String, dynamic> json) =>
      VisibleWhen(field: json['field'] as String, equals: json['equals']);

  bool isSatisfiedBy(Map<String, dynamic> values) => values[field] == equals;
}

class CreationField {
  const CreationField({
    required this.key,
    required this.type,
    this.label,
    this.placeholder,
    this.helperText,
    this.searchPlaceholder,
    this.required = false,
    this.minLength,
    this.maxLength,
    this.min,
    this.max,
    this.minFiles,
    this.maxFiles,
    this.acceptedTypes = const [],
    this.defaultValue,
    this.options = const [],
    this.items = const [],
    this.catalogEndpoint,
    this.dependsOn,
    this.visibleWhen,
    this.currency,
  });

  final String key;
  final CreationFieldType type;
  final String? label;
  final String? placeholder;
  final String? helperText;
  final String? searchPlaceholder;
  final bool required;
  final int? minLength;
  final int? maxLength;
  final num? min;
  final num? max;
  final int? minFiles;
  final int? maxFiles;
  final List<String> acceptedTypes;
  final Object? defaultValue;
  final List<FieldOption> options;
  final List<CounterItem> items;
  final String? catalogEndpoint;
  final String? dependsOn;
  final VisibleWhen? visibleWhen;
  final String? currency;

  /// Options sélectionnables (les options désactivées sont écartées).
  List<FieldOption> get enabledOptions =>
      options.where((o) => o.enabled).toList();

  bool isVisible(Map<String, dynamic> values) =>
      visibleWhen?.isSatisfiedBy(values) ?? true;

  factory CreationField.fromJson(Map<String, dynamic> json) => CreationField(
        key: json['key'] as String,
        type: CreationFieldType.fromValue(json['type'] as String?),
        label: json['label'] as String?,
        placeholder: json['placeholder'] as String?,
        helperText: json['helperText'] as String?,
        searchPlaceholder: json['searchPlaceholder'] as String?,
        required: json['required'] as bool? ?? false,
        minLength: (json['minLength'] as num?)?.toInt(),
        maxLength: (json['maxLength'] as num?)?.toInt(),
        min: json['min'] as num?,
        max: json['max'] as num?,
        minFiles: (json['minFiles'] as num?)?.toInt(),
        maxFiles: (json['maxFiles'] as num?)?.toInt(),
        acceptedTypes:
            (json['acceptedTypes'] as List?)?.cast<String>() ?? const [],
        defaultValue: json['defaultValue'],
        options: _list(json['options'], FieldOption.fromJson),
        items: _list(json['items'], CounterItem.fromJson),
        catalogEndpoint: json['catalogEndpoint'] as String?,
        dependsOn: json['dependsOn'] as String?,
        visibleWhen: json['visibleWhen'] == null
            ? null
            : VisibleWhen.fromJson(json['visibleWhen'] as Map<String, dynamic>),
        currency: json['currency'] as String?,
      );
}

class CreationStep {
  const CreationStep({
    required this.key,
    required this.title,
    this.subtitle,
    required this.fields,
    this.position = 0,
  });

  final String key;
  final String title;
  final String? subtitle;
  final List<CreationField> fields;
  final int position;

  factory CreationStep.fromJson(Map<String, dynamic> json) => CreationStep(
        key: json['key'] as String,
        title: json['title'] as String? ?? '',
        subtitle: json['subtitle'] as String?,
        fields: _list(json['fields'], CreationField.fromJson)
            .where((f) => f.type != CreationFieldType.unknown)
            .toList(),
        position: (json['position'] as num?)?.toInt() ?? 0,
      );
}

class CreationFlow {
  const CreationFlow({
    required this.version,
    required this.intent,
    required this.title,
    required this.steps,
  });

  final String version;
  final String intent;
  final String title;
  final List<CreationStep> steps;

  Iterable<CreationField> get allFields => steps.expand((s) => s.fields);

  factory CreationFlow.fromJson(Map<String, dynamic> json) {
    final steps = _list(json['steps'], CreationStep.fromJson)
      ..sort((a, b) => a.position.compareTo(b.position));
    return CreationFlow(
      version: json['flowVersion'] as String? ?? '',
      intent: json['intent'] as String? ?? '',
      title: json['title'] as String? ?? '',
      steps: steps,
    );
  }
}

List<T> _list<T>(Object? raw, T Function(Map<String, dynamic>) parse) =>
    (raw as List?)?.map((e) => parse(e as Map<String, dynamic>)).toList() ??
    <T>[];
