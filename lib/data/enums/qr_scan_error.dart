/// Échecs de validation de présence renvoyés par
/// `POST /reservations/action/valider-presence`.
enum QrScanError {
  expired(
    analyticsValue: 'expired',
    backendMessage: 'Le QR code a expiré. Veuillez générer un nouveau QR code.',
    title: 'QR code expiré',
    description:
        'Le QR code a expiré. Demandez au client de générer un nouveau QR code puis réessayez.',
  ),
  invalid(
    analyticsValue: 'invalid',
    backendMessage: 'QR code invalide.',
    title: 'QR code invalide',
    description:
        "Ce QR code n'est pas reconnu. Vérifiez qu'il s'agit bien du QR code de réservation du client.",
  ),
  forbidden(
    analyticsValue: 'forbidden',
    backendMessage: 'Accès interdit',
    title: 'Accès refusé',
    description: "Vous n'êtes pas autorisé à valider cette réservation.",
  ),
  unpaid(
    analyticsValue: 'unpaid',
    backendMessage: "La réservation n'est pas encore payée.",
    title: 'Réservation non payée',
    description:
        "La réservation n'est pas encore payée. La présence ne peut pas être validée tant que le paiement n'est pas effectué.",
  ),
  alreadyValidated(
    analyticsValue: 'already_validated',
    backendMessage:
        'La présence du client a déjà été validée pour cette réservation.',
    title: 'Présence déjà validée',
    description:
        'La présence du client a déjà été validée pour cette réservation.',
  ),
  alreadyUsed(
    analyticsValue: 'already_used',
    backendMessage: 'Ce QR code a déjà été utilisé.',
    title: 'QR code déjà utilisé',
    description:
        'Ce QR code a déjà été utilisé et ne peut plus servir à valider une présence.',
  ),
  unknown(
    analyticsValue: 'unknown',
    backendMessage: '',
    title: 'Échec de la validation',
    description: '',
  );

  final String analyticsValue;
  final String backendMessage;
  final String title;
  final String description;

  const QrScanError({
    required this.analyticsValue,
    required this.backendMessage,
    required this.title,
    required this.description,
  });

  static QrScanError fromBackendMessage(String? message) =>
      QrScanError.values.firstWhere(
        (e) => e != QrScanError.unknown && e.backendMessage == message,
        orElse: () => QrScanError.unknown,
      );
}
