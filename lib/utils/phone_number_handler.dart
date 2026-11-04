class PhoneNumberHandler {
  /// Formate un numéro de téléphone pour l'API : uniquement des chiffres,
  /// sans '+' ni '00' initial (ex: "+225 07 08 69 76 23" -> "2250708697623").
  static String formatPhoneNumber(String phoneNumber) {
    var value = phoneNumber.trim();
    if (!RegExp(r'^\+?[\d\s\-().]+$').hasMatch(value)) return value;
    final hadPlus = value.startsWith('+');
    value = value.replaceAll(RegExp(r'\D'), '');
    if (!hadPlus && value.startsWith('00')) value = value.substring(2);
    return value;
  }
}
