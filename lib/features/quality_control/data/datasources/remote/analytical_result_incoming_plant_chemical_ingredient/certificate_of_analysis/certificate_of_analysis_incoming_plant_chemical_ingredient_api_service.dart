import 'package:dio/dio.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_truck/create_analytical_result_incoming_material_by_truck_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_truck/delete_analytical_result_incoming_material_by_truck_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_truck/fetch_analytical_result_incoming_material_by_truck_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_truck/update_analytical_result_incoming_material_by_truck_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_truck/update_approve_reject_analytical_result_incoming_material_by_truck_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/create_certificate_of_analysis_incoming_plant_chemical_ingredient_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/fetch_certificate_of_analysis_incoming_plant_chemical_ingredient_response.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/update_certificate_of_analysis_incoming_plant_chemical_ingredient_response.dart';
import 'package:retrofit/retrofit.dart';

part 'certificate_of_analysis_incoming_plant_chemical_ingredient_api_service.g.dart';

@RestApi()
abstract class CertificateOfAnalysisIncomingPlantChemicalIngredientApiService {
  factory CertificateOfAnalysisIncomingPlantChemicalIngredientApiService(
    Dio dio, {
    String baseUrl,
  }) = _CertificateOfAnalysisIncomingPlantChemicalIngredientApiService;

  @POST("/coa-plant-chemical")
  Future<CreateCertificateOfAnalysisIncomingPlantChemicalIngredientResponse>
  insertReport(
    @Body() Map<String, dynamic> body,
    @Header("Authorization") String token,
  );

  @GET("/coa-plant-chemical")
  Future<FetchCertificateOfAnalysisIncomingPlantChemicalIngredientResponse>
  fetchReports(
    @Header("Authorization") String token,
    @Query("date") String? date,
  );

  @PUT("/coa-plant-chemical/{id}")
  Future<UpdateCertificateOfAnalysisIncomingPlantChemicalIngredientResponse>
  updateReport(
    @Header("Authorization") String token,
    @Path("id") String id,
    @Body() Map<String, dynamic> body,
  );
}
