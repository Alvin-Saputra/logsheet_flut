import 'package:dio/dio.dart';
import 'package:logsheet_app/features/auth/data/model/login_response.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST("/login")
  Future<LoginResponse> login(@Body()  Map<String, dynamic> body);
}
