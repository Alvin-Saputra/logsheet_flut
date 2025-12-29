import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_fuel/report_of_analysis/report_of_analysis_incoming_plant_fuel_header_entity.dart';
import 'report_of_analysis_incoming_plant_fuel_detail_model.dart';

part 'report_of_analysis_incoming_plant_fuel_header_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ReportOfAnalysisIncomingPlantFuelHeaderModel
    extends ReportOfAnalysisIncomingPlantFuelHeaderEntity {
  @JsonKey(name: 'id')
  final String jsonId;

  @JsonKey(name: 'report_no')
  final String jsonReportNo;

  @JsonKey(name: 'shipper')
  final String? jsonShipper;

  @JsonKey(name: 'buyer')
  final String? jsonBuyer;

  @JsonKey(name: 'date_received')
  final String? jsonDateReceived;

  @JsonKey(name: 'date_analyzed_start')
  final String? jsonDateAnalyzedStart;

  @JsonKey(name: 'date_analyzed_end')
  final String? jsonDateAnalyzedEnd;

  @JsonKey(name: 'date_reported')
  final String? jsonDateReported;

  @JsonKey(name: 'lab_sample_id')
  final String? jsonLabSampleId;

  @JsonKey(name: 'customer_sample_id')
  final String? jsonCustomerSampleId;

  @JsonKey(name: 'seal_no')
  final String? jsonSealNo;

  @JsonKey(name: 'weight_of_received_sample')
  final String? jsonWeightofReceivedSample;

  @JsonKey(name: 'top_size_of_received_sample')
  final String? jsonTopSizeofReceivedSample;

   @JsonKey(name: 'hardgrove_grindability_index')
  final String? jsonHardGrooveGrindabilityIndex;

  @JsonKey(name: 'authorized_by')
  final String? jsonAuthorizedBy;

  @JsonKey(name: 'authorized_date')
  final String? jsonAuthorizedDate;

  // List Detail (Model)
  @JsonKey(name: 'details')
  final List<ReportOfAnalysisIncomingPlantFuelDetailModel>?
  jsonDetail;

  ReportOfAnalysisIncomingPlantFuelHeaderModel({
    required this.jsonId,
    required this.jsonReportNo,
    this.jsonShipper,
    this.jsonBuyer,
    this.jsonDateReceived,
    this.jsonDateAnalyzedStart,
    this.jsonDateAnalyzedEnd,
    this.jsonDateReported,
    this.jsonLabSampleId,
    this.jsonCustomerSampleId,
    this.jsonSealNo,
    this.jsonWeightofReceivedSample,
    this.jsonTopSizeofReceivedSample,
    this.jsonAuthorizedBy,
    this.jsonAuthorizedDate,
    this.jsonDetail, 
    this.jsonHardGrooveGrindabilityIndex,
  }) : super(
        id: jsonId,
        reportNo: jsonReportNo,
        shipper: jsonShipper,
        buyer: jsonBuyer,
        dateReceived: formatStringtoDate(jsonDateReceived ?? '', 'yyyy-MM-dd'),
        dateAnalyzedStart: formatStringtoDate(jsonDateAnalyzedStart ?? '', 'yyyy-MM-dd'),
        dateAnalyzedEnd: formatStringtoDate(jsonDateAnalyzedEnd ?? '', 'yyyy-MM-dd'),
        dateReported: formatStringtoDate(jsonDateReported ?? '', 'yyyy-MM-dd'),
        labSampleId: jsonLabSampleId,
        customerSampleId: jsonCustomerSampleId,
        sealNo: jsonSealNo,
        weightofReceivedSample: parseDouble(jsonWeightofReceivedSample)??0.0,
        topSizeofReceivedSample: parseDouble(jsonTopSizeofReceivedSample)??0.0,
        authorizedBy: jsonAuthorizedBy,
        authorizedDate: formatStringtoDate(jsonAuthorizedDate ?? '', 'yyyy-MM-dd'),
        hardGrooveGrindabilityIndex: parseDouble(jsonHardGrooveGrindabilityIndex)??0.0,
        details: jsonDetail ?? [],
      );

  factory ReportOfAnalysisIncomingPlantFuelHeaderModel.fromJson(
    Map<String, dynamic> json,
  ) => _$ReportOfAnalysisIncomingPlantFuelHeaderModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ReportOfAnalysisIncomingPlantFuelHeaderModelToJson(this);
}
