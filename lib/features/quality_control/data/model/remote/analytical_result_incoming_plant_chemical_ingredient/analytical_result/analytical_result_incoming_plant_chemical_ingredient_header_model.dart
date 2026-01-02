import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_chemical_ingredient/analytical_result/analytical_result_incoming_plant_chemical_ingredient_header_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_plant_chemical_ingredient/analytical_result/analytical_result_incoming_plant_chemical_ingredient_detail_model.dart';

part 'analytical_result_incoming_plant_chemical_ingredient_header_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AnalyticalResultIncomingPlantChemicalIngredientHeaderModel
    extends AnalyticalResultIncomingPlantChemicalIngredientHeaderEntity {
  @JsonKey(name: 'id')
  final String jsonId;

  @JsonKey(name: 'id_coa')
  final String jsonIdCoa;

  @JsonKey(name: 'company')
  final String? jsonCompany;

  @JsonKey(name: 'plant')
  final String? jsonPlant;

  @JsonKey(name: 'no_ref_coa')
  final String? jsonNoRefCoa;

  @JsonKey(name: 'date')
  final String? jsonDate;

  @JsonKey(name: 'material')
  final String? jsonMaterial;

  @JsonKey(name: 'quantity')
  final String? jsonQuantity;

  @JsonKey(name: 'analyst')
  final String? jsonAnalyst;

  @JsonKey(name: 'supplier')
  final String? jsonSupplier;

  @JsonKey(name: 'police_no')
  final String? jsonPoliceNo;

  @JsonKey(name: 'batch_lot')
  final String? jsonBatchLot;

  @JsonKey(name: "status")
  final String? jsonStatus;

  @JsonKey(name: 'exp_date')
  final String? jsonExpDate;

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
  @JsonKey(name: 'details')
  final List<AnalyticalResultIncomingPlantChemicalIngredientDetailModel>?
  jsonDetail;

  AnalyticalResultIncomingPlantChemicalIngredientHeaderModel({
    required this.jsonId,
    required this.jsonIdCoa,
    this.jsonCompany,
    this.jsonPlant,
    this.jsonNoRefCoa,
    this.jsonMaterial,
    this.jsonQuantity,
    this.jsonAnalyst,
    this.jsonSupplier,
    this.jsonPoliceNo,
    this.jsonBatchLot,
    this.jsonStatus,
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
    this.jsonDate,
    this.jsonExpDate,
  }) : super(
         id: jsonId,
         idCoa: jsonIdCoa,
         company: jsonCompany??'',
         plant: jsonPlant??'',
         noRefCoa: jsonNoRefCoa,
         material: jsonMaterial,
         quantity: parseDouble(jsonQuantity),
         analyst: jsonAnalyst,
         supplier: jsonSupplier,
         policeNo: jsonPoliceNo,
         batchLot: jsonBatchLot,
         date: formatStringtoDate(jsonDate ?? '', 'yyyy-MM-dd HH:mm:ss'),
         expDate: formatStringtoDate(jsonExpDate ?? '', 'yyyy-MM-dd HH:mm:ss'),
         status: jsonStatus,
         flag: jsonFlag,
         entryBy: jsonEntryBy,
         entryDate: formatStringtoDate(
           jsonEntryDate ?? '',
           'yyyy-MM-dd HH:mm:ss',
         ),
         preparedBy: jsonPreparedBy,
         preparedDate: formatStringtoDate(
           jsonPreparedDate ?? '',
           'yyyy-MM-dd HH:mm:ss',
         ),
         preparedStatus: jsonPreparedStatus,
         preparedStatusRemarks: jsonPreparedStatusRemarks,
         approvedBy: jsonApprovedBy,
         approvedDate: formatStringtoDate(
           jsonApprovedDate ?? '',
           'yyyy-MM-dd HH:mm:ss',
         ),
         approvedStatus: jsonApprovedStatus,
         approvedStatusRemarks: jsonApprovedStatusRemarks,
         updatedBy: jsonUpdatedBy,
         updatedDate: formatStringtoDate(
           jsonUpdatedDate ?? '',
           'yyyy-MM-dd HH:mm:ss',
         ),
         formNo: jsonFormNo,
         dateIssued: formatStringtoDate(
           jsonFormNo ?? '',
           'yyyy-MM-dd HH:mm:ss',
         ),
         revisionNo: jsonRevisionNo.toString(),
         revisionDate: formatStringtoDate(
           jsonRevisionDate ?? '',
           'yyyy-MM-dd HH:mm:ss',
         ),
         details: jsonDetail ?? [],
       );

  factory AnalyticalResultIncomingPlantChemicalIngredientHeaderModel.fromJson(
    Map<String, dynamic> json,
  ) => _$AnalyticalResultIncomingPlantChemicalIngredientHeaderModelFromJson(
    json,
  );

  Map<String, dynamic> toJson() =>
      _$AnalyticalResultIncomingPlantChemicalIngredientHeaderModelToJson(this);
}
