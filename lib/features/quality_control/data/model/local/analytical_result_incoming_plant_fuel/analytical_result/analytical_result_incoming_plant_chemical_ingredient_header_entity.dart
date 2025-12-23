import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_chemical_ingredient/analytical_result/analytical_result_incoming_plant_chemical_ingredient_detail_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/certificate_of_analysis_incoming_plant_chemical_ingredient_detail_entity.dart';

class AnalyticalResultIncomingPlantChemicalIngredientHeaderEntity {
  final String id;
  final String idCoa;
  final DateTime? date;
  final String? material;
  final double? quantity;
  final String? analyst;
  final String? supplier;
  final String? policeNo;

  final String? flag;
  final String? entryBy;
  final DateTime? entryDate;
  final String? preparedBy;
  final DateTime? preparedDate;
  final String? preparedStatus;
  final String? preparedStatusRemarks;
  final String? approvedBy;
  final DateTime? approvedDate;
  final String? approvedStatus;
  final String? approvedStatusRemarks;
  final String? updatedBy;
  final DateTime? updatedDate;
  final String? formNo;
  final DateTime? dateIssued;
  final String? revisionNo;
  final DateTime? revisionDate;

  final List<AnalyticalResultIncomingPlantChemicalIngredientDetailEntity>
  details;

  AnalyticalResultIncomingPlantChemicalIngredientHeaderEntity({
    required this.id,
    required this.idCoa,
    required this.material,
    required this.quantity,
    required this.analyst,
    required this.supplier,
    required this.policeNo,
    required this.flag,
    required this.entryBy,
    required this.entryDate,
    required this.preparedBy,
    required this.preparedDate,
    required this.preparedStatus,
    required this.preparedStatusRemarks,
    required this.approvedBy,
    required this.approvedDate,
    required this.approvedStatus,
    required this.approvedStatusRemarks,
    required this.updatedBy,
    required this.updatedDate,
    required this.formNo,
    required this.dateIssued,
    required this.revisionNo,
    required this.revisionDate,
    required this.details,
    required this.date,
  });
}
