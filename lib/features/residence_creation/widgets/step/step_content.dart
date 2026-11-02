import 'package:flutter/material.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/residence_creation/logic/residence_creation_cubit.dart';
import 'package:immoplus_pro/features/residence_creation/logic/residence_creation_state.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_step_key.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/step/booking_step_extras.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/step/field_list.dart';

/// Contenu d'une étape : ses champs, plus les éléments propres à la maquette
/// de l'étape « Réservations ».
class StepContent extends StatelessWidget {
  const StepContent({
    super.key,
    required this.step,
    required this.state,
    required this.cubit,
  });

  final CreationStep step;
  final ResidenceCreationState state;
  final ResidenceCreationCubit cubit;

  @override
  Widget build(BuildContext context) {
    return switch (CreationStepKey.fromValue(step.key)) {
      CreationStepKey.booking =>
        _BookingStepContent(step: step, state: state, cubit: cubit),
      _ => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: buildFieldWidgets(
            fields: step.fields,
            state: state,
            cubit: cubit,
          ),
        ),
    };
  }
}

/// Étape « Réservations » : tarif week-end comparé au tarif standard,
/// réglages avancés repliés et récapitulatif.
class _BookingStepContent extends StatelessWidget {
  const _BookingStepContent({
    required this.step,
    required this.state,
    required this.cubit,
  });

  /// Réglages repliés sous « Personnaliser davantage ».
  static const Set<String> _advancedKeys = {
    'preparationNights',
    'bookingHorizonDays',
    'weeklyDiscountPercent',
  };
  static const String _weekendPriceKey = 'weekendNightlyPrice';

  final CreationStep step;
  final ResidenceCreationState state;
  final ResidenceCreationCubit cubit;

  List<Widget> _build(List<CreationField> fields) =>
      buildFieldWidgets(fields: fields, state: state, cubit: cubit);

  Widget? _weekendComparison() {
    final week = state.values['baseNightlyPrice'] as num?;
    final weekend = state.values[_weekendPriceKey] as num?;
    final visible = step.fields
        .where((f) => f.key == _weekendPriceKey)
        .any((f) => f.isVisible(state.values));
    if (!visible || week == null || weekend == null) return null;
    return WeekendPricingComparison(
      weekPrice: week.toInt(),
      weekendPrice: weekend.toInt(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final main = step.fields.where((f) => !_advancedKeys.contains(f.key));
    final advanced =
        step.fields.where((f) => _advancedKeys.contains(f.key)).toList();
    final comparison = _weekendComparison();

    final mainFields = main.toList();
    final weekendIndex =
        mainFields.indexWhere((f) => f.key == _weekendPriceKey);
    final beforeComparison =
        weekendIndex < 0 ? mainFields : mainFields.sublist(0, weekendIndex + 1);
    final afterComparison = weekendIndex < 0
        ? <CreationField>[]
        : mainFields.sublist(weekendIndex + 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._build(beforeComparison),
        if (comparison != null) comparison,
        ..._build(afterComparison),
        if (advanced.any((f) => f.isVisible(state.values)))
          AdvancedFieldsSection(
            hasError: advanced.any((f) => state.fieldErrors.containsKey(f.key)),
            children: _build(advanced),
          ),
        BookingSummaryCard(
          lines: BookingSummary.linesFrom(state.flow!.allFields, state.values),
        ),
        AppSpacing.gap24,
      ],
    );
  }
}
