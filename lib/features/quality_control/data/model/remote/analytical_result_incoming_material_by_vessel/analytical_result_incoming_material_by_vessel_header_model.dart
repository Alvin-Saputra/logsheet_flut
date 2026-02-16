import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_header_entity.dart';
import 'analytical_result_incoming_material_by_vessel_detail_model.dart';

part 'analytical_result_incoming_material_by_vessel_header_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AnalyticalResultIncomingMaterialByVesselHeaderModel
    extends AnalyticalResultIncomingMaterialByVesselHeaderEntity {
  @JsonKey(name: 'id')
  final String jsonId;

  @JsonKey(name: 'company')
  final String jsonCompany;

  @JsonKey(name: 'plant')
  final String jsonPlant;

  @JsonKey(name: 'transaction_date')
  final String? jsonTransactionDate;

  @JsonKey(name: 'material')
  final String? jsonMaterial;

  @JsonKey(name: 'arrival')
  final String? jsonArrival;

  @JsonKey(name: 'quantity')
  final String? jsonQuantity;

  @JsonKey(name: 'supplier')
  final String? jsonSupplier;

  @JsonKey(name: 'ship_name')
  final String? jsonShipName;

  @JsonKey(name: 'contract_do_nomor')
  final String? jsonContractDoNomor;

  @JsonKey(name: 'ffa')
  final String? jsonFfa;

  @JsonKey(name: 'mni')
  final String? jsonMni;

  @JsonKey(name: 'dobi')
  final String? jsonDobi;

  @JsonKey(name: 'others')
  final String? jsonOthers;

  @JsonKey(name: 'hasil_analisa_ffa')
  final String? jsonHasilAnalisaFfa;

  @JsonKey(name: 'hasil_analisa_iv')
  final String? jsonHasilAnalisaIv;

  @JsonKey(name: 'hasil_analisa_moisture')
  final String? jsonHasilAnalisaMoisture;

  @JsonKey(name: 'hasil_analisa_dobi')
  final String? jsonHasilAnalisaDobi;

  @JsonKey(name: 'hasil_analisa_pv')
  final String? jsonHasilAnalisaPv;

  @JsonKey(name: 'hasil_analisa_anv')
  final String? jsonHasilAnalisaAnv;

  @JsonKey(name: 'hasil_analisa_totox')
  final String? jsonHasilAnalisaTotox;

  @JsonKey(name: 'hasil_analisa_carotex')
  final String? jsonHasilAnalisaCarotex;

  @JsonKey(name: 'hasil_analisa_mineral_oil')
  final String? jsonHasilAnalisaMineralOil;

  @JsonKey(name: 'remarks')
  final String? jsonRemarks;

  @JsonKey(name: 'flag')
  final String? jsonFlag;

  @JsonKey(name: 'entry_by')
  final String? jsonEntryBy;

  @JsonKey(name: 'entry_date')
  final String? jsonEntryDate;

  @JsonKey(name: 'prepared_by')
  final String? jsonPreparedBy;

  @JsonKey(name: 'prepared_date')
  final String? jsonPreparedDate;

  @JsonKey(name: 'prepared_status')
  final String? jsonPreparedStatus;

  @JsonKey(name: 'prepared_status_remarks')
  final String? jsonPreparedStatusRemarks;

  @JsonKey(name: 'approved_by')
  final String? jsonApprovedBy;

  @JsonKey(name: 'approved_date')
  final String? jsonApprovedDate;

  @JsonKey(name: 'approved_status')
  final String? jsonApprovedStatus;

  @JsonKey(name: 'approved_status_remarks')
  final String? jsonApprovedStatusRemarks;

  @JsonKey(name: 'updated_by')
  final String? jsonUpdatedBy;

  @JsonKey(name: 'updated_date')
  final String? jsonUpdatedDate;

  @JsonKey(name: 'form_no')
  final String? jsonFormNo;

  @JsonKey(name: 'date_issued')
  final String? jsonDateIssued;

  @JsonKey(name: 'revision_no')
  final int? jsonRevisionNo; // API kasih Int

  @JsonKey(name: 'revision_date')
  final String? jsonRevisionDate;

  // List Detail (Model)
  @JsonKey(name: 'detail')
  final List<AnalyticalResultIncomingMaterialByVesselDetailModel>? jsonDetail;

  AnalyticalResultIncomingMaterialByVesselHeaderModel({
    required this.jsonId,
    required this.jsonCompany,
    required this.jsonPlant,
    this.jsonTransactionDate,
    this.jsonMaterial,
    this.jsonArrival,
    this.jsonQuantity,
    this.jsonSupplier,
    this.jsonShipName,
    this.jsonContractDoNomor,
    this.jsonFfa,
    this.jsonMni,
    this.jsonDobi,
    this.jsonOthers,
    this.jsonHasilAnalisaFfa,
    this.jsonHasilAnalisaIv,
    this.jsonHasilAnalisaMoisture,
    this.jsonHasilAnalisaDobi,
    this.jsonHasilAnalisaPv,
    this.jsonHasilAnalisaAnv,
    this.jsonHasilAnalisaTotox,
    this.jsonHasilAnalisaCarotex,
    this.jsonHasilAnalisaMineralOil,
    this.jsonRemarks,
    this.jsonFlag,
    this.jsonEntryBy,
    this.jsonEntryDate,
    this.jsonPreparedBy,
    this.jsonPreparedDate,
    this.jsonPreparedStatus,
    this.jsonPreparedStatusRemarks,
    this.jsonApprovedBy,
    this.jsonApprovedDate,
    this.jsonApprovedStatus,
    this.jsonApprovedStatusRemarks,
    this.jsonUpdatedBy,
    this.jsonUpdatedDate,
    this.jsonFormNo,
    this.jsonDateIssued,
    this.jsonRevisionNo,
    this.jsonRevisionDate,
    this.jsonDetail,
  }) : super(
         id: jsonId,
         company: jsonCompany,
         plant: jsonPlant,

         // String -> DateTime
         transactionDate:
             jsonTransactionDate != null
                 ? DateTime.tryParse(jsonTransactionDate)
                 : null,
         arrival: jsonArrival != null ? DateTime.tryParse(jsonArrival) : null,
         entryDate:
             jsonEntryDate != null ? DateTime.tryParse(jsonEntryDate) : null,
         preparedDate:
             jsonPreparedDate != null
                 ? DateTime.tryParse(jsonPreparedDate)
                 : null,
         approvedDate:
             jsonApprovedDate != null
                 ? DateTime.tryParse(jsonApprovedDate)
                 : null,
         updatedDate:
             jsonUpdatedDate != null
                 ? DateTime.tryParse(jsonUpdatedDate)
                 : null,
         dateIssued:
             jsonDateIssued != null ? DateTime.tryParse(jsonDateIssued) : null,
         revisionDate:
             jsonRevisionDate != null
                 ? DateTime.tryParse(jsonRevisionDate)
                 : null,

         // String -> Double
         quantity: double.tryParse(jsonQuantity ?? ''),
         ffa: double.tryParse(jsonFfa ?? ''),
         mni: double.tryParse(jsonMni ?? ''),
         dobi: double.tryParse(jsonDobi ?? ''),
         hasilAnalisaFfa: double.tryParse(jsonHasilAnalisaFfa ?? ''),
         hasilAnalisaIv: double.tryParse(jsonHasilAnalisaIv ?? ''),
         hasilAnalisaMoisture: double.tryParse(jsonHasilAnalisaMoisture ?? ''),
         hasilAnalisaDobi: double.tryParse(jsonHasilAnalisaDobi ?? ''),
         hasilAnalisaPv: double.tryParse(jsonHasilAnalisaPv ?? ''),
         hasilAnalisaAnv: double.tryParse(jsonHasilAnalisaAnv ?? ''),
         hasilAnalisaTotox: double.tryParse(jsonHasilAnalisaTotox ?? ''),
         hasilAnalisaCarotex: double.tryParse(jsonHasilAnalisaCarotex ?? ''),
         hasilAnalisaMineralOil: double.tryParse(
           jsonHasilAnalisaMineralOil ?? '',
         ),
         // String langsung
         material: jsonMaterial,
         supplier: jsonSupplier,
         shipName: jsonShipName,
         contractDoNomor: jsonContractDoNomor,
         others: jsonOthers,
         remarks: jsonRemarks,
         flag: jsonFlag,
         entryBy: jsonEntryBy,
         preparedBy: jsonPreparedBy,
         preparedStatus: jsonPreparedStatus,
         preparedStatusRemarks: jsonPreparedStatusRemarks,
         approvedBy: jsonApprovedBy,
         approvedStatus: jsonApprovedStatus,
         approvedStatusRemarks: jsonApprovedStatusRemarks,
         updatedBy: jsonUpdatedBy,
         formNo: jsonFormNo,

         revisionNo: jsonRevisionNo?.toString(),

         details: jsonDetail ?? [],
       );

  factory AnalyticalResultIncomingMaterialByVesselHeaderModel.fromJson(
    Map<String, dynamic> json,
  ) => _$AnalyticalResultIncomingMaterialByVesselHeaderModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AnalyticalResultIncomingMaterialByVesselHeaderModelToJson(this);
}
