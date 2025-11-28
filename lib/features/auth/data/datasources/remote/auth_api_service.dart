import 'package:dio/dio.dart';
import 'package:logsheet_app/features/auth/data/model/login_response.dart';
import 'package:logsheet_app/features/auth/data/model/logout_response.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_service.g.dart';

@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String baseUrl}) = _AuthApiService;

  @POST("/login")
  Future<LoginResponse> login(@Body()  Map<String, dynamic> body);

   @POST("/logout")
  Future<LogoutResponse> logout( @Header("Authorization") String token);

  
}
