class BookingUtils {
  static bool isDateInPastOrToday(DateTime date) {
    DateTime today = DateTime.now();
    // Créer une nouvelle DateTime sans l'heure pour la date actuelle
    DateTime todayWithoutTime = DateTime(today.year, today.month, today.day);
    // Créer une nouvelle DateTime sans l'heure pour la date à comparer
    DateTime dateWithoutTime = DateTime(date.year, date.month, date.day);

    return dateWithoutTime.isBefore(todayWithoutTime) ||
        dateWithoutTime.isAtSameMomentAs(todayWithoutTime);
  }
}
