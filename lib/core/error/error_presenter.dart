import 'dart:async';

import 'package:immoplus_pro/data/enums/api_error_code.dart';

/// Couche d'affichage de [ErrorFeedbackCoordinator] : isole l'UI pour que la
/// logique de décision soit testable sans widget.
abstract class ErrorPresenter {
  /// Dialogue standard. [actionLabel]/[onAction] : « Réessayer »,
  /// « Se reconnecter »…
  Future<void> showDialog({
    required String title,
    required String message,
    String? actionLabel,
    FutureOr<void> Function()? onAction,
    String? reference,
  });

  /// Retour léger pour une erreur mineure contextualisée.
  void showToast({required String title, required String message});

  /// Dialogue de perte de connexion, affiché une seule fois. Il se ferme
  /// tout seul au retour du réseau, puis appelle [onRestored] (relance de
  /// l'opération). Se termine quand le dialogue est fermé.
  Future<void> showOfflineDialog({FutureOr<void> Function()? onRestored});

  /// Ferme le dialogue de perte de connexion s'il est ouvert.
  void hideOfflineDialog();

  /// Dialogue dédié à un code d'erreur connu (compte introuvable, numéro déjà
  /// utilisé…, voir `ApiErrorCode.hasDedicatedDialog`). Retourne `true` si un
  /// dialogue a été affiché.
  bool showDedicatedDialog(ApiErrorCode code, {String? message});

  /// Ouvre l'écran de connexion (session expirée).
  void openSignIn();
}
