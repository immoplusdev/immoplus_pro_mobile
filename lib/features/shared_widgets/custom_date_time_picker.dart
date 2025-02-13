import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class CustomDateTimePicker extends StatefulWidget {
  CustomDateTimePicker({Key? key, required this.title, this.validator})
      : super(key: key);
  final String title;
  String? Function(String?)? validator;
  @override
  _CustomDateTimePickerState createState() => _CustomDateTimePickerState();
}

class _CustomDateTimePickerState extends State<CustomDateTimePicker> {
  late TextEditingController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting();
    Intl.defaultLocale = 'fr_FR';
    _controller = TextEditingController(text: '');
  }

  @override
  Widget build(context) {
    return CupertinoTextField();
  }
}
// dateMask: 'd MMMM, yyyy - hh:mm a',
// onChanged: (val) => setState(() => _controller.text = val.toString()),
//           validator: widget.validator,
//           onSaved: (val) => setState(() => _controller.text = val.toString()),