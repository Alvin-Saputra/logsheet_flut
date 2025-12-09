// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytical_result_incoming_material_by_truck_header_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticalResultIncomingMaterialByTruckHeaderModel
_$AnalyticalResultIncomingMaterialByTruckHeaderModelFromJson(
  Map<String, dynamic> json,
) => AnalyticalResultIncomingMaterialByTruckHeaderModel(
  jsonId: json['id'] as String,
  jsonCompany: json['company'] as String,
  jsonPlant: json['plant'] as String,
  jsonTransactionDate: json['transaction_date'] as String?,
  jsonMaterial: json['material'] as String?,
  jsonArrival: json['arrival_date'] as String?,
  jsonContractDoNomor: json['contract_do'] as String?,
  jsonSupplier: json['supplier'] as String?,
  jsonVesselVehicle: json['vessel_vehicle'] as String?,
  jsonFfa: json['ss_ffa'] as String?,
  jsonMni: json['ss_mni'] as String?,
  jsonDobi: json['ss_dobi'] as String?,
  jsonOthers: json['ss_others'] as String?,
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
      (json['detail'] as List<dynamic>?)
          ?.map(
            (e) => AnalyticalResultIncomingMaterialByTruckDetailModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
);

Map<String, dynamic> _$AnalyticalResultIncomingMaterialByTruckHeaderModelToJson(
  AnalyticalResultIncomingMaterialByTruckHeaderModel instance,
) => <String, dynamic>{
  'id': instance.jsonId,
  'company': instance.jsonCompany,
  'plant': instance.jsonPlant,
  'transaction_date': instance.jsonTransactionDate,
  'material': instance.jsonMaterial,
  'arrival_date': instance.jsonArrival,
  'contract_do': instance.jsonContractDoNomor,
  'supplier': instance.jsonSupplier,
  'vessel_vehicle': instance.jsonVesselVehicle,
  'ss_ffa': instance.jsonFfa,
  'ss_mni': instance.jsonMni,
  'ss_dobi': instance.jsonDobi,
  'ss_others': instance.jsonOthers,
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
  'detail': instance.jsonDetail?.map((e) => e.toJson()).toList(),
};
