import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus_pro/features/create_residence/utils/creation_residence_manager.dart';

class TimeSelector extends StatefulWidget {
  const TimeSelector(
      {super.key,
      required this.icon,
      required this.subtitle,
      required this.onUpdate,
      required this.initialValue});
  final Widget icon;
  final String subtitle;
  final void Function(String)? onUpdate;
  final String initialValue;
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
                  colorScheme: const ColorScheme.light(
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
        backgroundColor: CupertinoColors.tertiarySystemFill,
        child: widget.icon,
      ),
      title: Text((_selectedTime == null)
          ? widget.initialValue
          : _selectedTime!.format(context)),
      subtitle: Text(widget.subtitle),
      titleTextStyle: Theme.of(context).textTheme.headlineMedium,
      subtitleTextStyle: Theme.of(context).textTheme.bodySmall,
    );
  }
}
