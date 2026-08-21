import 'dart:developer';
import 'package:immoplus_pro/utils/utils.dart';

/// Une invitation "reverse search" à répondre : un client cherche une
/// résidence correspondant à ses critères et celle-ci est éligible. L'API
/// renvoie déjà une entrée par résidence (plus de wrapper `residencesOffered`
/// groupé par recherche — chaque objet est directement actionnable).
class OwnerInvitationItem {
  final String reverseSearchId;
  final String residenceId;
  final String nom;
  final String adresse;
  final String? miniatureId;
  final String? miniatureUrl;
  final int montant;
  final DateTime dateDebut;
  final DateTime dateFin;
  final DateTime expiresAt;

  const OwnerInvitationItem({
    required this.reverseSearchId,
    required this.residenceId,
    required this.nom,
    required this.adresse,
    this.miniatureId,
    this.miniatureUrl,
    required this.montant,
    required this.dateDebut,
    required this.dateFin,
    required this.expiresAt,
  });

  /// Clé unique de la card (une recherche peut proposer plusieurs
  /// résidences du même propriétaire, donc reverseSearchId seul ne suffit
  /// pas à identifier une action).
  String get id => '$reverseSearchId:$residenceId';

  /// Calcule l'URL d'image résolue : si miniatureId/Url est un identifiant UUID,
  /// utilise Utils.getImagePath(id: id) ; si c'est une URL complète http(s), l'utilise directement.
  String? get resolvedImageUrl {
    final raw = miniatureId ?? miniatureUrl;
    if (raw == null || raw.isEmpty) return null;
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;
    return Utils.getImagePath(id: raw);
  }

  /// Parse la liste brute en cards. Chaque entrée est parsée
  /// indépendamment : une entrée malformée ne doit jamais faire planter
  /// tout le reste de la liste, elle est simplement ignorée (et loguée) au
  /// lieu de faire disparaître toutes les invitations valides d'un coup.
  static List<OwnerInvitationItem> listFromJson(List<dynamic> json) {
    final items = <OwnerInvitationItem>[];
    for (final entry in json) {
      try {
        final map = entry as Map<String, dynamic>;
        final rawMiniatureId = (map['miniatureId'] as String?) ?? (map['miniatureUrl'] as String?);
        items.add(OwnerInvitationItem(
          reverseSearchId: map['reverseSearchId'] as String,
          residenceId: map['residenceId'] as String,
          nom: map['nom'] as String? ?? '',
          adresse: map['adresse'] as String? ?? '',
          miniatureId: map['miniatureId'] as String?,
          miniatureUrl: map['miniatureUrl'] as String? ?? rawMiniatureId,
          montant: (map['montant'] as num?)?.toInt() ?? 0,
          dateDebut: DateTime.parse(map['dateDebut'] as String),
          dateFin: DateTime.parse(map['dateFin'] as String),
          expiresAt: DateTime.parse(map['expiresAt'] as String),
        ));
      } catch (e) {
        log(
          'Invitation ignorée (champ manquant/invalide), entrée brute: '
          '$entry, erreur: $e',
          name: 'OWNER_INVITATIONS_PARSE',
        );
      }
    }
    return items;
  }
}
