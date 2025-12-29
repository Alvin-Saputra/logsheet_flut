import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_fuel/report_of_analysis/report_of_analysis_incoming_plant_fuel_detail_entity.dart';
part 'report_of_analysis_incoming_plant_fuel_detail_model.g.dart';

@JsonSerializable()
class ReportOfAnalysisIncomingPlantFuelDetailModel
    extends ReportOfAnalysisIncomingPlantFuelDetailEntity {
  @JsonKey(name: 'id')
  final String jsonId;

  @JsonKey(name: 'id_hdr')
  final String jsonIdHdr;

  // Case 1: JSON berupa String (perlu diparse ke double)
  @JsonKey(name: 'parameter')
  final String? jsonParameter;

  @JsonKey(name: 'unit')
  final String? jsonUnit;

  @JsonKey(name: 'basis')
  final String? jsonBasis;

  // Case 2: JSON berupa num/angka (perlu di-cast ke double)
  @JsonKey(name: 'result')
  final String? jsonResult;

  ReportOfAnalysisIncomingPlantFuelDetailModel({
    required this.jsonId,
    required this.jsonIdHdr,
    this.jsonParameter,
    this.jsonUnit,
    this.jsonBasis,
    this.jsonResult,
  }) : super(
         id: jsonId,
         idHdr: jsonIdHdr,
         parameter: jsonParameter,
         unit: jsonUnit,
         basis: jsonBasis,
         result: parseDouble(jsonResult),
       );

  factory ReportOfAnalysisIncomingPlantFuelDetailModel.fromJson(
    Map<String, dynamic> json,
  ) => _$ReportOfAnalysisIncomingPlantFuelDetailModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ReportOfAnalysisIncomingPlantFuelDetailModelToJson(this);
}
