import 'dart:async';

import 'package:dio/dio.dart';
import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/core/error/app_error.dart';
import 'package:immoplus_pro/core/error/app_error_mapper.dart';
import 'package:immoplus_pro/core/error/error_context.dart';
import 'package:immoplus_pro/core/error/error_feedback_coordinator.dart';

/// Façade d'accès à [ErrorFeedbackCoordinator] pour les `catch` des features.
///
/// ```dart
/// try { await repository.submit(); }
/// catch (e) { ErrorFeedback.show(e, context: ErrorContext.bookingSubmission); }
/// ```
///
/// `retry` : à fournir uniquement si l'opération est sûre à relancer
/// (lecture, envoi d'un code…). Jamais pour un paiement ou une création.
abstract final class ErrorFeedback {
  static ErrorFeedbackCoordinator get _coordinator =>
      getIt<ErrorFeedbackCoordinator>();

  /// Présente l'exception attrapée si c'est une erreur d'API ([AppError] ou
  /// `DioException`) et retourne `true`. Retourne `false` quand rien n'a été
  /// présenté (erreur hors API comme plugin ou parsing, ou requête
  /// silencieuse), pour que l'appelant applique son propre retour.
  static bool show(
    Object thrown, {
    required ErrorContext context,
    FutureOr<void> Function()? retry,
  }) =>
      _coordinator.presentThrown(thrown, context: context, retry: retry);

  /// Pour une saisie vérifiée par le serveur (code OTP, mot de passe…) : les
  /// refus liés à la saisie (métier, validation, 401) sont affichés sous le
  /// champ par l'écran ; seules les pannes (403, réseau, serveur…) passent
  /// par le feedback global. Retourne `true` si l'erreur a été présentée.
  static bool showUnlessInputRefusal(
    Object thrown, {
    required ErrorContext context,
  }) {
    final error = thrown is AppError || thrown is DioException
        ? AppErrorMapper.from(thrown)
        : null;
    if (error == null || isInputRefusal(error)) return false;
    present(error, context: context);
    return !error.silent;
  }

  /// Refus lié à la saisie de l'utilisateur (code invalide, mot de passe…).
  static bool isInputRefusal(AppError error) =>
      error is BusinessError ||
      error is ValidationError ||
      error is UnauthorizedError;

  /// Présente une [AppError] déjà typée.
  static void present(
    AppError error, {
    required ErrorContext context,
    FutureOr<void> Function()? retry,
  }) =>
      _coordinator.present(error: error, context: context, retry: retry);

  /// Le réseau est de retour : ferme le dialogue « Pas de connexion ».
  static void connectionRestored() => _coordinator.onConnectionRestored();
}
