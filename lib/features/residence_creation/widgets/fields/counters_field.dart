import 'package:flutter/material.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/counter_group_card.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/field_shell.dart';

/// Champ `counters` : plusieurs compteurs groupés (chambres, salons, ...).
/// La valeur est une `Map<String, int>` indexée par la clé de chaque compteur.
class CountersField extends StatelessWidget {
  const CountersField({
    super.key,
    required this.field,
    required this.value,
    required this.errorText,
    required this.onChanged,
  });

  final CreationField field;
  final Map<String, int> value;
  final String? errorText;
  final ValueChanged<Map<String, int>> onChanged;

  @override
  Widget build(BuildContext context) {
    return FieldShell(
      label: field.label,
      helperText: field.helperText,
      errorText: errorText,
      child: CounterGroupCard(
        rows: [
          for (final item in field.items)
            CounterRowData(
              label: item.label,
              value: value[item.key] ?? item.min,
              min: item.min,
              max: item.max,
              onChanged: (v) => onChanged({...value, item.key: v}),
            ),
        ],
      ),
    );
  }
}

/// Plusieurs champs `counter` consécutifs (ex. minimum et maximum de nuits)
/// affichés dans une seule carte, comme sur la maquette.
class CounterFieldsGroup extends StatelessWidget {
  const CounterFieldsGroup({
    super.key,
    required this.fields,
    required this.values,
    required this.errors,
    required this.onChanged,
  });

  final List<CreationField> fields;
  final Map<String, dynamic> values;
  final Map<String, String> errors;
  final void Function(String key, int value) onChanged;

  @override
  Widget build(BuildContext context) {
    final error = fields
        .map((f) => errors[f.key])
        .whereType<String>()
        .cast<String?>()
        .firstWhere((_) => true, orElse: () => null);

    return FieldShell(
      errorText: error,
      child: CounterGroupCard(
        rows: [
          for (final field in fields)
            CounterRowData(
              label: field.label ?? '',
              value: (values[field.key] as num?)?.toInt() ??
                  field.min?.toInt() ??
                  0,
              min: field.min?.toInt() ?? 0,
              max: field.max?.toInt(),
              onChanged: (v) => onChanged(field.key, v),
            ),
        ],
      ),
    );
  }
}
