import 'package:dio/dio.dart' hide Headers;
import 'package:immoplus_pro/data/models/residence/residence_creation_model.dart';
import 'package:immoplus_pro/data/models/residence/residence_response.dart';
import 'package:immoplus_pro/data/models/residence/residences_collection.dart';
import 'package:retrofit/retrofit.dart';

part 'residence_provider.g.dart';

@RestApi(
  baseUrl: null,
)
abstract class ResidenceProvider {
  factory ResidenceProvider(Dio dio, {String baseUrl}) = _ResidenceProvider;

  @GET("/residences/{id}")
  Future<ResidenceResponse> getResidence(@Path() String id);

  @GET("/residences")
  Future<ResidencesCollection> getResidences(
      @Queries() Map<String, dynamic>? where,
      @Query("_page") int page,
      @Query("_order_by") String? orderBy,
      @Query("_order_dir") String? orderDir);

  @POST("/residences")
  Future<ResidenceResponse> createResidence(
      @Body() ResidenceCreationModel residenceCreationModel);

  @PATCH("/residences/{id}")
  Future<ResidenceResponse> update(
      @Path() String id, @Body() Map<String, dynamic> fields);
}
