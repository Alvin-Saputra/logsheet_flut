import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_detail_entity.dart';

class AnalyticalResultIncomingMaterialByVesselHeaderEntity {
  final String id;
  final String company;
  final String plant;
  final DateTime? transactionDate;

  final String? material;
  final DateTime? arrival;
  final double? quantity;
  final String? supplier;
  final String? shipName;
  final String? contractDoNomor;
  final double? ffa;
  final double? mni;
  final double? dobi;
  final String? others;
  final double? hasilAnalisaFfa;
  final double? hasilAnalisaIv;
  final double? hasilAnalisaMoisture;
  final double? hasilAnalisaDobi;
  final double? hasilAnalisaPv;
  final double? hasilAnalisaAnv;
  final double? hasilAnalisaTotox;
  final double? hasilAnalisaCarotex;
  final double? hasilAnalisaMineralOil;

  final String? remarks;
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

  final List<AnalyticalResultIncomingMaterialByVesselDetailEntity> details;

  AnalyticalResultIncomingMaterialByVesselHeaderEntity({
    required this.id,
    required this.company,
    required this.plant,
    required this.transactionDate,
    required this.material,
    required this.arrival,
    required this.quantity,
    required this.supplier,
    required this.shipName,
    required this.contractDoNomor,
    required this.ffa,
    required this.mni,
    required this.dobi,
    required this.others,
    required this.hasilAnalisaFfa,
    required this.hasilAnalisaIv,
    required this.hasilAnalisaMoisture,
    required this.hasilAnalisaDobi,
    required this.hasilAnalisaPv,
    required this.hasilAnalisaAnv,
    required this.hasilAnalisaTotox,
    required this.hasilAnalisaCarotex,
    required this.hasilAnalisaMineralOil,
    required this.remarks,
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

  AnalyticalResultIncomingMaterialByVesselHeaderEntity copyWith({
    String? id,
    String? company,
    String? plant,
    DateTime? transactionDate,

    String? material,
    DateTime? arrival,
    double? quantity,
    String? supplier,
    String? shipName,
    String? contractDoNomor,
    double? ffa,
    double? mni,
    double? dobi,
    String? others,
    double? hasilAnalisaFfa,
    double? hasilAnalisaIv,
    double? hasilAnalisaMoisture,
    double? hasilAnalisaDobi,
    double? hasilAnalisaPv,
    double? hasilAnalisaAnv,
    double? hasilAnalisaTotox,
    double? hasilAnalisaCarotex,
    double? hasilAnalisaMineralOil,

    String? remarks,
    String? flag,
    String? entryBy,
    DateTime? entryDate,
    String? preparedBy,
    DateTime? preparedDate,
    String? preparedStatus,
    String? preparedStatusRemarks,
    String? approvedBy,
    DateTime? approvedDate,
    String? approvedStatus,
    String? approvedStatusRemarks,
    String? updatedBy,
    DateTime? updatedDate,
    String? formNo,
    DateTime? dateIssued,
    String? revisionNo,
    DateTime? revisionDate,
    List<AnalyticalResultIncomingMaterialByVesselDetailEntity>? details,
  }) {
    return AnalyticalResultIncomingMaterialByVesselHeaderEntity(
      id: id ?? this.id,
      company: company ?? this.company,
      plant: plant ?? this.plant,
      transactionDate: transactionDate ?? this.transactionDate,

      material: material ?? this.material,
      arrival: arrival ?? this.arrival,
      quantity: quantity ?? this.quantity,
      supplier: supplier ?? this.supplier,
      shipName: shipName ?? this.shipName,
      contractDoNomor: contractDoNomor ?? this.contractDoNomor,
      ffa: ffa ?? this.ffa,
      mni: mni ?? this.mni,
      dobi: dobi ?? this.dobi,
      others: others ?? this.others,
      hasilAnalisaFfa: hasilAnalisaFfa ?? this.hasilAnalisaFfa,
      hasilAnalisaIv: hasilAnalisaIv ?? this.hasilAnalisaIv,
      hasilAnalisaMoisture: hasilAnalisaMoisture ?? this.hasilAnalisaMoisture,
      hasilAnalisaDobi: hasilAnalisaDobi ?? this.hasilAnalisaDobi,
      hasilAnalisaPv: hasilAnalisaPv ?? this.hasilAnalisaPv,
      hasilAnalisaAnv: hasilAnalisaAnv ?? this.hasilAnalisaAnv,

      remarks: remarks ?? this.remarks,
      flag: flag ?? this.flag,
      entryBy: entryBy ?? this.entryBy,
      entryDate: entryDate ?? this.entryDate,
      preparedBy: preparedBy ?? this.preparedBy,
      preparedDate: preparedDate ?? this.preparedDate,
      preparedStatus: preparedStatus ?? this.preparedStatus,
      preparedStatusRemarks:
          preparedStatusRemarks ?? this.preparedStatusRemarks,

      approvedBy: approvedBy ?? this.approvedBy,
      approvedDate: approvedDate ?? this.approvedDate,
      approvedStatus: approvedStatus ?? this.approvedStatus,
      approvedStatusRemarks:
          approvedStatusRemarks ?? this.approvedStatusRemarks,

      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
      formNo: formNo ?? this.formNo,
      dateIssued: dateIssued ?? this.dateIssued,
      revisionNo: revisionNo ?? this.revisionNo,
      revisionDate: revisionDate ?? this.revisionDate,
      details: details ?? this.details,
      hasilAnalisaTotox: hasilAnalisaTotox ?? this.hasilAnalisaTotox,
      hasilAnalisaCarotex: hasilAnalisaCarotex ?? this.hasilAnalisaCarotex,
      hasilAnalisaMineralOil: hasilAnalisaMineralOil ?? this.hasilAnalisaMineralOil,
    );
  }
}
