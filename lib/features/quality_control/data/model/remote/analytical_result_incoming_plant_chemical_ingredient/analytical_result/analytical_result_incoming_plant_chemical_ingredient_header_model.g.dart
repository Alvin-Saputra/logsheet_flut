// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytical_result_incoming_plant_chemical_ingredient_header_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticalResultIncomingPlantChemicalIngredientHeaderModel
_$AnalyticalResultIncomingPlantChemicalIngredientHeaderModelFromJson(
  Map<String, dynamic> json,
) => AnalyticalResultIncomingPlantChemicalIngredientHeaderModel(
  jsonId: json['id'] as String,
  jsonIdCoa: json['id_coa'] as String,
  jsonCompany: json['company'] as String?,
  jsonPlant: json['plant'] as String?,
  jsonNoRefCoa: json['no_ref_coa'] as String?,
  jsonMaterial: json['material'] as String?,
  jsonQuantity: json['quantity'] as String?,
  jsonAnalyst: json['analyst'] as String?,
  jsonSupplier: json['supplier'] as String?,
  jsonPoliceNo: json['police_no'] as String?,
  jsonBatchLot: json['batch_lot'] as String?,
  jsonStatus: json['status'] as String?,
  jsonFlag: json['flag'] as String?,
  jsonEntryBy: json['entry_by'] as String?,
  jsonEntryDate: json['entry_date'] as String?,
  jsonPreparedBy: json['prepared_by'] as String?,
  jsonPreparedDate: json['prepared_date'] as String?,
  jsonPreparedStatus: json['prepared_status'] as String?,
  jsonPreparedStatusRemarks: json['prepared_status_remarks'] as String?,
  jsonApprovedBy: json['approved_by'] as String?,
  jsonApprovedDate: json['approved_date'] as String?,
  jsonApprovedStatus: json['approved_status'] as String?,
  jsonApprovedStatusRemarks: json['approved_status_remarks'] as String?,
  jsonUpdatedBy: json['updated_by'] as String?,
  jsonUpdatedDate: json['updated_date'] as String?,
  jsonFormNo: json['form_no'] as String?,
  jsonDateIssued: json['date_issued'] as String?,
  jsonRevisionNo: (json['revision_no'] as num?)?.toInt(),
  jsonRevisionDate: json['revision_date'] as String?,
  jsonDetail:
      (json['details'] as List<dynamic>?)
          ?.map(
            (e) =>
                AnalyticalResultIncomingPlantChemicalIngredientDetailModel.fromJson(
                  e as Map<String, dynamic>,
                ),
          )
          .toList(),
  jsonDate: json['date'] as String?,
  jsonExpDate: json['exp_date'] as String?,
);

Map<String, dynamic>
_$AnalyticalResultIncomingPlantChemicalIngredientHeaderModelToJson(
  AnalyticalResultIncomingPlantChemicalIngredientHeaderModel instance,
) => <String, dynamic>{
  'id': instance.jsonId,
  'id_coa': instance.jsonIdCoa,
  'company': instance.jsonCompany,
  'plant': instance.jsonPlant,
  'no_ref_coa': instance.jsonNoRefCoa,
  'date': instance.jsonDate,
  'material': instance.jsonMaterial,
  'quantity': instance.jsonQuantity,
  'analyst': instance.jsonAnalyst,
  'supplier': instance.jsonSupplier,
  'police_no': instance.jsonPoliceNo,
  'batch_lot': instance.jsonBatchLot,
  'status': instance.jsonStatus,
  'exp_date': instance.jsonExpDate,
  'flag': instance.jsonFlag,
  'entry_by': instance.jsonEntryBy,
  'entry_date': instance.jsonEntryDate,
  'prepared_by': instance.jsonPreparedBy,
  'prepared_date': instance.jsonPreparedDate,
  'prepared_status': instance.jsonPreparedStatus,
  'prepared_status_remarks': instance.jsonPreparedStatusRemarks,
  'approved_by': instance.jsonApprovedBy,
  'approved_date': instance.jsonApprovedDate,
  'approved_status': instance.jsonApprovedStatus,
  'approved_status_remarks': instance.jsonApprovedStatusRemarks,
  'updated_by': instance.jsonUpdatedBy,
  'updated_date': instance.jsonUpdatedDate,
  'form_no': instance.jsonFormNo,
  'date_issued': instance.jsonDateIssued,
  'revision_no': instance.jsonRevisionNo,
  'revision_date': instance.jsonRevisionDate,
  'details': instance.jsonDetail?.map((e) => e.toJson()).toList(),
};
