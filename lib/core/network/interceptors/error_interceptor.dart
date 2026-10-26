import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus_pro/core/error/app_error_mapper.dart';
import 'package:immoplus_pro/core/logger/immo_logger.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/core/services/auth_service.dart';
import 'package:immoplus_pro/data/enums/api_error_code.dart';
import 'package:immoplus_pro/data/models/error/api_error_response.dart';
import 'package:immoplus_pro/utils/session_manager.dart';

const _silentErrorCodes = {
  ApiErrorCode.jwtTokenExpired,
  ApiErrorCode.socialAccountNotFound,
};

/// Endpoints dont les erreurs sont gérées entièrement par l'écran appelant
/// (dialog dédié au contexte) ou qui sont des requêtes de fond : aucun retour
/// utilisateur global.
const _silentRequestPaths = {
  '/reservations/action/valider-presence',
  '/reverse-searches/data/invitations/owner',
  '/me/push-installations',
};

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    inspect(err);

    // Parser la réponse d'erreur
    final apiErrorResponse = _parseErrorResponse(err.response);

    // Gestion spéciale du token expiré
    if (apiErrorResponse?.errorCode == ApiErrorCode.jwtTokenExpired) {
      final handled = await _handleTokenExpired(err, handler);
      if (handled) return; // Si traité avec succès, on s'arrête ici
    }

    // L'intercepteur n'affiche aucune UI : il convertit l'erreur technique en
    // AppError (portée par `err.error`) que la feature présente via
    // ErrorFeedback. Les requêtes dont l'écran gère lui-même l'erreur, et
    // les requêtes de fond, sont marquées silencieuses (ou via
    // `Options(extra: {AppErrorMapper.silentKey: true})`).
    final requiresLogout = apiErrorResponse?.requiresLogout == true;
    final isSilent = requiresLogout ||
        _silentErrorCodes.contains(apiErrorResponse?.errorCode) ||
        _silentRequestPaths
            .any((path) => err.requestOptions.path.contains(path));
    final appError = AppErrorMapper.fromDio(err, forceSilent: isSilent);

    // Session invalide : déconnexion (et redirection) gérées ici, donc aucun
    // retour supplémentaire. L'erreur est tout de même propagée pour que les
    // appelants ne restent pas bloqués sur un chargement infini.
    if (requiresLogout) await SessionManager().logout();

    handler.next(err.copyWith(error: appError));
  }

  /// Parse la réponse d'erreur de façon sécurisée
  ApiErrorResponse? _parseErrorResponse(Response? response) {
    try {
      if (response?.data != null && response!.data is Map<String, dynamic>) {
        return ApiErrorResponse.fromJson(response.data);
      }
    } catch (e) {
      log('Erreur lors du parsing de la réponse d\'erreur: $e',
          name: 'ERROR_INTERCEPTOR');
    }
    return null;
  }

  /// Gère spécifiquement l'expiration du token
  Future<bool> _handleTokenExpired(
      DioException err, ErrorInterceptorHandler handler) async {
    ImmoLogger.w('Token expiré, tentative de refresh');

    final refreshSuccess = await AuthService.refreshToken();

    if (refreshSuccess) {
      // Retry la requête avec le nouveau token
      try {
        final response = await DioClient().dio.request(
              err.requestOptions.path,
              data: err.requestOptions.data,
              queryParameters: err.requestOptions.queryParameters,
              options: Options(method: err.requestOptions.method),
            );
        handler.resolve(response);
        return true; // Indique que l'erreur a été traitée
      } catch (retryError) {
        log('Erreur lors du retry: $retryError', name: 'ERROR_INTERCEPTOR');
      }
    } else {
      log('Refresh token échoué', name: 'ERROR_INTERCEPTOR');
      // AuthService a déjà géré la déconnexion si nécessaire
    }

    return false; // Indique que l'erreur n'a pas pu être traitée
  }
}
