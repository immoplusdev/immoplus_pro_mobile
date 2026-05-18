import 'package:dio/dio.dart' hide Headers;
import 'package:immoplus_pro/data/models/banners/banner_model.dart';
import 'package:retrofit/retrofit.dart';

part 'banner_provider.g.dart';

@RestApi(
  baseUrl: null,
)
abstract class BannerProvider {
  factory BannerProvider(Dio dio, {String baseUrl}) = _BannerProvider;

  @GET("/banners")
  Future<BannerResponse> getBanners(
    @Query("source") String source,
  );
}
