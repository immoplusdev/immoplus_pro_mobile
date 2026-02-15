import 'package:dio/dio.dart' hide Headers;
import 'package:immoplus_pro/data/models/furniture/furniture_collection_response.dart';
import 'package:immoplus_pro/data/models/furniture/furniture_creation_model.dart';
import 'package:immoplus_pro/data/models/furniture/furniture_single_response.dart';
import 'package:retrofit/retrofit.dart';

part 'furniture_provider.g.dart';

/// Provider Retrofit pour le module Meubles.
///
/// Communique directement avec le backend via les 5 endpoints :
/// - `GET    /furnitures`      → liste paginée (public)
/// - `GET    /furnitures/:id`  → détail (public)
/// - `POST   /furnitures`      → création (auth requise)
/// - `PATCH  /furnitures/:id`  → modification partielle (auth requise)
/// - `DELETE /furnitures/:id`  → suppression soft (auth requise)
///
/// L'[AuthInterceptor] existant ajoute automatiquement le Bearer token.
@RestApi(baseUrl: null)
abstract class FurnitureProvider {
  factory FurnitureProvider(Dio dio, {String baseUrl}) = _FurnitureProvider;

  /// 1️⃣ Liste paginée des meubles.
  ///
  /// Query params supportés par le backend :
  /// - `_page` / `_per_page` → pagination
  /// - `_search` → recherche textuelle (titre, description, adresse)
  /// - `_order_by` / `_order_dir` → tri (ex: prix asc)
  /// - `_where[]` → filtres avancés (passés via [where] en Map)
  @GET("/furnitures")
  Future<FurnitureCollectionResponse> getFurnitures(
    @Query("_page") int page,
    @Query("_per_page") int perPage,
    @Queries() Map<String, dynamic>? where,
    @Query("_search") String? search,
    @Query("_order_by") String? orderBy,
    @Query("_order_dir") String? orderDir,
  );

  /// 2️⃣ Détail d'un meuble par son UUID.
  @GET("/furnitures/{id}")
  Future<FurnitureSingleResponse> getFurniture(@Path() String id);

  /// 3️⃣ Création d'un meuble.
  ///
  /// Requiert un token Bearer (rôles : admin, pro_entreprise, pro_particulier).
  @POST("/furnitures")
  Future<FurnitureSingleResponse> createFurniture(
      @Body() FurnitureCreationModel body);

  /// 4️⃣ Modification partielle d'un meuble.
  ///
  /// Seuls les champs fournis dans [fields] sont mis à jour.
  @PATCH("/furnitures/{id}")
  Future<FurnitureSingleResponse> updateFurniture(
      @Path() String id, @Body() Map<String, dynamic> fields);

  /// 5️⃣ Suppression d'un meuble (soft delete).
  ///
  /// Le meuble reste en base avec `deletedAt` rempli mais n'apparaît plus
  /// dans les listes.
  @DELETE("/furnitures/{id}")
  Future<HttpResponse> deleteFurniture(@Path() String id);
}
