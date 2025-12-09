import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_truck/analytical_result_incoming_material_by_truck_detail_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_detail_entity.dart';

class AnalyticalResultIncomingMaterialByTruckHeaderEntity {
  final String id;
  final String company;
  final String plant;
  final DateTime? transactionDate;
  final String? material;
  final DateTime? arrival;
  final String? contractDoNomor;
  final String? supplier;
  final String? vesselVehicle;
  final double? ssFfa;
  final double? ssMni;
  final String? ssOthers;

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

  final List<AnalyticalResultIncomingMaterialByTruckDetailEntity> details;

  AnalyticalResultIncomingMaterialByTruckHeaderEntity({
    required this.id,
    required this.company,
    required this.plant,
    required this.transactionDate,
    required this.material,
    required this.arrival,
    required this.contractDoNomor,
    required this.supplier,
    required this.vesselVehicle,
    required this.ssFfa,
    required this.ssMni,
    required this.ssOthers,
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
  });
}
