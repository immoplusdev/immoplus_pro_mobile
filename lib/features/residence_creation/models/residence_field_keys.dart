/// Clés des champs de la configuration (`GET /properties/creation-flow`) qui
/// demandent un traitement particulier. Les autres champs sont envoyés tels
/// quels sous leur propre clé.
abstract class ResidenceFieldKeys {
  static const String name = 'name';
  static const String propertyType = 'propertyType';
  static const String composition = 'composition';
  static const String roomsAndBeds = 'roomsAndBeds';
  static const String address = 'address';
  static const String city = 'city';
  static const String commune = 'commune';
  static const String position = 'position';
  static const String photos = 'photos';
  static const String video = 'video';
  static const String amenityCodes = 'amenityCodes';
  static const String baseNightlyPrice = 'baseNightlyPrice';

  /// Clé du champ du flow -> clés du payload `POST /residences`.
  static const Map<String, List<String>> payloadKeys = {
    name: ['nom'],
    propertyType: ['propertyType', 'typeResidence'],
    composition: ['capacity'],
    roomsAndBeds: ['roomCounts'],
    address: ['adresse'],
    city: ['ville'],
    commune: ['commune'],
    photos: ['images', 'miniature'],
  };

  /// Retrouve le champ du flow correspondant à une clé du payload (utilisé
  /// pour rattacher une erreur du serveur au champ à corriger).
  static String fieldKeyForPayloadKey(String payloadKey) {
    for (final entry in payloadKeys.entries) {
      if (entry.value.contains(payloadKey)) return entry.key;
    }
    return payloadKey;
  }
}
