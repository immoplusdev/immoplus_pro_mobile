import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

// TODO : NOT USED
class InternationalPhoneInputV2 extends StatelessWidget {
  final Function(String)? onValidPhoneNumber;
  final String initialCountryCode;
  final void Function(bool)? onInputValidated;

  const InternationalPhoneInputV2({
    super.key,
    this.onValidPhoneNumber,
    this.initialCountryCode = 'CI',
    this.onInputValidated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: IntlPhoneField(
        invalidNumberMessage: "",
        decoration: InputDecoration(
          hintText: 'Numéro de téléphone',
          suffixIcon: const Icon(
            FontAwesomeIcons.whatsapp,
            size: 20,
            color: Colors.green,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          hintMaxLines: null,
          errorMaxLines: null,
          helperMaxLines: null,
          counterText: null,
          filled: true,
          fillColor: HexColor("#eff5fb"),
        ),
        initialCountryCode: initialCountryCode,
        countries: [countries.firstWhere((c) => c.code == initialCountryCode)],
        pickerDialogStyle: PickerDialogStyle(
          searchFieldInputDecoration: InputDecoration(
            hintText: 'Rechercher un pays',
          ),
        ),
        onChanged: (phone) {
          try {
            final isValid = phone.isValidNumber();
            onInputValidated?.call(isValid);

            if (isValid) {
              onValidPhoneNumber?.call(phone.completeNumber);
            }
          } catch (e) {
            onInputValidated?.call(false);
          }
        },
      ),
    );
  }
}
