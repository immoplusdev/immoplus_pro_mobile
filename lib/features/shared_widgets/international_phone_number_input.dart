import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:immoplus_pro/constantes/app_colors.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class InternationalPhoneInput extends StatefulWidget {
  final Function(String)? onValidPhoneNumber;
  final String initialCountryCode;
  final String? initialPhoneNumber;
  final String? Function(String?)? validator;
  final void Function(bool)? onInputValidated;
  final bool isEnabled;
  final Color? fillColor;
  final Widget? suffixIcon;
  final bool showBorder;
  final bool showErrorImmediately;
  final bool forceShowError;
  final bool autofocus;

  const InternationalPhoneInput({
    super.key,
    this.onValidPhoneNumber,
    this.initialCountryCode = 'CI',
    this.validator,
    this.onInputValidated, // Default to Côte d’Ivoire
    this.initialPhoneNumber,
    this.isEnabled = true,
    this.fillColor,
    this.suffixIcon,
    this.showBorder = false,
    this.showErrorImmediately = true,
    this.forceShowError = false,
    this.autofocus = false,
  });

  @override
  _InternationalPhoneInputState createState() =>
      _InternationalPhoneInputState();
}

class _InternationalPhoneInputState extends State<InternationalPhoneInput> {
  final TextEditingController _controller = TextEditingController();
  late PhoneNumber _phoneNumber;
  late PhoneNumber _initialPhoneNumber; // Add this
  final ValueNotifier<bool?> _isValidNotifier = ValueNotifier<bool?>(null);

  @override
  void initState() {
    super.initState();
    _initialPhoneNumber = PhoneNumber(
      // Initialize this
      isoCode: widget.initialCountryCode,
      phoneNumber: widget.initialPhoneNumber,
    );
    _phoneNumber = _initialPhoneNumber; // Set current to initial
  }

  @override
  void dispose() {
    _isValidNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fillColor = widget.fillColor ?? HexColor("#eff5fb");
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ListTile(
            tileColor: fillColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: widget.showBorder
                  ? BorderSide(
                      color: AppColors.primary.withOpacity(0.25),
                      width: 1.5,
                    )
                  : BorderSide.none,
            ),
            title: InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                _phoneNumber = number;
              },
              onInputValidated: (bool value) {
                if (_isValidNotifier.value != value) {
                  _isValidNotifier.value = value;
                }
                if (value && widget.onValidPhoneNumber != null) {
                  widget.onValidPhoneNumber!(_phoneNumber.phoneNumber ?? '');
                }
                if (widget.onInputValidated != null) {
                  widget.onInputValidated!(value);
                }
              },
              validator: widget.validator,
              ignoreBlank: false,
              isEnabled: widget.isEnabled,
              autoFocus: widget.autofocus,
              autoValidateMode: AutovalidateMode.disabled,
              initialValue: _initialPhoneNumber, // Use static initial value
              textFieldController: _controller,
              formatInput: true,
              maxLength: 13,
              spaceBetweenSelectorAndTextField: 0,
              textAlignVertical: TextAlignVertical.center,
              errorMessage: "Le numéro de téléphone est incorrect",
              searchBoxDecoration: InputDecoration(
                labelText: "Rechercher un pays",
              ),
              hintText: "Numéro de téléphone",
              keyboardType: TextInputType.phone,
              keyboardAction: TextInputAction.done,
              inputBorder: InputBorder.none,
              selectorConfig: const SelectorConfig(
                leadingPadding: 0,
                setSelectorButtonAsPrefixIcon: true,
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                trailingSpace: false,
              ),
              selectorTextStyle: Theme.of(context).textTheme.bodyLarge,
              inputDecoration: InputDecoration(
                prefixIcon: const Text('|'),
                hintStyle: Theme.of(context).textTheme.bodyMedium,
                suffixIcon: widget.suffixIcon ??
                    const FaIcon(FontAwesomeIcons.whatsapp,
                      size: 20,
                      color: Colors.green,
                    ),
                fillColor: fillColor,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: "Numéro de téléphone",
                errorStyle: const TextStyle(height: 0),
              ),
            ),
          ),
          ValueListenableBuilder<bool?>(
            valueListenable: _isValidNotifier,
            builder: (context, isValid, child) {
              final shouldShow = widget.showErrorImmediately
                  ? isValid == false
                  : widget.forceShowError && isValid == false;
              if (!shouldShow) {
                return const SizedBox.shrink();
              }
              return const Text(
                'Le numéro de téléphone est invalide.',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
