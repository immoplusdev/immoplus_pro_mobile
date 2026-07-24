import 'dart:async';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:immoplus_pro/data/models/auth/refresh_token_body.dart';
import 'package:immoplus_pro/data/models/auth/refresh_token_response.dart';

import 'package:immoplus_pro/core/injection.dart';
import 'package:immoplus_pro/data/models/error/api_error_response.dart';
import 'package:immoplus_pro/data/schemas/user_model_schema.dart';
import 'package:immoplus_pro/request_path.dart';
import 'package:immoplus_pro/services/reservation_socket_service.dart';
import 'package:immoplus_pro/utils/session_manager.dart';

class AuthService {
  /// Refresh le token d'accès
  static Future<bool> refreshToken() async {
    try {
      // Récupérer le refresh token actuel
      final currentUser = await SessionManager().getCurrentUser();
      final refreshToken = currentUser?.refreshToken;

      if (refreshToken == null || currentUser == null) {
        log('Pas de refresh token disponible', name: 'AUTH_SERVICE');
        await SessionManager().logout();
        return false;
      }

      // Créer le body de la requête
      final body = RefreshTokenBody(refreshToken: refreshToken);

      // Instance Dio séparée pour éviter la récursion
      final dio = Dio();
      dio.options.baseUrl = RequestPath.baseUrl;

      final response = await dio.post(
        '/auth/refresh-token',
        data: body.toJson(),
      );

      // Parser la réponse
      final refreshResponse = RefreshTokenResponse.fromJson(response.data);

      // Mettre à jour l'utilisateur avec les nouveaux tokens
      final updatedUser = UserModelSchema()
        ..userId = currentUser.userId
        ..firstName = currentUser.firstName
        ..lastName = currentUser.lastName
        ..phoneNumber = currentUser.phoneNumber
        ..email = currentUser.email
        ..avatar = currentUser.avatar
        ..accessToken = refreshResponse.data.accessToken
        ..refreshToken = refreshResponse.data.refreshToken
        ..roleName = currentUser.roleName
        ..activite = currentUser.activite
        ..nomEntreprise = currentUser.nomEntreprise
        ..emailEntreprise = currentUser.emailEntreprise
        ..photoIdentite = currentUser.photoIdentite
        ..pieceIdentite = currentUser.pieceIdentite
        ..pieceIdentiteVerso = currentUser.pieceIdentiteVerso
        ..lieuNaissance = currentUser.lieuNaissance
        ..registreCommerce = currentUser.registreCommerce
        ..numeroContribuable = currentUser.numeroContribuable
        ..typeEntreprise = currentUser.typeEntreprise
        ..avatar = currentUser.avatar
        ..role = currentUser.role
        ..identityVerified = currentUser.identityVerified
        ..createdAt = currentUser.createdAt;

      // Sauvegarder en session
      await SessionManager().saveUser(updatedUser);

      // Le socket réservations doit être rouvert avec le nouveau token :
      // le handshake n'est vérifié qu'à la connexion, pas en continu.
      getIt<ReservationSocketService>().connect();

      log('Token refresh réussi', name: 'AUTH_SERVICE');
      return true;
    } on DioException catch (e) {
      // Si c'est une erreur de refresh token invalide, déconnecter
      if (e.response?.data != null) {
        try {
          final errorResponse = ApiErrorResponse.fromJson(e.response!.data);
          if (errorResponse.requiresLogout) {
            await SessionManager().logout();
          }
        } catch (parseError) {
          log('Erreur parsing response: $parseError', name: 'AUTH_SERVICE');
        }
      }
      return false;
    } catch (e) {
      log('Erreur lors du refresh token: $e', name: 'AUTH_SERVICE');
      return false;
    }
  }
}
