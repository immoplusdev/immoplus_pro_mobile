import 'package:dio/dio.dart';
import 'package:immoplus_pro/app_router.dart';
import 'package:immoplus_pro/data/enums/api_error_code.dart';
import 'package:immoplus_pro/data/models/error/api_error_response.dart';
import 'package:immoplus_pro/features/authentification/authentification_page.dart';
import 'package:immoplus_pro/features/login_page/register_page.dart';
import 'package:immoplus_pro/utils/app_dialog.dart';

/// Dialogs dédiés pour les [ApiErrorCode] listés dans
/// [ApiErrorCode.hasDedicatedDialog], utilisés à la fois par
/// [ErrorInterceptor] (erreurs réseau) et par les vérifications côté client
/// (ex: [LoginCubit._checkRole]) pour garantir un seul et même dialog par cas
/// d'erreur, au lieu du toast générique.
class ApiErrorDialog {
  ApiErrorDialog._();

  /// Extrait le [ApiErrorCode] d'une erreur Dio, si le body correspond au
  /// format [ApiErrorResponse]. Retourne `null` si l'erreur n'est pas une
  /// [DioException] ou que le body n'a pas pu être parsé.
  static ApiErrorCode? codeFrom(Object error) {
    if (error is! DioException) return null;
    final data = error.response?.data;
    if (data is! Map<String, dynamic>) return null;
    try {
      return ApiErrorResponse.fromJson(data).errorCode;
    } catch (_) {
      return null;
    }
  }

  /// Affiche le dialog correspondant à [code]. Ne fait rien si [code] n'a
  /// pas de dialog dédié (voir [ApiErrorCode.hasDedicatedDialog]).
  static void showForCode(ApiErrorCode code, {String? message}) {
    switch (code) {
      case ApiErrorCode.userNotFound:
        AppDialog.show(
          title: 'Utilisateur introuvable',
          description:
              message ?? 'Aucun compte ne correspond à ces informations.',
          primaryButtonText: 'Créer un compte',
          secondButtonText: 'Fermer',
          onPrimary: () => AppRouter.router.pushNamed(RegisterPage.name),
        );
        break;
      case ApiErrorCode.phoneNumberAlreadyTaken:
        AppDialog.show(
          title: 'Numéro déjà utilisé',
          description: message ??
              'Ce numéro de téléphone est déjà associé à un compte.',
          primaryButtonText: 'Se connecter',
          secondButtonText: "S'inscrire avec un autre numéro",
          onPrimary: () => AppRouter.router.pushNamed(AuthenticationPage.name),
        );
        break;
      case ApiErrorCode.forbidden:
        AppDialog.show(
          title: 'Compte incompatible',
          description:
              "Ce compte est utilisé sur l'application client ImmoPlus. "
              'Créez un compte avec un autre numéro pour accéder à ImmoPlus Pro.',
          primaryButtonText: 'Créer un compte',
          secondButtonText: 'Fermer',
          onPrimary: () => AppRouter.router.pushNamed(RegisterPage.name),
        );
        break;
      default:
        break;
    }
  }
}
