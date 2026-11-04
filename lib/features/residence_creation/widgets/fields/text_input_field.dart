import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:immoplus_pro/app/design_system/design_system.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/common/thousands_formatter.dart';
import 'package:immoplus_pro/features/residence_creation/widgets/fields/field_shell.dart';

/// Champs `text`, `textarea` et `money`.
class TextInputField extends StatefulWidget {
  const TextInputField({
    super.key,
    required this.field,
    required this.value,
    required this.errorText,
    required this.onChanged,
  });

  final CreationField field;
  final Object? value;
  final String? errorText;
  final ValueChanged<Object?> onChanged;

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  late final TextEditingController _controller =
      TextEditingController(text: _displayText(widget.value));

  bool get _isMoney => widget.field.type == CreationFieldType.money;
  bool get _isTextarea => widget.field.type == CreationFieldType.textarea;

  String _displayText(Object? value) {
    if (value == null) return '';
    return _isMoney
        ? ThousandsFormatter.format((value as num).toInt())
        : '$value';
  }

  @override
  void didUpdateWidget(TextInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // La valeur peut être modifiée ailleurs (ex. adresse préremplie par la
    // carte) : on resynchronise le champ sans écraser ce que l'on tape.
    final expected = _displayText(widget.value);
    if (expected != _controller.text) {
      _controller.value = TextEditingValue(
        text: expected,
        selection: TextSelection.collapsed(offset: expected.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String text) => widget.onChanged(
        _isMoney ? int.tryParse(ThousandsFormatter.digitsOf(text)) : text,
      );

  @override
  Widget build(BuildContext context) {
    final field = widget.field;
    final isCompactLabel = !_isMoney && !_isTextarea;

    return FieldShell(
      label: field.label,
      helperText: field.helperText,
      errorText: widget.errorText,
      labelStyle:
          isCompactLabel ? FieldLabelStyle.plain : FieldLabelStyle.heading,
      child: TextField(
        controller: _controller,
        onChanged: _onChanged,
        maxLength: _isMoney ? null : field.maxLength,
        minLines: _isTextarea ? 5 : 1,
        maxLines: _isTextarea ? 10 : 1,
        style: AppTypography.bodyMedium,
        keyboardType: _isMoney
            ? TextInputType.number
            : (_isTextarea ? TextInputType.multiline : TextInputType.text),
        textCapitalization: TextCapitalization.sentences,
        inputFormatters: _isMoney
            ? [FilteringTextInputFormatter.digitsOnly, ThousandsFormatter()]
            : null,
        decoration: creationInputDecoration(
          hint: field.placeholder ?? (_isTextarea ? 'Description ici' : null),
          suffix: _isMoney ? _CurrencySuffix(field.currency) : null,
          hasError: widget.errorText != null,
        ),
      ),
    );
  }
}

class _CurrencySuffix extends StatelessWidget {
  const _CurrencySuffix(this.currency);

  final String? currency;

  /// Le backend parle en codes ISO (XOF), la maquette affiche « fcfa ».
  static const Map<String, String> _labels = {'XOF': 'fcfa'};

  @override
  Widget build(BuildContext context) {
    return Text(
      _labels[currency] ?? currency ?? '',
      style: AppTypography.bodyMediumMedium.copyWith(color: AppColors.gray950),
    );
  }
}
