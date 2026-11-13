/// Valeurs de paramètres envoyées à Firebase Analytics.

/// Raccourcis du tableau de bord (`dashboard_action_tapped`).
enum DashboardAction {
  estates('estates'),
  residences('residences'),
  transactions('transactions'),
  scanner('scanner'),
  statistics('statistics'),
  support('support');

  final String value;
  const DashboardAction(this.value);
}

/// Onglets de la barre de navigation principale (`nav_tab_<value>_tapped`).
enum NavTab {
  accueil('accueil'),
  calendrier('calendrier'),
  publier('publier'),
  compte('compte');

  final String value;
  const NavTab(this.value);

  String get eventName => 'nav_tab_${value}_tapped';

  /// Index des branches du `StatefulNavigationShell`
  /// (Accueil, Calendrier, Publier, Messages, Compte).
  /// Retourne `null` pour les onglets qui ne sont pas suivis (Messages).
  static NavTab? fromBranchIndex(int index) => switch (index) {
        0 => NavTab.accueil,
        1 => NavTab.calendrier,
        2 => NavTab.publier,
        4 => NavTab.compte,
        _ => null,
      };
}

/// Motif de refus d'une réservation (`booking_refused.refusal_reason`).
enum RefusalReason {
  calendarUnavailable('calendar_unavailable'),
  priceMismatch('price_mismatch'),
  guestProfile('guest_profile'),
  propertyMaintenance('property_maintenance'),
  other('other');

  final String value;
  const RefusalReason(this.value);

  /// Convertit un code de motif renvoyé/envoyé au backend. Tout code non
  /// reconnu est regroupé sous [RefusalReason.other].
  static RefusalReason fromBackendCode(String? code) =>
      switch (code?.trim().toLowerCase()) {
        'calendar_unavailable' ||
        'dates_indisponibles' =>
          RefusalReason.calendarUnavailable,
        'price_mismatch' => RefusalReason.priceMismatch,
        'guest_profile' => RefusalReason.guestProfile,
        'property_maintenance' ||
        'travaux' =>
          RefusalReason.propertyMaintenance,
        _ => RefusalReason.other,
      };
}

/// Emplacement de la bannière/badge de certification
/// (`certification_banner_viewed` / `certification_banner_tapped`).
enum CertificationPlacement {
  dashboard('dashboard'),
  account('account');

  final String value;
  const CertificationPlacement(this.value);
}
