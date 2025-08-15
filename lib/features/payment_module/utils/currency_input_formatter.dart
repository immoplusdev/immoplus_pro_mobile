import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('### ### ###', 'fr_FR');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll(' ', '');

    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    int selectionIndex = newValue.selection.end;

    // Formate le nombre
    String formatted = _formatter.format(int.parse(newText));

    // Calculer le nouvel offset
    int numSpacesBefore = _countSpaces(_formatter.format(int.parse(
        newText.substring(0, selectionIndex.clamp(0, newText.length)))));

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
          offset: formatted.length < selectionIndex + numSpacesBefore
              ? formatted.length
              : selectionIndex + numSpacesBefore),
    );
  }

  int _countSpaces(String text) => ' '.allMatches(text).length;
}
