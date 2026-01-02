import 'package:dio/dio.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_plant_fuel/fetch_analytical_result_incoming_plant_fuel_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_outgoing_shipment_product_by_truck/create_analytical_result_outgoing_shipment_product_by_truck_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_outgoing_shipment_product_by_truck/delete_analytical_result_outgoing_shipment_product_by_truck_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_outgoing_shipment_product_by_truck/fetch_analytical_result_outgoing_shipment_product_by_truck_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_outgoing_shipment_product_by_truck/update_analytical_result_outgoing_shipment_product_by_truck_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_outgoing_shipment_product_by_truck/update_approve_reject_analytical_result_outgoing_shipment_product_by_truck_response.dart';
import 'package:retrofit/retrofit.dart';

part 'analytical_result_outgoing_shipment_product_by_truck_api_service.g.dart';

@RestApi()
abstract class AnalyticalResultOutgoingShipmentProductByTruckApiService {
  factory AnalyticalResultOutgoingShipmentProductByTruckApiService(
    Dio dio, {
    String baseUrl,
  }) = _AnalyticalResultOutgoingShipmentProductByTruckApiService;

  @POST("/arosptruck")
  Future<CreateAnalyticalResultOutgoingShipmentProductByTruckResponse>
  insertReport(
    @Body() Map<String, dynamic> body,
    @Header("Authorization") String token,
  );

  @GET("/arosptruck")
  Future<FetchAnalyticalResultOutgoingShipmentProductByTruckResponse>
  fetchReports(
    @Header("Authorization") String token,
    @Query("entry_date") String? date,
  );

  @DELETE("/arosptruck/{id}")
  Future<DeleteAnalyticalResultOutgoingShipmentProductByTruckResponse>
  deleteReport(@Header("Authorization") String token, @Path("id") String id);

  @PUT("/arosptruck/{id}")
  Future<UpdateAnalyticalResultOutgoingShipmentProductByTruckResponse> updateReport(
    @Header("Authorization") String token,
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );

  @PUT("/arosptruck/{id}/approve")
  Future<UpdateApproveRejectAnalyticalResultOutgoingShipmentProductByTruckResponse>
  updateApprovalReport(
    @Header("Authorization") String token,
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );
}
