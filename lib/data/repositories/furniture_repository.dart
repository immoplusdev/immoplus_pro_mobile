import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/data/models/furniture/furniture_collection_response.dart';
import 'package:immoplus_pro/data/models/furniture/furniture_creation_model.dart';
import 'package:immoplus_pro/data/models/furniture/furniture_single_response.dart';
import 'package:immoplus_pro/data/providers/furniture_provider.dart';

/// Repository pour le module Meubles.
///
/// Utilise [FurnitureDioClient] (API locale) au lieu du [DioClient] global.
/// L'[AuthInterceptor] est conservé pour transmettre le Bearer token.
///
/// ⚠️  Pour basculer en production, remplacer [FurnitureDioClient] par [DioClient].
class FurnitureRepository {
  static FurnitureProvider get _provider => FurnitureProvider(DioClient().dio);

  static String _dioErrorMessage(DioException dioError) {
    final statusCode = dioError.response?.statusCode;
    final data = dioError.response?.data;
    final serverMessage = switch (data) {
      {'message': final String message} => message,
      {'error': final String error} => error,
      _ => null,
    };

    return [
      if (statusCode != null) 'HTTP $statusCode',
      if (serverMessage != null && serverMessage.isNotEmpty) serverMessage,
      if (dioError.message != null) dioError.message!,
    ].join(' | ');
  }

  /// Liste paginée des meubles.
  ///
  /// Paramètres par défaut : page 1, 10 éléments, triés par date de création desc.
  static Future<FurnitureCollectionResponse> getFurnitures({
    int page = 1,
    int perPage = 10,
    String? search,
    Map<String, dynamic>? where,
    String? orderBy = 'createdAt',
    String? orderDir = 'desc',
  }) async {
    try {
      final response = await _provider.getFurnitures(
          page, perPage, where, search, orderBy, orderDir);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      final errorMessage = _dioErrorMessage(dioError);
      log('DioError getFurnitures: $errorMessage', name: 'FURNITURE_REPO');
      throw Exception('Échec du chargement des meubles : $errorMessage');
    } catch (error, s) {
      log('Error: $error $s', name: 'FURNITURE_REPO');
      throw Exception('Échec du chargement des meubles : $error');
    }
  }

  /// Détail d'un meuble par son UUID.
  static Future<FurnitureSingleResponse> getFurniture(String id) async {
    try {
      final response = await _provider.getFurniture(id);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      final errorMessage = _dioErrorMessage(dioError);
      log('DioError getFurniture: $errorMessage', name: 'FURNITURE_REPO');
      throw Exception('Échec du chargement du meuble : $errorMessage');
    } catch (error) {
      log('Error: $error', name: 'FURNITURE_REPO');
      throw Exception('Échec du chargement du meuble : $error');
    }
  }

  /// Création d'un meuble.
  ///
  /// Requiert un token Bearer (rôles : admin, pro_entreprise, pro_particulier).
  static Future<FurnitureSingleResponse> createFurniture(
      {required FurnitureCreationModel model}) async {
    try {
      final payload = model.toJson();
      log('POST /furnitures payload: $payload', name: 'FURNITURE_REPO');
      final response = await _provider.createFurniture(model);
      log('POST /furnitures response data: ${response.data?.toJson()}',
          name: 'FURNITURE_REPO');
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      final errorMessage = _dioErrorMessage(dioError);
      log('DioError createFurniture: $errorMessage', name: 'FURNITURE_REPO');
      throw Exception('Échec de la création du meuble : $errorMessage');
    } catch (error) {
      log('Error: $error', name: 'FURNITURE_REPO');
      throw Exception('Échec de la création du meuble : $error');
    }
  }

  /// Modification partielle d'un meuble.
  ///
  /// Seuls les champs fournis dans [fields] sont mis à jour (PATCH).
  static Future<FurnitureSingleResponse> updateFurniture(
      {required String id, required Map<String, dynamic> fields}) async {
    try {
      final response = await _provider.updateFurniture(id, fields);
      inspect(response);
      return response;
    } on DioException catch (dioError) {
      final errorMessage = _dioErrorMessage(dioError);
      log('DioError updateFurniture: $errorMessage', name: 'FURNITURE_REPO');
      throw Exception('Échec de la modification du meuble : $errorMessage');
    } catch (error) {
      log('Error: $error', name: 'FURNITURE_REPO');
      throw Exception('Échec de la modification du meuble : $error');
    }
  }

  /// Suppression d'un meuble (soft delete).
  ///
  /// Retourne `true` si la suppression a réussi, `false` sinon.
  static Future<bool> deleteFurniture({required String id}) async {
    try {
      final httpResponse = await _provider.deleteFurniture(id);

      if (httpResponse.response.statusCode == 200) {
        log('Meuble supprimé avec succès : $id', name: 'FURNITURE_REPO');
        return true;
      } else {
        log('Erreur lors de la suppression : ${httpResponse.response.statusCode}',
            name: 'FURNITURE_REPO');
        return false;
      }
    } on DioException catch (dioError) {
      final errorMessage = _dioErrorMessage(dioError);
      log('DioError deleteFurniture: $errorMessage', name: 'FURNITURE_REPO');
      throw Exception('Échec de la suppression du meuble : $errorMessage');
    } catch (error) {
      log('Error: $error', name: 'FURNITURE_REPO');
      throw Exception('Échec de la suppression du meuble : $error');
    }
  }
}
