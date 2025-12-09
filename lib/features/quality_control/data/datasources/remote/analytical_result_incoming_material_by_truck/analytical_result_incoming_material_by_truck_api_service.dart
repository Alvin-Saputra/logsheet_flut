import 'package:dio/dio.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_truck/create_analytical_result_incoming_material_by_truck_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_truck/delete_analytical_result_incoming_material_by_truck_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_truck/fetch_analytical_result_incoming_material_by_truck_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_truck/update_analytical_result_incoming_material_by_truck_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_truck/update_approve_reject_analytical_result_incoming_material_by_truck_response.dart';
import 'package:retrofit/retrofit.dart';

part 'analytical_result_incoming_material_by_truck_api_service.g.dart';

@RestApi()
abstract class AnalyticalResultIncomingMaterialByTruckApiService {
  factory AnalyticalResultIncomingMaterialByTruckApiService(
    Dio dio, {
    String baseUrl,
  }) = _AnalyticalResultIncomingMaterialByTruckApiService;

  @POST("/arimtruck")
  Future<CreateAnalyticalResultIncomingMaterialByTruckResponse> insertReport(
    @Body() Map<String, dynamic> body,
    @Header("Authorization") String token,
  );

  @GET("/arimtruck")
  Future<FetchAnalyticalResultIncomingMaterialByTruckResponse> fetchReports(
    @Header("Authorization") String token,
    @Query("plant") String? plantId,
    @Query("date") String? date,
  );

  @DELETE("/arimtruck/{id}")
  Future<DeleteAnalyticalResultIncomingMaterialByTruckResponse> deleteReport(
    @Header("Authorization") String token,
    @Path("id") String id,
  );

  @PUT("/arimtruck")
  Future<UpdateAnalyticalResultIncomingMaterialByTruckResponse> updateReport(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> body,
  );

  @PUT("/arimtruck/approve-reject")
  Future<UpdateApproveRejectAnalyticalResultIncomingMaterialByTruckResponse>
  updateApproveRejectReport(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> body,
  );
}
