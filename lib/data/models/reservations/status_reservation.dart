enum StatusReservation {
  rejete,
  terminee,
  valide,
  enCours,
  enAttenteReponseProprietaire,
  enAttentePaiementClient,
  proprietaireAnnuleReservation,
  proprietaireSansReponse,
  clientAnnuleReservation,
  clientSansReponse;

  /// Valeur correspondante dans l'API backend
  String get backendValue {
    switch (this) {
      case StatusReservation.rejete:
        return 'rejete';
      case StatusReservation.terminee:
        return 'terminee';
      case StatusReservation.valide:
        return 'valide';
      case StatusReservation.enCours:
        return 'en_cours';
      case StatusReservation.enAttenteReponseProprietaire:
        return 'en_attente_reponse_proprietaire';
      case StatusReservation.enAttentePaiementClient:
        return 'en_attente_paiement_client';
      case StatusReservation.proprietaireAnnuleReservation:
        return 'proprietaire_annule_reservation';
      case StatusReservation.proprietaireSansReponse:
        return 'proprietaire_sans_reponse';
      case StatusReservation.clientAnnuleReservation:
        return 'client_annule_reservation';
      case StatusReservation.clientSansReponse:
        return 'client_sans_reponse';
    }
  }

  /// Libellé affichable pour l'utilisateur (FR)
  String get label {
    switch (this) {
      case StatusReservation.rejete:
        return 'Refusée';
      case StatusReservation.terminee:
        return 'Terminée';
      case StatusReservation.valide:
        return 'Validée';
      case StatusReservation.enCours:
        return 'En cours';
      case StatusReservation.enAttenteReponseProprietaire:
        return 'En attente de réponse';
      case StatusReservation.enAttentePaiementClient:
        return 'En attente de paiement';
      case StatusReservation.proprietaireAnnuleReservation:
        return 'Annulée';
      case StatusReservation.proprietaireSansReponse:
        return 'Expirée';
      case StatusReservation.clientAnnuleReservation:
        return 'Annulée';
      case StatusReservation.clientSansReponse:
        return 'Expirée';
    }
  }

  static StatusReservation? fromString(String? value) {
    if (value == null) return null;
    try {
      return StatusReservation.values.firstWhere(
        (e) => e.backendValue == value,
      );
    } catch (_) {
      return null;
    }
  }
}
