import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/certificate_of_analysis_incoming_plant_chemical_ingredient_detail_entity.dart';

class AnalyticalResultIncomingPlantChemicalIngredientDetailEntity {
  final String id;
  final String idHdr;
  final double? specificationMin;
  final double? specificationMax;
  final String? statusOk;
  final String? parameter;
  final double? resultMin;
  final double? resultMax;
  final String? remark;
  final DateTime? deletedAt;

  AnalyticalResultIncomingPlantChemicalIngredientDetailEntity({
    required this.id,
    required this.idHdr,
    required this.specificationMin,
    required this.specificationMax,
    required this.statusOk,
    required this.parameter,
    required this.resultMin,
    required this.resultMax,
    required this.remark,
    required this.deletedAt,
  });
}
