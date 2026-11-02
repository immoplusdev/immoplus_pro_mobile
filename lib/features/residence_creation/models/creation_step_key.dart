/// Clés d'étapes connues de l'interface, avec le libellé court affiché dans
/// la pastille « Étape 01 · Mon bien ». Une étape inconnue (ajoutée plus tard
/// par l'API) garde son titre comme libellé.
enum CreationStepKey {
  property('property', 'Mon bien'),
  location('location', 'Localisation'),
  amenities('amenities', 'Équipements'),
  presentation('presentation', 'Présentation'),
  rulesPricing('rules_pricing', 'Règles et prix'),
  booking('booking', 'Réservations'),
  unknown('', '');

  final String value;
  final String shortLabel;
  const CreationStepKey(this.value, this.shortLabel);

  static CreationStepKey fromValue(String value) =>
      CreationStepKey.values.firstWhere(
        (e) => e != CreationStepKey.unknown && e.value == value,
        orElse: () => CreationStepKey.unknown,
      );
}
