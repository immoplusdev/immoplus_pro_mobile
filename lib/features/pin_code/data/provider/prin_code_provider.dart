import 'package:dio/dio.dart';
import 'package:immoplus_pro/features/pin_code/data/models/has_pin_response.dart';
import 'package:immoplus_pro/features/pin_code/data/models/is_valid_response.dart';
import 'package:immoplus_pro/features/pin_code/data/models/prin_code_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'prin_code_provider.g.dart';

@RestApi(
  baseUrl: null,
)
abstract class PrinCodeProvider {
  factory PrinCodeProvider(Dio dio, {String baseUrl}) = _PrinCodeProvider;

  @POST("/wallet/set-pin")
  Future<HttpResponse> setPin(@Body() PrinCodeDto body);

  @POST("/wallet/verify-pin")
  Future<IsValidResponse> verifyPin(@Body() PrinCodeDto body);

  @GET("/wallet/has-pin")
  Future<HasPinResponse> hasPin();
}
