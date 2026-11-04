/// Suggestion renvoyée par l'autocomplétion Google Places.
class PlaceSuggestion {
  const PlaceSuggestion({
    required this.placeId,
    required this.description,
    required this.primaryText,
    this.secondaryText,
  });

  final String placeId;

  /// Adresse complète, celle qui sera enregistrée.
  final String description;
  final String primaryText;
  final String? secondaryText;
}
