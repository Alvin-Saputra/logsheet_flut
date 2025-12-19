import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_chemical_ingredient/analytical_with_certificate_of_analysis_header_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/certificate_of_analysis_incoming_plant_chemical_ingredient_header_model.dart';
import 'analytical_result_incoming_plant_chemical_ingredient_header_model.dart';
import 'analytical_result_incoming_plant_chemical_ingredient_header_model.dart';

part 'analytical_with_coa_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AnalyticalWithCoaModel
    extends AnalyticalWithCertificateOfAnalysisHeaderEntity {
  final AnalyticalResultIncomingPlantChemicalIngredientHeaderModel analytical;
  final CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderModel coa;

  AnalyticalWithCoaModel({required this.analytical, required this.coa})
    : super(analytical: analytical, coa: coa);

  factory AnalyticalWithCoaModel.fromJson(Map<String, dynamic> json) =>
      _$AnalyticalWithCoaModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticalWithCoaModelToJson(this);
}
