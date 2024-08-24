import 'package:dio/dio.dart' hide Headers;
import 'package:immoplus_pro/data/models/residence/residence_creation_model.dart';
import 'package:immoplus_pro/data/models/residence/residence_response.dart';
import 'package:immoplus_pro/data/models/residence/residences_response.dart';
import 'package:retrofit/http.dart';
import 'package:retrofit/retrofit.dart';

part 'residence_provider.g.dart';

@RestApi(
  baseUrl: null,
)
abstract class ResidenceProvider {
  factory ResidenceProvider(Dio dio, {String baseUrl}) = _ResidenceProvider;

  //@GET("https://www.npoint.io/docs/5af09fdcad3bdbbbc610")
  @GET("/residences/{id}")
  Future<ResidenceResponse> getResidence(@Path() String id);

  @GET("/residences")
  Future<ResidencesResponse> getResidences(@Query("_page") int page);

  @POST("/residences")
  Future<ResidenceResponse> createResidence(
      @Body() ResidenceCreationModel residenceCreationModel);
}
