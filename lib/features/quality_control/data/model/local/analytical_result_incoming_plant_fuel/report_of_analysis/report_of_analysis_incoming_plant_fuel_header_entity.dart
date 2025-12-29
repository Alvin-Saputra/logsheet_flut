import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/certificate_of_analysis_incoming_plant_chemical_ingredient_detail_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_fuel/report_of_analysis/report_of_analysis_incoming_plant_fuel_detail_entity.dart';

class ReportOfAnalysisIncomingPlantFuelHeaderEntity {
  final String id;
  final String reportNo;
  final String? shipper;
  final String? buyer;
  final DateTime? dateReceived;
  final DateTime? dateAnalyzedStart;
  final DateTime? dateAnalyzedEnd;
  final DateTime? dateReported;
  final String? labSampleId;
  final String? customerSampleId;
  final String? sealNo;
  final double? weightofReceivedSample;
  final double? topSizeofReceivedSample;
  final String? authorizedBy;
  final DateTime? authorizedDate;
  final double? hardGrooveGrindabilityIndex;

  final List<ReportOfAnalysisIncomingPlantFuelDetailEntity> details;

  ReportOfAnalysisIncomingPlantFuelHeaderEntity({
    required this.id,
    required this.details,
    required this.reportNo,
    required this.shipper,
    required this.buyer,
    required this.dateReceived,
    required this.dateAnalyzedStart,
    required this.dateAnalyzedEnd,
    required this.dateReported,
    required this.labSampleId,
    required this.customerSampleId,
    required this.sealNo,
    required this.weightofReceivedSample,
    required this.topSizeofReceivedSample,
    required this.authorizedBy,
    required this.authorizedDate,
    required this.hardGrooveGrindabilityIndex,
  });
}
