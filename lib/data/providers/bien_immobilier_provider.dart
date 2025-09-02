import 'package:dio/dio.dart' hide Headers;
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_collection.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_creation_model.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_single.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/demande_visit_response.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/demande_visite_body_model.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/demande_visite_collection.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/demande_visite_model.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/visit_programmer_body.dart';
import 'package:retrofit/retrofit.dart';

part 'bien_immobilier_provider.g.dart';

@RestApi(
  baseUrl: null,
)
abstract class BienImmobilierProvider {
  factory BienImmobilierProvider(Dio dio, {String baseUrl}) =
      _BienImmobilierProvider;

  //@GET("https://www.npoint.io/docs/5af09fdcad3bdbbbc610")
  @GET("/biens-immobiliers/{id}")
  Future<BienImmobilierSingle> getImmobilier(@Path() String id);

  @GET("/biens-immobiliers")
  Future<BienImmobilierCollection> getImmobiliers(
      @Query("_page") int page,
      @Queries() Map<String, dynamic>? where,
      @Query("_per_page") int perPage,
      @Query("_order_by") String? orderBy,
      @Query("_order_dir") String? orderDir);

  @POST("/biens-immobiliers")
  Future<BienImmobilierSingle> createBienImmobilier(
      @Body() BienImmobilierCreationModel bienImmobilier);

  @PATCH("/biens-immobiliers/{id}")
  Future<BienImmobilierSingle> update(
      @Path() String id, @Body() Map<String, dynamic> fields);

  //VISITE
  @GET("/demandes-visites/{id}")
  Future<DemandeVisitResponse> getVisite(@Path() String id);

  //@GET("https://api.npoint.io/2d556cc695c18d99dd84")
  @GET("/demandes-visites/data/bien-immobilier/owner/{id}")
  Future<DemandeVisiteCollection> getVisiteOwner(
      @Path() String id,
      @Queries() Map<String, dynamic>? where,
      @Query("_page") int page,
      @Query("_per_page") int perPage,
      @Query("_order_by") String? orderBy,
      @Query("_order_dir") String? orderDir);

  @GET("/demandes-visites")
  Future<DemandeVisiteCollection> getVisites(
      @Query("_page") int page,
      @Queries() Map<String, dynamic>? where,
      @Query("_per_page") int perPage,
      @Query("_order_by") String? orderBy,
      @Query("_order_dir") String? orderDir);

  @POST("/demandes-visites")
  Future<DemandeVisiteModel> createVisite(
      @Body() DemandeVisiteBodyModel demandes);

  @POST("/demandes-visites/action/programmer/{id}")
  Future<DemandeVisiteModel> programmer(
      @Path() String id, @Body() VisitProgrammerBody programmer);

  @DELETE("/biens-immobiliers/{id}")
  Future<HttpResponse> deleteBienImmobilier(@Path() String id);
}
