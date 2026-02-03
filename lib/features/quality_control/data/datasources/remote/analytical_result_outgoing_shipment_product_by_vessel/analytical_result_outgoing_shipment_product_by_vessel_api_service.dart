import 'package:dio/dio.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_outgoing_shipment_product_by_truck/create_analytical_result_outgoing_shipment_product_by_truck_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_outgoing_shipment_product_by_vessel/create_analytical_result_outgoing_shipment_product_by_vessel_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_outgoing_shipment_product_by_vessel/delete_analytical_result_outgoing_shipment_product_by_vessel_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_outgoing_shipment_product_by_vessel/fetch_analytical_result_outgoing_shipment_product_by_vessel_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_outgoing_shipment_product_by_vessel/update_analytical_result_outgoing_shipment_product_by_vessel_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_outgoing_shipment_product_by_vessel/update_approve_reject_analytical_result_outgoing_shipment_product_by_vessel_response.dart';
import 'package:retrofit/retrofit.dart';

part 'analytical_result_outgoing_shipment_product_by_vessel_api_service.g.dart';

@RestApi()
abstract class AnalyticalResultOutgoingShipmentProductByVesselApiService {
  factory AnalyticalResultOutgoingShipmentProductByVesselApiService(
    Dio dio, {
    String baseUrl,
  }) = _AnalyticalResultOutgoingShipmentProductByVesselApiService;

  @POST("/arosvess")
  Future<CreateAnalyticalResultOutgoingShipmentProductByVesselResponse>
  insertReport(
    @Body() Map<String, dynamic> body,
    @Header("Authorization") String token,
  );

  @GET("/arosvess")
  Future<FetchAnalyticalResultOutgoingShipmentProductByVesselResponse>
  fetchReports(
    @Header("Authorization") String token,
    @Query("sampling_date") String? date,
  );

  @DELETE("/arosvess/{id}")
  Future<DeleteAnalyticalResultOutgoingShipmentProductByVesselResponse>
  deleteReport(@Header("Authorization") String token, @Path("id") String id);

  @PUT("/arosvess/{id}")
  Future<UpdateAnalyticalResultOutgoingShipmentProductByVesselResponse>
  updateReport(
    @Header("Authorization") String token,
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );

  @PUT("/arosvess/{id}/approve")
  Future<
    UpdateApproveRejectAnalyticalResultOutgoingShipmentProductByVesselResponse
  >
  updateApprovalReport(
    @Header("Authorization") String token,
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );
}
