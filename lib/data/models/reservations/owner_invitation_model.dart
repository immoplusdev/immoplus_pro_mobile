class OwnerInvitationZone {
  final String adresse;
  final double? lat;
  final double? lng;

  const OwnerInvitationZone({required this.adresse, this.lat, this.lng});

  factory OwnerInvitationZone.fromJson(Map<String, dynamic> json) {
    return OwnerInvitationZone(
      adresse: json['adresse'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );
  }
}

/// Une invitation "reverse search" à répondre, aplatie sur UNE résidence
/// (l'API groupe par recherche et peut proposer plusieurs résidences du
/// même propriétaire pour une seule recherche — chaque résidence a son
/// propre statut et se confirme/décline indépendamment côté back, donc on
/// aplatit ici pour avoir une card = une action possible).
class OwnerInvitationItem {
  final String reverseSearchId;
  final String residenceId;
  final int montant;
  final List<OwnerInvitationZone> zones;
  final DateTime dateDebut;
  final DateTime dateFin;
  final int nombrePersonnes;
  final int budgetMin;
  final int budgetMax;
  final DateTime expiresAt;

  const OwnerInvitationItem({
    required this.reverseSearchId,
    required this.residenceId,
    required this.montant,
    required this.zones,
    required this.dateDebut,
    required this.dateFin,
    required this.nombrePersonnes,
    required this.budgetMin,
    required this.budgetMax,
    required this.expiresAt,
  });

  /// Clé unique de la card (une recherche peut proposer plusieurs
  /// résidences du même propriétaire, donc reverseSearchId seul ne suffit
  /// pas à identifier une action).
  String get id => '$reverseSearchId:$residenceId';

  String get zonesLabel =>
      zones.map((z) => z.adresse).where((a) => a.isNotEmpty).join(', ');

  static List<OwnerInvitationItem> listFromJson(List<dynamic> json) {
    final items = <OwnerInvitationItem>[];
    for (final entry in json) {
      final map = entry as Map<String, dynamic>;
      final zones = (map['zones'] as List<dynamic>? ?? [])
          .map((z) => OwnerInvitationZone.fromJson(z as Map<String, dynamic>))
          .toList();
      final dateDebut = DateTime.parse(map['dateDebut'] as String);
      final dateFin = DateTime.parse(map['dateFin'] as String);
      final nombrePersonnes = map['nombrePersonnes'] as int? ?? 1;
      final budgetMin = map['budgetMin'] as int? ?? 0;
      final budgetMax = map['budgetMax'] as int? ?? 0;
      final expiresAt = DateTime.parse(map['expiresAt'] as String);
      final reverseSearchId = map['reverseSearchId'] as String;
      final residencesOffered =
          map['residencesOffered'] as List<dynamic>? ?? [];

      for (final r in residencesOffered) {
        final rm = r as Map<String, dynamic>;
        items.add(OwnerInvitationItem(
          reverseSearchId: reverseSearchId,
          residenceId: rm['residenceId'] as String,
          montant: (rm['montant'] as num).toInt(),
          zones: zones,
          dateDebut: dateDebut,
          dateFin: dateFin,
          nombrePersonnes: nombrePersonnes,
          budgetMin: budgetMin,
          budgetMax: budgetMax,
          expiresAt: expiresAt,
        ));
      }
    }
    return items;
  }
}
