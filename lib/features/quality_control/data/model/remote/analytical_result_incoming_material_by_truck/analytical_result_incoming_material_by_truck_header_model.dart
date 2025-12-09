import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_truck/analytical_result_incoming_material_by_truck_header_entity.dart';
import 'analytical_result_incoming_material_by_truck_detail_model.dart';

part 'analytical_result_incoming_material_by_truck_header_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AnalyticalResultIncomingMaterialByTruckHeaderModel
    extends AnalyticalResultIncomingMaterialByTruckHeaderEntity {
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

  @JsonKey(name: 'arrival_date')
  final String? jsonArrival;

  @JsonKey(name: 'contract_do')
  final String? jsonContractDoNomor;

  @JsonKey(name: 'supplier')
  final String? jsonSupplier;

  @JsonKey(name: 'vessel_vehicle')
  final String? jsonVesselVehicle;

  @JsonKey(name: 'ss_ffa')
  final String? jsonFfa;

  @JsonKey(name: 'ss_mni')
  final String? jsonMni;

  @JsonKey(name: 'ss_dobi')
  final String? jsonDobi;

  @JsonKey(name: 'ss_others')
  final String? jsonOthers;

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
  final List<AnalyticalResultIncomingMaterialByTruckDetailModel>? jsonDetail;

  AnalyticalResultIncomingMaterialByTruckHeaderModel({
    required this.jsonId,
    required this.jsonCompany,
    required this.jsonPlant,
    this.jsonTransactionDate,
    this.jsonMaterial,
    this.jsonArrival,
    this.jsonContractDoNomor,
    this.jsonSupplier,
    this.jsonVesselVehicle,
    this.jsonFfa,
    this.jsonMni,
    this.jsonDobi,
    this.jsonOthers,
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
    // this.jsonDetail,
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

         // String langsung
         material: jsonMaterial,
         supplier: jsonSupplier,
         vesselVehicle: jsonVesselVehicle,
         contractDoNomor: jsonContractDoNomor,
         ssOthers: jsonOthers,
         ssFfa: parseDouble(jsonFfa),
         ssMni: parseDouble(jsonMni),
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

  factory AnalyticalResultIncomingMaterialByTruckHeaderModel.fromJson(
    Map<String, dynamic> json,
  ) => _$AnalyticalResultIncomingMaterialByTruckHeaderModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AnalyticalResultIncomingMaterialByTruckHeaderModelToJson(this);
}
