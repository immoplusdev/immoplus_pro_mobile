import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:immoplus_pro/core/services/auth_service.dart';
import 'package:immoplus_pro/core/logger/immo_logger.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/data/enums/api_error_code.dart';
import 'package:immoplus_pro/data/models/error/api_error_response.dart';
import 'package:immoplus_pro/services/navigation_service.dart';
import 'package:immoplus_pro/utils/session_manager.dart';
import 'package:toastification/toastification.dart';

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

    // Afficher le toast d'erreur (sauf pour token expiré qui sera géré par refresh)
    if (apiErrorResponse?.errorCode != ApiErrorCode.jwtTokenExpired) {
      _showErrorToast(apiErrorResponse, err.response);
    }

    // Gérer la déconnexion si nécessaire
    if (apiErrorResponse?.requiresLogout == true) {
      await SessionManager().logout();
      return; // Pas besoin d'appeler super.onError après déconnexion
    }

    super.onError(err, handler);
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

  /// Affiche le toast d'erreur approprié
  void _showErrorToast(ApiErrorResponse? apiErrorResponse, Response? response) {
    final context = NavigationService.navigatorKey.currentContext;
    if (context == null) return;

    toastification.show(
      type: ToastificationType.error,
      context: context,
      title: const Text("Oops, quelque chose s'est mal passé."),
      description: Text(
        apiErrorResponse?.message ?? _manageResponse(response),
        maxLines: 6,
      ),
      autoCloseDuration: const Duration(seconds: 5),
      showProgressBar: false,
      alignment: Alignment.bottomCenter,
      style: ToastificationStyle.flatColored,
    );
  }

  _manageResponse(Response? response) {
    if (response?.data != null) {
      if (response?.data['message'] != null) {
        return response?.data['message'];
      }
    }

    return _getMessageFromStatusCode(response?.statusCode);
  }

  /// Messages de fallback basés sur les codes de statut HTTP
  String _getMessageFromStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Nous avons rencontré une erreur lors du traitement de votre requête.';
      case 401:
        return "Non autorisé : Vous n'avez pas les permissions nécessaires.";
      case 403:
        return "Accès interdit : Vous n'êtes pas autorisé à accéder à cette ressource.";
      case 404:
        return "Ressource introuvable : La page que vous recherchez n'existe pas.";
      case 405:
        return "Méthode non autorisée : La méthode HTTP utilisée n'est pas supportée pour cette ressource.";
      case 500:
        return "Erreur interne du serveur : Une erreur inattendue s'est produite.";
      case 502:
        return "Bad Gateway : Le serveur a reçu une réponse invalide d'un serveur en amont.";
      case 503:
        return "Service indisponible : Le serveur est temporairement indisponible.";
      default:
        return "Une erreur inconnue ($statusCode) s'est produite. ";
    }
  }
}
