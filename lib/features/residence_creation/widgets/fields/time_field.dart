import 'package:flutter/material.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/creation_style.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/field_shell.dart';

/// Champ `time` : heure au format `HH:mm`.
class TimeField extends StatelessWidget {
  const TimeField({
    super.key,
    required this.field,
    required this.value,
    required this.errorText,
    required this.onChanged,
  });

  final CreationField field;
  final String? value;
  final String? errorText;
  final ValueChanged<String> onChanged;

  TimeOfDay get _initialTime {
    final parts = value?.split(':');
    if (parts == null || parts.length != 2) {
      return const TimeOfDay(hour: 12, minute: 0);
    }
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 12,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }

  Future<void> _pick(BuildContext context) async {
    final picked =
        await showTimePicker(context: context, initialTime: _initialTime);
    if (picked == null) return;
    String two(int n) => n.toString().padLeft(2, '0');
    onChanged('${two(picked.hour)}:${two(picked.minute)}');
  }

  @override
  Widget build(BuildContext context) {
    return FieldShell(
      label: field.label,
      helperText: field.helperText,
      errorText: errorText,
      labelStyle: FieldLabelStyle.plain,
      child: InkWell(
        onTap: () => _pick(context),
        borderRadius: BorderRadius.circular(CreationStyle.fieldRadius),
        child: InputDecorator(
          decoration: creationInputDecoration(
            hasError: errorText != null,
            suffix: Icon(Icons.schedule, size: 20, color: AppColors.gray400),
          ),
          child: Text(
            value?.replaceAll(':', ' : ') ?? 'Choisir une heure',
            style: AppTypography.bodyMedium
                .copyWith(color: value == null ? AppColors.gray400 : null),
          ),
        ),
      ),
    );
  }
}
