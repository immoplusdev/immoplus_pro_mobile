import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:immoplus_pro/modules/logment_creation/utils/creation_residence_manager.dart';

class RuleListTile extends StatefulWidget {
  const RuleListTile({super.key, required this.title, required this.id});
  final String title;
  final int id;
  @override
  State<RuleListTile> createState() => _RuleListTileState();
}

class _RuleListTileState extends State<RuleListTile> {
  final List<bool> _selectedOption = <bool>[false, true];
  final List<Widget> fruits = <Widget>[
    const Text('OUI'),
    const Text('NON'),
  ];

  getElement(int index) {
    if (widget.id == 1) {
      return ResidenceCreationModelBuilder().animauxAutorises;
    } else if (widget.id == 2) {
      return ResidenceCreationModelBuilder().animauxAutorises;
    } else if (widget.id == 3) {
      return ResidenceCreationModelBuilder().animauxAutorises;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      title: Text(widget.title),
      trailing: ToggleButtons(
        direction: Axis.horizontal,
        onPressed: (int index) {
          setState(() {
            // The button that is tapped is set to true, and the others to false.
            for (int i = 0; i < _selectedOption.length; i++) {
              _selectedOption[i] = i == index;
            }
            if (widget.id == 1) {
              ResidenceCreationModelBuilder().animauxAutorises =
                  _selectedOption[0];
            } else if (widget.id == 2) {
              ResidenceCreationModelBuilder().animauxAutorises =
                  _selectedOption[0];
            } else if (widget.id == 3) {
              ResidenceCreationModelBuilder().animauxAutorises =
                  _selectedOption[0];
            }
            //inspect(ResidenceCreationModelBuilder());
          });
        },
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        selectedBorderColor: _selectedOption[0] == true
            ? Colors.green.shade700
            : Colors.red.shade700,
        selectedColor: Colors.white,
        fillColor: _selectedOption[0] == true
            ? Colors.green.shade200
            : Colors.red.shade200,
        color: _selectedOption[0] == false ? Colors.green : Colors.red[400],
        constraints: const BoxConstraints(
          minHeight: 40.0,
          minWidth: 80.0,
        ),
        isSelected: _selectedOption,
        children: fruits,
      ),
    );
  }
}
