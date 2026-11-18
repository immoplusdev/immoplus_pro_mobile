/// Modèle représentant le lien de partage généré ou récupéré pour une résidence.
class ResidenceShareLinkModel {
  const ResidenceShareLinkModel({
    required this.residenceId,
    required this.token,
    required this.url,
    required this.status,
    this.createdAt,
  });

  final String residenceId;
  final String token;
  final String url;
  final String status;
  final DateTime? createdAt;

  /// Accepte aussi bien l'enveloppe `{ "data": { ... } }` que l'objet direct.
  factory ResidenceShareLinkModel.fromJson(Map<String, dynamic> json) {
    final source = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;

    final rawCreatedAt = source['createdAt'] as String?;

    return ResidenceShareLinkModel(
      residenceId: source['residenceId'] as String? ?? '',
      token: source['token'] as String? ?? '',
      url: source['url'] as String? ?? '',
      status: source['status'] as String? ?? '',
      createdAt:
          rawCreatedAt != null ? DateTime.tryParse(rawCreatedAt) : null,
    );
  }
}
