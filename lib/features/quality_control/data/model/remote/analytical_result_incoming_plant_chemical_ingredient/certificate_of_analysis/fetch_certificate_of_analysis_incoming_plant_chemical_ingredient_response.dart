import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_header_model.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/certificate_of_analysis_incoming_plant_chemical_ingredient_header_model.dart';

part 'fetch_certificate_of_analysis_incoming_plant_chemical_ingredient_response.g.dart';

@JsonSerializable(explicitToJson: true)
class FetchCertificateOfAnalysisIncomingPlantChemicalIngredientResponse {
  final bool success;
  final List<CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderModel> data;

  FetchCertificateOfAnalysisIncomingPlantChemicalIngredientResponse({
    required this.success,
    required this.data,
  });

  factory FetchCertificateOfAnalysisIncomingPlantChemicalIngredientResponse.fromJson(
          Map<String, dynamic> json) =>
      _$FetchCertificateOfAnalysisIncomingPlantChemicalIngredientResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FetchCertificateOfAnalysisIncomingPlantChemicalIngredientResponseToJson(this);
}
