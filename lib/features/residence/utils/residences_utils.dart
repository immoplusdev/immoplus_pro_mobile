import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ResidencesUtils {
  static String getValidationStatusName(String status) {
    if (status == 'valide') {
      return 'Validé';
    } else if (status == 'rejete') {
      return 'Rejeté';
    }
    return 'En validation';
  }

  static IconData getValidationStatusIcon(String status) {
    if (status == 'valide') {
      return FontAwesomeIcons.circleCheck.data;
    } else if (status == 'rejete') {
      return FontAwesomeIcons.xmark.data;
    }
    return FontAwesomeIcons.clock.data;
  }

  static Color getValidationStatusColor(String status) {
    if (status == 'valide') {
      return Colors.green;
    } else if (status == 'rejete') {
      return Colors.red;
    }
    return Colors.blueGrey;
  }
}
