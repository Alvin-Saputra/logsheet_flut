import 'package:dio/dio.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_plant_fuel/create_analytical_result_incoming_plant_fuel_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_plant_fuel/delete_analytical_result_incoming_plant_fuel_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_plant_fuel/fetch_analytical_result_incoming_plant_fuel_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_plant_fuel/update_analytical_result_incoming_plant_fuel_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_plant_fuel/update_approve_reject_analytical_result_incoming_plant_fuel_response.dart';
import 'package:retrofit/retrofit.dart';

part 'analytical_result_incoming_plant_fuel_api_service.g.dart';

@RestApi()
abstract class AnalyticalResultIncomingPlantFuelApiService {
  factory AnalyticalResultIncomingPlantFuelApiService(
    Dio dio, {
    String baseUrl,
  }) = _AnalyticalResultIncomingPlantFuelApiService;

  @POST("/aroipfuel")
  Future<CreateAnalyticalResultIncomingPlantFuelResponse> insertReport(
    @Body() Map<String, dynamic> body,
    @Header("Authorization") String token,
  );

  @GET("/aroipfuel")
  Future<FetchAnalyticalResultIncomingPlantFuelResponse> fetchReports(
    @Header("Authorization") String token,
     @Query("plant") String? plantId,
    @Query("entry_date") String? date,
  );

  @DELETE("/aroipfuel/{id}")
  Future<DeleteAnalyticalResultIncomingPlantFuelResponse> deleteReport(
    @Header("Authorization") String token,
    @Path("id") String id,
  );

  @PUT("/aroipfuel/{id}")
  Future<UpdateAnalyticalResultIncomingPlantFuelResponse>
  updateReport(
    @Header("Authorization") String token,
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );

  @PUT("/aroipfuel/{id}/approve")
  Future<UpdateApproveRejectAnalyticalResultIncomingPlantFuelResponse>
  updateApprovalReport(
    @Header("Authorization") String token,
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );
}
