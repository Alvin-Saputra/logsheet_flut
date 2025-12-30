import 'package:dio/dio.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_outgoing_shipment_product_by_truck/create_analytical_result_outgoing_shipment_product_by_truck_response.dart';
import 'package:retrofit/retrofit.dart';

part 'analytical_result_outgoing_shipment_product_by_truck_api_service.g.dart';

@RestApi()
abstract class AnalyticalResultOutgoingShipmentProductByTruckApiService {
  factory AnalyticalResultOutgoingShipmentProductByTruckApiService(
    Dio dio, {
    String baseUrl,
  }) = _AnalyticalResultOutgoingShipmentProductByTruckApiService;

  @POST("/arosptruck")
  Future<CreateAnalyticalResultOutgoingShipmentProductByTruckResponse> insertReport(
    @Body() Map<String, dynamic> body,
    @Header("Authorization") String token,
  );

  // @GET("/aroipfuel")
  // Future<FetchAnalyticalResultIncomingPlantFuelResponse> fetchReports(
  //   @Header("Authorization") String token,
  //   @Query("entry_date") String? date,
  // );

  // @DELETE("/aroipfuel/{id}")
  // Future<DeleteAnalyticalResultIncomingPlantFuelResponse> deleteReport(
  //   @Header("Authorization") String token,
  //   @Path("id") String id,
  // );

  // @PUT("/aroipfuel/{id}")
  // Future<UpdateAnalyticalResultIncomingPlantFuelResponse> updateReport(
  //   @Header("Authorization") String token,
  //   @Path("id") String id,
  //   @Body() Map<String, dynamic> body,
  // );

  // @PUT("/aroipfuel/{id}/approve")
  // Future<UpdateApproveRejectAnalyticalResultIncomingPlantFuelResponse>
  // updateApprovalReport(
  //   @Header("Authorization") String token,
  //   @Path("id") String id,
  //   @Body() Map<String, dynamic> body,
  // );
}
