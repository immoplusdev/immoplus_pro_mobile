/// Empêche deux [ShowCaseWidget] indépendants (Dashboard, Calendrier) de
/// démarrer un tutoriel en même temps. showcaseview ne le gère pas lui-même
/// car chaque page possède sa propre instance de [ShowCaseWidget] — cette
/// classe sert de verrou partagé entre elles.
class ShowcaseCoordinator {
  ShowcaseCoordinator._();

  static bool _isRunning = false;

  /// Réserve le tutoriel. Retourne `false` si un autre showcase est déjà
  /// en cours ailleurs dans l'app — dans ce cas, ne pas démarrer.
  static bool tryAcquire() {
    if (_isRunning) return false;
    _isRunning = true;
    return true;
  }

  /// À appeler quand un showcase se termine (ou est annulé avant de démarrer)
  /// pour libérer le verrou.
  static void release() {
    _isRunning = false;
  }
}
