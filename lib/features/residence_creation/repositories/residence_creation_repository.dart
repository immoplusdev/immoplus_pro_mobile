import 'dart:io';

import 'package:dio/dio.dart';
import 'package:immoplus_pro/core/network/dio_client.dart';
import 'package:immoplus_pro/features/residence_creation/models/catalog.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_flow.dart';
import 'package:immoplus_pro/features/residence_creation/models/creation_values.dart';

class ResidenceCreationRepository {
  ResidenceCreationRepository({Dio? dio}) : _dio = dio ?? DioClient().dio;

  final Dio _dio;

  static const String _intent = 'STAY';

  /// Configuration des étapes et des champs : source de vérité du formulaire.
  Future<CreationFlow> getCreationFlow() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/properties/creation-flow',
      queryParameters: {'intent': _intent},
    );
    return CreationFlow.fromJson(
        response.data!['data'] as Map<String, dynamic>);
  }

  /// Résidence existante (réponse brute) pour préremplir l'édition.
  Future<Map<String, dynamic>> getResidence(String id) async {
    final response = await _dio.get<Map<String, dynamic>>('/residences/$id');
    final data = response.data!['data'];
    return (data is List ? data.first : data) as Map<String, dynamic>;
  }

  /// Modifie une résidence avec le même corps que `POST /residences`.
  Future<void> updateResidence(String id, Map<String, dynamic> payload) async {
    await _dio.patch<dynamic>('/residences/$id', data: payload);
  }

  /// Charge un catalogue à partir du `catalogEndpoint` d'un champ. Les
  /// catalogues « plats » (`items`) sont ramenés à un seul groupe.
  Future<List<CatalogGroup>> getCatalog(
    String catalogEndpoint, {
    String? search,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      catalogEndpoint,
      queryParameters: {
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    final data = response.data!['data'] as Map<String, dynamic>;

    if (data['categories'] is List) {
      return (data['categories'] as List)
          .map((e) => CatalogGroup.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    final items = (data['items'] as List? ?? [])
        .map((e) => CatalogItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return [CatalogGroup(key: '', label: '', items: items)];
  }

  static const Map<String, String> _mimeByExtension = {
    'jpg': 'image/jpeg',
    'jpeg': 'image/jpeg',
    'png': 'image/png',
    'webp': 'image/webp',
    'heic': 'image/heic',
    'heif': 'image/heif',
    'gif': 'image/gif',
    'mp4': 'video/mp4',
    'mov': 'video/quicktime',
    'm4v': 'video/x-m4v',
    '3gp': 'video/3gpp',
    'webm': 'video/webm',
  };

  /// Le serveur refuse `application/octet-stream` : on déclare le vrai type
  /// d'après l'extension (le type du fichier n'est pas deviné par Dio).
  static DioMediaType? _mediaTypeOf(String path) {
    final dot = path.lastIndexOf('.');
    if (dot < 0) return null;
    final mime = _mimeByExtension[path.substring(dot + 1).toLowerCase()];
    return mime == null ? null : DioMediaType.parse(mime);
  }

  /// Envoie un fichier (photo ou vidéo) vers `POST /files` et retourne son
  /// identifiant. Le nouveau format de `POST /residences` attend des fichiers
  /// envoyés par cet endpoint authentifié, et non par `/files/public`.
  Future<String> uploadFile(File file) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/files',
      data: FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.uri.pathSegments.last,
          contentType: _mediaTypeOf(file.path),
        ),
      }),
    );
    return (response.data!['data'] as Map<String, dynamic>)['id'] as String;
  }

  /// Création finale. Les erreurs de validation sont propagées telles quelles
  /// ([DioException]) pour être rattachées aux champs concernés.
  Future<CreatedResidence> createResidence(Map<String, dynamic> payload) async {
    final response =
        await _dio.post<Map<String, dynamic>>('/residences', data: payload);
    return CreatedResidence.fromJson(
        response.data!['data'] as Map<String, dynamic>);
  }
}
