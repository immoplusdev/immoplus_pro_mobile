import 'package:dio/dio.dart' hide Headers;
import 'package:immoplus_pro/data/models/rating/rating_history_response_model.dart';
import 'package:immoplus_pro/data/models/rating/rating_model.dart';
import 'package:retrofit/retrofit.dart';

part 'rating_provider.g.dart';

@RestApi(
  baseUrl: null,
)
abstract class RatingProvider {
  factory RatingProvider(Dio dio, {String baseUrl}) = _RatingProvider;

  @POST("/ratings/host")
  Future<RatingModel> submitRating(@Body() Map<String, dynamic> body);

  @GET("/ratings/history")
  Future<RatingHistoryResponseModel> getRatings(
    @Query("page") int page,
    @Query("pageSize") int? pageSize,
  );
}
