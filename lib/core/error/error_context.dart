/// Contexte métier d'une erreur : permet de produire des textes orientés
/// action ("Impossible de publier votre annonce") plutôt qu'un message
/// générique.
enum ErrorContext {
  generic(
    title: 'Une erreur est survenue',
    action: 'terminer cette opération',
  ),
  appStartup(
    title: 'Démarrage impossible',
    action: "charger l'application",
  ),
  authentication(
    title: 'Connexion impossible',
    action: 'vous connecter',
  ),
  passwordReset(
    title: 'Réinitialisation impossible',
    action: 'réinitialiser votre mot de passe',
  ),
  profileUpdate(
    title: 'Modification non enregistrée',
    action: 'enregistrer vos modifications',
  ),
  accountDeletion(
    title: 'Suppression impossible',
    action: 'supprimer votre compte',
  ),
  listingLoad(
    title: 'Annonce indisponible',
    action: 'charger cette annonce',
  ),
  listingPublish(
    title: 'Publication impossible',
    action: 'enregistrer votre annonce',
  ),
  reservationLoad(
    title: 'Réservation indisponible',
    action: 'charger cette réservation',
  ),
  reservationAction(
    title: 'Action impossible',
    action: 'traiter cette réservation',
  ),
  withdrawal(
    title: 'Retrait impossible',
    action: 'effectuer votre retrait',
  ),
  wallet(
    title: 'Portefeuille indisponible',
    action: 'charger votre portefeuille',
  ),
  messaging(
    title: 'Messagerie indisponible',
    action: 'accéder à vos messages',
  ),
  demand(
    title: 'Demande impossible',
    action: 'traiter cette demande',
  ),
  rating(
    title: 'Avis indisponibles',
    action: 'charger les avis',
  ),
  calendar(
    title: 'Calendrier indisponible',
    action: 'mettre à jour votre calendrier',
  ),
  certification(
    title: 'Certification impossible',
    action: 'traiter votre demande de certification',
  ),
  fileUpload(
    title: 'Envoi du fichier impossible',
    action: 'envoyer votre fichier',
  ),
  feedLoad(
    title: 'Chargement impossible',
    action: 'charger ce contenu',
  ),
  payment(
    title: 'Paiement non effectué',
    action: 'effectuer votre paiement',
  ),
  pinCode(
    title: 'Code PIN indisponible',
    action: 'traiter votre code PIN',
  );

  const ErrorContext({required this.title, required this.action});

  /// Titre du dialogue.
  final String title;

  /// Action en cours, à la forme infinitive ("impossible de …").
  final String action;
}
