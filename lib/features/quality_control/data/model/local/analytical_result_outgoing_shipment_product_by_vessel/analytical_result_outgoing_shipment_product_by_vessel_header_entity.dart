
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_outgoing_shipment_product_by_vessel/analytical_result_outgoing_shipment_product_by_vessel_detail_entity.dart';

class AnalyticalResultOutgoingShipmentProductByVesselHeaderEntity {
  final String id;
  final String company;
  final String plant;

  final String? productName;
  final DateTime? samplingDate;
  final double? quantity;
  final String? shipper;
  final String? destination;
  final String? vesselName;

  final double? hasilAnalisaFfa;
  final double? hasilAnalisaIv;
  final double? hasilAnalisaMoisture;
  final double? hasilAnalisaColorR;
  final double? hasilAnalisaPv;
  final double? hasilAnalisaSMP;

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

  final List<AnalyticalResultOutgoingShipmentProductByVesselDetailEntity>
  details;

  AnalyticalResultOutgoingShipmentProductByVesselHeaderEntity({
    required this.id,
    required this.company,
    required this.plant,
    required this.productName,
    required this.samplingDate,
    required this.shipper,
    required this.destination,
    required this.vesselName,
    required this.hasilAnalisaColorR,
    required this.hasilAnalisaSMP,
    required this.quantity,
    required this.hasilAnalisaFfa,
    required this.hasilAnalisaIv,
    required this.hasilAnalisaMoisture,
    required this.hasilAnalisaPv,
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
