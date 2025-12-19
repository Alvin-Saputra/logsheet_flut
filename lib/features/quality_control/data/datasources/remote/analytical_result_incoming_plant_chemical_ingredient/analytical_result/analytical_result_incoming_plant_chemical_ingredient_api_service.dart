import 'package:dio/dio.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_plant_chemical_ingredient/analytical_result/create_analytical_result_incoming_plant_chemical_ingredient_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_plant_chemical_ingredient/analytical_result/delete_analytical_result_incoming_plant_chemical_ingredient_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_plant_chemical_ingredient/analytical_result/fetch_analytical_result_incoming_plant_chemical_ingredient_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_plant_chemical_ingredient/analytical_result/update_analytical_result_incoming_plant_chemical_ingredient_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_plant_chemical_ingredient/analytical_result/update_approve_reject_analytical_result_incoming_plant_chemical_ingredient.dart';
import 'package:retrofit/retrofit.dart';

part 'analytical_result_incoming_plant_chemical_ingredient_api_service.g.dart';

@RestApi()
abstract class AnalyticalResultIncomingPlantChemicalIngredientApiService {
  factory AnalyticalResultIncomingPlantChemicalIngredientApiService(
    Dio dio, {
    String baseUrl,
  }) = _AnalyticalResultIncomingPlantChemicalIngredientApiService;

  @POST("/ariopchemical")
  Future<CreateAnalyticalResultIncomingPlantChemicalIngredientResponse>
  insertReport(
    @Body() Map<String, dynamic> body,
    @Header("Authorization") String token,
  );

  @GET("/ariopchemical")
  Future<FetchAnalyticalResultIncomingPlantChemicalIngredientResponse>
  fetchReports(
    @Header("Authorization") String token,
    @Query("entry_date") String? date,
  );

  @DELETE("/ariopchemical/{id}")
  Future<DeleteAnalyticalResultIncomingPlantChemicalIngredientResponse>
  deleteReport(@Header("Authorization") String token, @Path("id") String id);

  @PUT("/ariopchemical/{id}")
  Future<UpdateAnalyticalResultIncomingPlantChemicalIngredientResponse>
  updateReport(
    @Header("Authorization") String token,
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );

  @PUT("/ariopchemical/{id}/approve")
  Future<UpdateApproveRejectAnalyticalResultIncomingPlantChemicalIngredient>
  updateApprovalReport(
    @Header("Authorization") String token,
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );
}
