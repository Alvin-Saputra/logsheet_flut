import 'package:json_annotation/json_annotation.dart';

part 'create_certificate_of_analysis_incoming_plant_chemical_ingredient_response.g.dart';

@JsonSerializable()
class CreateCertificateOfAnalysisIncomingPlantChemicalIngredientResponse {
  final bool success;

  @JsonKey(name: "header_id")
  final String idHeader;

  @JsonKey(name: "detail_ids")
  final List<String> idDet;

  CreateCertificateOfAnalysisIncomingPlantChemicalIngredientResponse({
    required this.success,
    required this.idHeader,
    required this.idDet,
  });

  factory CreateCertificateOfAnalysisIncomingPlantChemicalIngredientResponse.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CreateCertificateOfAnalysisIncomingPlantChemicalIngredientResponseFromJson(
        json,
      );

  Map<String, dynamic> toJson() =>
      _$CreateCertificateOfAnalysisIncomingPlantChemicalIngredientResponseToJson(
        this,
      );
}
