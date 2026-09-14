/// Filtres de vue pour l'API /alerts
enum AlertViewFilter {
  all('all', 'Tous'),
  demands('demands', 'Demandes'),
  myProposals('my-proposals', 'Propositions');

  final String value;
  final String label;
  const AlertViewFilter(this.value, this.label);

  static AlertViewFilter fromValue(String? value) {
    return AlertViewFilter.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AlertViewFilter.all,
    );
  }
}

/// Statuts d'une Alerte côté marketplace
enum StatusAlert {
  pending('pending', 'En attente'),
  active('active', 'Active'),
  hasProposals('has_proposals', 'Avec propositions');

  final String value;
  final String label;
  const StatusAlert(this.value, this.label);

  static StatusAlert fromValue(String? value) {
    return StatusAlert.values.firstWhere(
      (e) => e.value == value,
      orElse: () => StatusAlert.active,
    );
  }
}

/// Statuts d'une Proposition soumise par un Pro
enum AlertProposalStatus {
  pending('pending', 'En attente'),
  accepted('accepted', 'Acceptée'),
  rejected('rejected', 'Refusée'),
  withdrawn('withdrawn', 'Retirée');

  final String value;
  final String label;
  const AlertProposalStatus(this.value, this.label);

  static AlertProposalStatus fromValue(String? value) {
    return AlertProposalStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AlertProposalStatus.pending,
    );
  }
}

/// Ordre de tri des alertes
enum AlertSortBy {
  recent('recent'),
  oldest('oldest');

  final String value;
  const AlertSortBy(this.value);
}

/// Scope des alertes
enum AlertScope {
  marketplace('marketplace');

  final String value;
  const AlertScope(this.value);
}
