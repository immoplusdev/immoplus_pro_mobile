import 'package:flutter/material.dart';
import 'package:immoplus_pro/utils/utils.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.text, required this.status});
  final String text;
  final String status;
  @override
  Widget build(BuildContext context) {
    return Chip(
      autofocus: true,
      padding: EdgeInsets.zero,
      shape: StadiumBorder(
          side: BorderSide(color: Utils.getStatusColor(status: status))),
      backgroundColor: Colors.white,
      label: Text(
        text,
        style: TextStyle(
          color: Utils.getStatusColor(status: status),
        ),
      ),
    );
  }
}
