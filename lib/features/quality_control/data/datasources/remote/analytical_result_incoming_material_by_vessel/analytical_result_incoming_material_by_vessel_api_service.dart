import 'package:dio/dio.dart';
import 'package:logsheet_app/features/auth/data/model/login_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_vessel/create_analytical_result_incoming_material_by_vessel_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_vessel/delete_analytical_result_incoming_material_by_vessel_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_vessel/fetch_analytical_result_incoming_material_by_vessel_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_vessel/update_analytical_result_incoming_material_by_vessel_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_vessel/update_approve_reject_analytical_result_incoming_material_by_vessel_response.dart';
import 'package:retrofit/retrofit.dart';

part 'analytical_result_incoming_material_by_vessel_api_service.g.dart';

@RestApi()
abstract class AnalyticalResultIncomingMaterialByVesselApiService {
  factory AnalyticalResultIncomingMaterialByVesselApiService(
    Dio dio, {
    String baseUrl,
  }) = _AnalyticalResultIncomingMaterialByVesselApiService;

  @POST("/arimvess")
  Future<CreateAnalyticalResultIncomingMaterialByVesselResponse> insertReport(
    @Body() Map<String, dynamic> body,
    @Header("Authorization") String token,
  );

  @GET("/arimvess")
  Future<FetchAnalyticalResultIncomingMaterialByVesselResponse> fetchReports(
    @Header("Authorization") String token,
    @Query("plant") String? plantId,
  );

  @DELETE("/arimvess/{id}")
  Future<DeleteAnalyticalResultIncomingMaterialByVesselResponse> deleteReport(
    @Header("Authorization") String token,
    @Path("id") String id,
  );

  @PUT("/arimvess")
  Future<UpdateAnalyticalResultIncomingMaterialByVesselResponse> updateReport(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> body,
  );
  @PUT("/arimvess/approve-reject")
  Future<UpdateApproveRejectAnalyticalResultIncomingMaterialByVesselResponse>
  updateApproveRejectReport(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> body,
  );
}
