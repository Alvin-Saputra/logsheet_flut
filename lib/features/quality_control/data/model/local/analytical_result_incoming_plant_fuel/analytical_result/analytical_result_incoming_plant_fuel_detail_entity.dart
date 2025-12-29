import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/certificate_of_analysis_incoming_plant_chemical_ingredient_detail_entity.dart';

class AnalyticalResultIncomingPlantFuelDetailEntity {
  final String id;
  final String idHdr;
  final double? specification;
  final String? statusOk;
  final String? parameter;
  final double? result;
  final String? remark;
  final DateTime? deletedAt;

  AnalyticalResultIncomingPlantFuelDetailEntity({
    required this.id,
    required this.idHdr,
    required this.specification,
    required this.statusOk,
    required this.parameter,
    required this.result,
    required this.remark,
    required this.deletedAt,
  });
}
