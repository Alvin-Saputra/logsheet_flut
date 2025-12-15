import 'package:json_annotation/json_annotation.dart';

part 'update_certificate_of_analysis_incoming_plant_chemical_ingredient_response.g.dart';

@JsonSerializable()
class UpdateCertificateOfAnalysisIncomingPlantChemicalIngredientResponse {
  final bool success;

  @JsonKey(name: "id_header")
  final String idHeader;

  @JsonKey(name: "id_det")
  final List<String> idDet;

  UpdateCertificateOfAnalysisIncomingPlantChemicalIngredientResponse({
    required this.success,
    required this.idHeader,
    required this.idDet,
  });

  factory UpdateCertificateOfAnalysisIncomingPlantChemicalIngredientResponse.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$UpdateCertificateOfAnalysisIncomingPlantChemicalIngredientResponseFromJson(
        json,
      );

  Map<String, dynamic> toJson() =>
      _$UpdateCertificateOfAnalysisIncomingPlantChemicalIngredientResponseToJson(
        this,
      );
}
