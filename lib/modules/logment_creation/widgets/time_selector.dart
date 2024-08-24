import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/creation_residence_manager.dart';

class TimeSelector extends StatefulWidget {
  const TimeSelector(
      {super.key,
      required this.icon,
      required this.subtitle,
      required this.onUpdate});
  final Widget icon;
  final String subtitle;
  final void Function(String)? onUpdate;
  @override
  State<TimeSelector> createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  TimeOfDay? _selectedTime;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showTimePicker(
          initialTime: TimeOfDay.now(),
          context: context,
          builder: (context, child) => Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Colors.cyan,
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: Colors.blue, //
                      onSurface: Colors.black, //
                      surface: Colors.white, //background
                    ),
                buttonTheme: ButtonTheme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    secondary: Colors
                        .cyan, // Color you want for action buttons (CANCEL and OK)
                  ),
                ),
              ),
              child: child!),
        ).then(
          (value) => setState(
            () {
              _selectedTime = value;
              widget.onUpdate!(_selectedTime!.format(context));
            },
          ),
        );
      },
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      leading: CircleAvatar(
        child: widget.icon,
        backgroundColor: CupertinoColors.tertiarySystemFill,
      ),
      title: Text(
          (_selectedTime == null) ? '00:00' : _selectedTime!.format(context)),
      subtitle: Text(widget.subtitle),
      titleTextStyle: Theme.of(context).textTheme.headlineMedium,
      subtitleTextStyle: Theme.of(context).textTheme.bodySmall,
    );
  }
}
