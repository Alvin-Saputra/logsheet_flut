import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_fuel/analytical_result/analytical_result_incoming_plant_fuel_detail_entity.dart';

class AnalyticalResultIncomingPlantFuelHeaderEntity {
  final String id;
  final String idRoa;
  final DateTime? date;
  final String? material;
  final double? quantity;
  final String? analyst;
  final String? supplier;
  final String? policeNo;

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

  final List<AnalyticalResultIncomingPlantFuelDetailEntity> details;

  AnalyticalResultIncomingPlantFuelHeaderEntity({
    required this.id,
    required this.idRoa,
    required this.material,
    required this.quantity,
    required this.analyst,
    required this.supplier,
    required this.policeNo,
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
