import 'package:dio/dio.dart' hide Headers;
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_collection.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_creation_model.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/bien_immobilier_model.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/demande_visite_body_model.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/demande_visite_collection.dart';
import 'package:immoplus_pro/data/models/bienimmobilier/demande_visite_model.dart';
import 'package:immoplus_pro/data/models/residence/residence_creation_model.dart';
import 'package:immoplus_pro/data/models/residence/residence_response.dart';
import 'package:immoplus_pro/data/models/residence/residences_response.dart';
import 'package:retrofit/http.dart';
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
  Future<BienImmobilierModel> getImmobilier(@Path() String id);

  @GET("/biens-immobiliers")
  Future<BienImmobilierCollection> getImmobiliers(
      @Query("_page") int page, @Query("_per_page") int perPage);

  @POST("/biens-immobiliers")
  Future<BienImmobilierModel> createBienImmobilier(
      @Body() BienImmobilierCreationModel bienImmobilier);

  @PATCH("/biens-immobiliers")
  Future<ResidenceResponse> update(
      @Body() ResidenceCreationModel bienImmobilier);

  //VISITE
  @GET("/demandes-visites/{id}")
  Future<DemandeVisiteModel> getVisite(@Path() String id);

  @GET("/demandes-visites/data/bien-immobilier/owner/{id}")
  Future<DemandeVisiteCollection> getVisiteOwner(@Path() String id,
      @Query("_page") int page, @Query("_per_page") int perPage);

  @GET("/demandes-visites")
  Future<DemandeVisiteCollection> getVisites(
      @Query("_page") int page, @Query("_per_page") int perPage);

  @POST("/demandes-visites")
  Future<DemandeVisiteModel> createVisite(
      @Body() DemandeVisiteBodyModel demandes);

  @PATCH("/demandes-visites")
  Future<DemandeVisiteModel> updateVisite(
      @Body() DemandeVisiteBodyModel demandes);
}
