import 'package:flutter/material.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/creation_style.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/field_heading.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/outlined_action_button.dart';

/// Comparaison « Semaine / Week-end » affichée sous le tarif week-end.
class WeekendPricingComparison extends StatelessWidget {
  const WeekendPricingComparison({
    super.key,
    required this.weekPrice,
    required this.weekendPrice,
  });

  final int weekPrice;
  final int weekendPrice;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: CreationStyle.fieldSpacing),
      padding: AppSpacing.edgeAll12,
      decoration: BoxDecoration(
        color: CreationStyle.selectedFill,
        borderRadius: BorderRadius.circular(CreationStyle.fieldRadius),
      ),
      child: Row(
        children: [
          Expanded(child: _PriceColumn(label: 'Semaine', price: weekPrice)),
          Expanded(
            child: _PriceColumn(
              label: 'Week-end',
              price: weekendPrice,
              alignEnd: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceColumn extends StatelessWidget {
  const _PriceColumn({
    required this.label,
    required this.price,
    this.alignEnd = false,
  });

  final String label;
  final int price;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTypography.caption.copyWith(color: AppColors.gray400)),
        Text('$price F',
            style: AppTypography.bodyMediumSemiBold
                .copyWith(color: AppColors.gray950)),
      ],
    );
  }
}

/// Section repliée « Personnaliser davantage » : regroupe les réglages
/// avancés, dépliée d'office si l'un d'eux est en erreur.
class AdvancedFieldsSection extends StatefulWidget {
  const AdvancedFieldsSection({
    super.key,
    required this.children,
    this.hasError = false,
  });

  final List<Widget> children;
  final bool hasError;

  @override
  State<AdvancedFieldsSection> createState() => _AdvancedFieldsSectionState();
}

class _AdvancedFieldsSectionState extends State<AdvancedFieldsSection> {
  bool _expanded = false;

  bool get _isOpen => _expanded || widget.hasError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OutlinedActionButton(
          label: 'Personnaliser davantage',
          trailingIcon:
              _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          onPressed: () => setState(() => _expanded = !_isOpen),
        ),
        AppSpacing.gap24,
        if (_isOpen) ...widget.children,
      ],
    );
  }
}

/// Récapitulatif « Votre configuration » calculé à partir des valeurs saisies.
class BookingSummaryCard extends StatelessWidget {
  const BookingSummaryCard({super.key, required this.lines});

  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldHeading(title: 'Votre configuration'),
        AppSpacing.gap12,
        Container(
          width: double.infinity,
          padding: AppSpacing.edgeAll12,
          decoration: BoxDecoration(
            color: CreationStyle.selectedFill.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(CreationStyle.fieldRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final line in lines)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(line,
                      style: AppTypography.caption
                          .copyWith(color: AppColors.gray700)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Lignes du récapitulatif de l'étape « Réservations ».
abstract class BookingSummary {
  static List<String> linesFrom(
    Iterable<CreationField> fields,
    Map<String, dynamic> values,
  ) {
    CreationField? field(String key) =>
        fields.where((f) => f.key == key).firstOrNull;

    String? optionLabel(String key) {
      final f = field(key);
      final value = values[key];
      if (f == null || value == null) return null;
      return f.options.where((o) => o.value == value).firstOrNull?.label;
    }

    final lines = <String>[];

    final mode = optionLabel('bookingMode');
    if (mode != null) lines.add(mode);

    final notice = values['advanceNoticeDays'];
    final cutoff = values['sameDayCutoff'] as String?;
    if (notice == 0) {
      lines.add(cutoff == null ? 'Jour même' : 'Jour même avant $cutoff');
    } else {
      final label = optionLabel('advanceNoticeDays');
      if (label != null) lines.add('Préavis de $label');
    }

    final min = values['minNights'];
    final max = values['maxNights'];
    if (min != null && max != null) lines.add('$min à $max nuits');

    final price = values['baseNightlyPrice'];
    if (price != null) {
      final weekend = values['weekendPricingEnabled'] == true
          ? values['weekendNightlyPrice']
          : null;
      lines.add([
        '$price F/nuit',
        if (weekend != null) 'Week-end $weekend F',
      ].join(' · '));
    }
    return lines;
  }
}
