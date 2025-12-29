import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_chemical_ingredient/analytical_with_certificate_of_analysis_header_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_fuel/analytical_with_report_of_analysis_header_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/certificate_of_analysis_incoming_plant_chemical_ingredient_header_model.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_plant_fuel/analytical_result_incoming_plant_fuel_header_model.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_plant_fuel/report_of_analysis_incoming_plant_fuel_header_model.dart';
part 'analytical_with_roa_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AnalyticalWithRoaModel
    extends AnalyticalWithReportOfAnalysisHeaderEntity {
  final AnalyticalResultIncomingPlantFuelHeaderModel analytical;
  final ReportOfAnalysisIncomingPlantFuelHeaderModel roa;

  AnalyticalWithRoaModel({required this.analytical, required this.roa})
    : super(analytical: analytical, roa: roa);

  factory AnalyticalWithRoaModel.fromJson(Map<String, dynamic> json) =>
      _$AnalyticalWithRoaModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticalWithRoaModelToJson(this);
}
