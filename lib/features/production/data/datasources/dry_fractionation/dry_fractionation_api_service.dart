import 'package:dio/dio.dart';
import 'package:logsheet_app/features/production/data/model/dry_fractionation/remote/create_dry_fractionation_response.dart';
import 'package:logsheet_app/features/production/data/model/dry_fractionation/remote/delete_dry_fractionation_response.dart';
import 'package:logsheet_app/features/production/data/model/dry_fractionation/remote/fetch_dry_fractionation_response.dart';
import 'package:logsheet_app/features/production/data/model/dry_fractionation/remote/update_approve_reject_dry_fractionation.dart';
import 'package:logsheet_app/features/production/data/model/dry_fractionation/remote/update_approve_reject_perdate_dry_fractionation.dart';
import 'package:logsheet_app/features/production/data/model/dry_fractionation/remote/update_dry_fractionation_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_truck/create_analytical_result_incoming_material_by_truck_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_truck/delete_analytical_result_incoming_material_by_truck_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_truck/fetch_analytical_result_incoming_material_by_truck_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_truck/update_analytical_result_incoming_material_by_truck_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_truck/update_approve_reject_analytical_result_incoming_material_by_truck_response.dart';
import 'package:retrofit/retrofit.dart';

part 'dry_fractionation_api_service.g.dart';

@RestApi()
abstract class DryFractionationApiService {
  factory DryFractionationApiService(Dio dio, {String baseUrl}) =
      _DryFractionationApiService;

  @POST("/dryfrac")
  Future<CreateDryFractionationResponse> insertReport(
    @Body() Map<String, dynamic> body,
    @Header("Authorization") String token,
  );

  @GET("/dryfrac")
  Future<FetchDryFractionationResponse> fetchReports(
    @Header("Authorization") String token,
    @Query("plant") String? plantId,
    @Query("date") String? date,
  );

  @DELETE("/dryfrac/{id}")
  Future<DeleteDryFractionationResponse> deleteReport(
    @Header("Authorization") String token,
    @Path("id") String id,
  );

  @PUT("/dryfrac/{id}")
  Future<UpdateDryFractionationResponse> updateReport(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> body,
    @Path("id") String id,
  );

  @PUT("/dryfrac/approve-reject")
  Future<UpdateApproveRejectDryFractionation> updateApproveRejectReport(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> body,
  );

  @PUT("/dryfrac/approve-reject-perdate")
  Future<UpdateApproveRejectPerdateDryFractionation>
  updateApproveRejectReportPerDate(
    @Header("Authorization") String token,
    @Body() Map<String, dynamic> body,
  );
}
