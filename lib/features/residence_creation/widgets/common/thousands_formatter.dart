import 'package:flutter/services.dart';

/// Affiche un entier avec des points comme séparateurs de milliers
/// (« 35.000 »). La valeur saisie reste un entier : voir [digitsOf].
class ThousandsFormatter extends TextInputFormatter {
  static String digitsOf(String text) => text.replaceAll(RegExp(r'\D'), '');

  static String format(int value, {String separator = '.'}) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(separator);
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = digitsOf(newValue.text);
    if (digits.isEmpty) return newValue.copyWith(text: '');

    final formatted = format(int.parse(digits));
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
