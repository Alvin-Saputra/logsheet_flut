import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/certificate_of_analysis_incoming_plant_chemical_ingredient_detail_entity.dart';

class CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderEntity {
  final String id;
  final String noDoc;
  final String? product;
  final String? grade;
  final String? packing;
  final double quantity;
  final DateTime? tanggalPengiriman;
  final String? vehicle;
  final String? lotNo;
  final DateTime? productionDate;
  final DateTime? expiredDate;
  final String? issueBy;
  final DateTime? issueDate;
  final String? updatedBy;
  final DateTime? updatedDate;

  final List<CertificateOfAnalysisIncomingPlantChemicalIngredientDetailEntity>
  details;

  CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderEntity({
    required this.id,
    required this.noDoc,
    required this.product,
    required this.grade,
    required this.packing,
    required this.quantity,
    required this.tanggalPengiriman,
    required this.vehicle,
    required this.lotNo,
    required this.productionDate,
    required this.expiredDate,
    required this.issueBy,
    required this.issueDate,
    required this.details, 
    this.updatedBy, 
    this.updatedDate,
  });
}
