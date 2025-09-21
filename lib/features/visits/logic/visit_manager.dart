import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:immoplus_pro/services/navigation_service.dart';

class VisitManager {
  static Future<DateTime?> getDate(
      {DateTime? lastDate, DateTime? firstDate, DateTime? initialDate}) async {
    if (NavigationService.navigatorKey.currentContext != null) {
      DateTime? datetime = await showDatePicker(
          locale: const Locale("fr", "FR"),
          context: NavigationService.navigatorKey.currentContext!,
          firstDate: firstDate ?? DateTime.now(),
          initialDate: initialDate,
          lastDate: lastDate ?? DateTime(2030));

      inspect(datetime);
      return datetime;
    }
    return null;
  }

  static Future<TimeOfDay?> getTime() async {
    if (NavigationService.navigatorKey.currentContext != null) {
      TimeOfDay? time = await showTimePicker(
        context: NavigationService.navigatorKey.currentContext!,
        initialTime: TimeOfDay.now(),
      );

      inspect(time);
      return time;
    }
    return null;
  }

  static Future<DateTime?> getDateTime({DateTime? lastDate}) async {
    if (NavigationService.navigatorKey.currentContext != null) {
      DateTime? datetime = await getDate(
          lastDate: lastDate, firstDate: lastDate, initialDate: lastDate);
      TimeOfDay? timeOfDay;
      if (datetime != null) {
        timeOfDay = await getTime();
        if (timeOfDay != null) {
          return DateTime(
            datetime.year,
            datetime.month,
            datetime.day,
            timeOfDay.hour,
            timeOfDay.minute,
          );
        }
      }
    }
    return null;
  }
}
