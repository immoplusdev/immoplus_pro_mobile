import 'package:flutter/material.dart';
import 'package:immoplus_pro/features/residence_creation/logic/residence_creation_cubit.dart';
import 'package:immoplus_pro/features/residence_creation/logic/residence_creation_state.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/counters_field.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/dynamic_field.dart';

/// Construit les widgets d'une liste de champs visibles. Les champs
/// `counter` consécutifs sont regroupés dans une seule carte.
List<Widget> buildFieldWidgets({
  required List<CreationField> fields,
  required ResidenceCreationState state,
  required ResidenceCreationCubit cubit,
}) {
  final visible = fields.where((f) => f.isVisible(state.values)).toList();
  final widgets = <Widget>[];

  var i = 0;
  while (i < visible.length) {
    final field = visible[i];

    if (field.type == CreationFieldType.counter) {
      final group = <CreationField>[];
      while (
          i < visible.length && visible[i].type == CreationFieldType.counter) {
        group.add(visible[i]);
        i++;
      }
      widgets.add(CounterFieldsGroup(
        key: ValueKey('counters_${group.first.key}'),
        fields: group,
        values: state.values,
        errors: state.fieldErrors,
        onChanged: cubit.setValue,
      ));
      continue;
    }

    widgets.add(
        DynamicField(key: ValueKey(field.key), field: field, state: state));
    i++;
  }
  return widgets;
}
