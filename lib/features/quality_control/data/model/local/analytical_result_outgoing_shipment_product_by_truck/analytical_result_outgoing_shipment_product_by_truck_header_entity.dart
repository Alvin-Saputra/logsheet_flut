import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_truck/analytical_result_incoming_material_by_truck_detail_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_outgoing_shipment_product_by_truck/analytical_result_outgoing_shipment_product_by_truck_detail_entity.dart';

class AnalyticalResultOutgoingShipmentProductByTruckHeaderEntity {
  final String id;
  final DateTime? loadingDate;
  final String? productName;
  final double? quantity;
  final String? shipsName;
  final String? destination;
  final String? loadPort;
  final String? entryBy;
  final DateTime? entryDate;
  final String? correctedBy;
  final DateTime? correctedDate;
  final String? correctedStatus;
  final String? correctedStatusRemarks;
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

  final List<AnalyticalResultOutgoingShipmentProductByTruckDetailEntity> details;

  AnalyticalResultOutgoingShipmentProductByTruckHeaderEntity({
    required this.id,
    required this.loadingDate,
    required this.productName,
    required this.quantity,
    required this.shipsName,
    required this.destination,
    required this.loadPort,
    required this.correctedBy,
    required this.correctedDate,
    required this.correctedStatus,
    required this.correctedStatusRemarks,
    required this.entryBy,
    required this.entryDate,
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
