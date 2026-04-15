import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

enum BookingStatus { upcoming, ongoing, completed }

class BookingUtils {
  static BookingStatus getBookingStatus(DateTime startDate, DateTime endDate) {
    DateTime today = DateTime.now();
    DateTime todayWithoutTime = DateTime(today.year, today.month, today.day);
    DateTime startWithoutTime =
        DateTime(startDate.year, startDate.month, startDate.day);
    DateTime endWithoutTime =
        DateTime(endDate.year, endDate.month, endDate.day);

    if (endWithoutTime.isBefore(todayWithoutTime)) {
      return BookingStatus.completed;
    } else if (startWithoutTime.isAfter(todayWithoutTime)) {
      return BookingStatus.upcoming;
    } else {
      return BookingStatus.ongoing;
    }
  }

  static String getStatusText(
      {required DateTime startDate, required DateTime endDate}) {
    switch (getBookingStatus(startDate, endDate)) {
      case BookingStatus.upcoming:
        return 'Séjour à venir';
      case BookingStatus.ongoing:
        return 'Séjour en cours';
      case BookingStatus.completed:
        return 'Séjour terminé';
    }
  }

  static IconData getStatusIcon(BookingStatus status) {
    switch (status) {
      case BookingStatus.upcoming:
        return Iconsax.calendar_1;
      case BookingStatus.ongoing:
        return Iconsax.timer_1;
      case BookingStatus.completed:
        return Iconsax.tick_circle;
    }
  }

  static Color getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.upcoming:
        return const Color(0xFF3498DB); // Blue
      case BookingStatus.ongoing:
        return const Color(0xFF2ECC71); // Green
      case BookingStatus.completed:
        return const Color(0xFF95A5A6); // Grey
    }
  }
}
