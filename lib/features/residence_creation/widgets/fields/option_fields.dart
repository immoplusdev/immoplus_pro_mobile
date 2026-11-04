import 'package:flutter/material.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/selectable_surface.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/field_shell.dart';

/// Champs `chips` et `time_chips` : choix unique parmi des options actives,
/// réparties sur toute la largeur.
class ChipsField extends StatelessWidget {
  const ChipsField({
    super.key,
    required this.field,
    required this.value,
    required this.errorText,
    required this.onChanged,
  });

  /// Au-delà, les chips passent à la ligne au lieu de se partager la largeur.
  static const int _maxOptionsPerRow = 5;

  final CreationField field;
  final Object? value;
  final String? errorText;
  final ValueChanged<Object> onChanged;

  @override
  Widget build(BuildContext context) {
    final options = field.enabledOptions;
    final isTimeChips = field.type == CreationFieldType.timeChips;

    Widget chip(FieldOption option) => _OptionChip(
          label: option.label,
          selected: value == option.value,
          tall: isTimeChips,
          onTap: () => onChanged(option.value),
        );

    return FieldShell(
      label: field.label,
      helperText: field.helperText,
      errorText: errorText,
      labelStyle: isTimeChips ? FieldLabelStyle.plain : FieldLabelStyle.heading,
      child: options.length <= _maxOptionsPerRow
          ? Row(
              children: [
                for (var i = 0; i < options.length; i++) ...[
                  if (i > 0) const SizedBox(width: AppSpacing.xs),
                  Expanded(child: chip(options[i])),
                ],
              ],
            )
          : Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [for (final option in options) chip(option)],
            ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.label,
    required this.selected,
    required this.tall,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool tall;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SelectableSurface(
      selected: selected,
      onTap: onTap,
      radius: AppRadii.r12,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: tall ? AppSpacing.md : AppSpacing.sm,
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.captionSemiBold.copyWith(
          color: selected ? AppColors.primary : AppColors.gray500,
        ),
      ),
    );
  }
}

/// Champ `single_select_cards` à options inline (ex. mode de réservation).
class OptionCardsField extends StatelessWidget {
  const OptionCardsField({
    super.key,
    required this.field,
    required this.value,
    required this.errorText,
    required this.onChanged,
  });

  final CreationField field;
  final Object? value;
  final String? errorText;
  final ValueChanged<Object> onChanged;

  @override
  Widget build(BuildContext context) {
    return FieldShell(
      label: field.label,
      helperText: field.helperText,
      errorText: errorText,
      child: Column(
        children: [
          for (final option in field.enabledOptions)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _OptionCard(
                option: option,
                selected: value == option.value,
                onTap: () => onChanged(option.value),
              ),
            ),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final FieldOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SelectableSurface(
      selected: selected,
      onTap: onTap,
      padding: AppSpacing.edgeAll16,
      child: Row(
        children: [
          _BookingModeIcon(value: option.value),
          AppSpacing.gap12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(option.label,
                    style: AppTypography.bodyLargeSemiBold
                        .copyWith(color: AppColors.gray950)),
                if (option.description != null) ...[
                  AppSpacing.gap4,
                  Text(option.description!,
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColors.gray400)),
                ],
              ],
            ),
          ),
          AppSpacing.gap12,
          _RadioDot(selected: selected),
        ],
      ),
    );
  }
}

/// Pastille d'icône du mode de réservation (éclair pour l'instantané).
class _BookingModeIcon extends StatelessWidget {
  const _BookingModeIcon({required this.value});

  final Object value;

  @override
  Widget build(BuildContext context) {
    final isInstant = value == 'INSTANT';
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isInstant
            ? AppColors.gold400.withValues(alpha: 0.35)
            : AppColors.gray200,
      ),
      child: Icon(
        isInstant ? Icons.bolt : Icons.hourglass_bottom,
        size: 20,
        color: isInstant ? AppColors.orange500 : AppColors.gray700,
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColors.primary : Colors.white,
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.gray300,
          width: 1.5,
        ),
      ),
      child: selected
          ? const Center(
              child: SizedBox(
                width: 8,
                height: 8,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
              ),
            )
          : null,
    );
  }
}
