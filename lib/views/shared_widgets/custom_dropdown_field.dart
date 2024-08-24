import 'package:flutter/material.dart';

class CustomDropDownField extends StatelessWidget {
  CustomDropDownField({
    Key? key,
    this.labelText,
    this.sufixIcon,
    this.onTap,
    this.onSaved,
    this.onFieldSubmitted,
    this.validator,
    this.onChanged,
    required this.items,
    this.value,
  }) : super(key: key);
  final String? labelText;
  final Widget? sufixIcon;
  final List<String> items;
  final Function()? onTap;
  Function(String?)? onSaved;
  Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  void Function(String?)? onChanged;
  String? value;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map((label) => DropdownMenuItem(
                child: Text(label.toString()),
                value: label,
              ))
          .toList(),
      onSaved: onSaved,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        hintText: labelText ?? 'label',
        filled: true,
        //fillColor: Colors.white10,
        //labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        focusColor: Theme.of(context).colorScheme.onSurface,
        suffixIcon: sufixIcon,
        // border: new OutlineInputBorder(
        //   borderRadius: new BorderRadius.circular(4.0),
        //   borderSide: new BorderSide(
        //     color: Theme.of(context).colorScheme.onSurface,
        //   ),
        // ),
        // focusedBorder: new OutlineInputBorder(
        //   borderRadius: new BorderRadius.circular(4.0),
        //   borderSide: new BorderSide(
        //     color: Theme.of(context).colorScheme.primary,
        //   ),
        // ),
        errorStyle: TextStyle(color: Colors.redAccent),
        contentPadding: EdgeInsets.all(0).copyWith(left: 10),
        // prefixIconColor: _iconColor,
        // suffixIconColor: _iconColor,

        //labelText: labelText!,

        //iconColor: Colors.black,
        hintStyle: TextStyle(
          color: Colors.grey,
          //fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        //fillColor: _color,
        //focusColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
