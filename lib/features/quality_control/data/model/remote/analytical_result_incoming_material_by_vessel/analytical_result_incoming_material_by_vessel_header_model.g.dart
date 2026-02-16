// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytical_result_incoming_material_by_vessel_header_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticalResultIncomingMaterialByVesselHeaderModel
_$AnalyticalResultIncomingMaterialByVesselHeaderModelFromJson(
  Map<String, dynamic> json,
) => AnalyticalResultIncomingMaterialByVesselHeaderModel(
  jsonId: json['id'] as String,
  jsonCompany: json['company'] as String,
  jsonPlant: json['plant'] as String,
  jsonTransactionDate: json['transaction_date'] as String?,
  jsonMaterial: json['material'] as String?,
  jsonArrival: json['arrival'] as String?,
  jsonQuantity: json['quantity'] as String?,
  jsonSupplier: json['supplier'] as String?,
  jsonShipName: json['ship_name'] as String?,
  jsonContractDoNomor: json['contract_do_nomor'] as String?,
  jsonFfa: json['ffa'] as String?,
  jsonMni: json['mni'] as String?,
  jsonDobi: json['dobi'] as String?,
  jsonOthers: json['others'] as String?,
  jsonHasilAnalisaFfa: json['hasil_analisa_ffa'] as String?,
  jsonHasilAnalisaIv: json['hasil_analisa_iv'] as String?,
  jsonHasilAnalisaMoisture: json['hasil_analisa_moisture'] as String?,
  jsonHasilAnalisaDobi: json['hasil_analisa_dobi'] as String?,
  jsonHasilAnalisaPv: json['hasil_analisa_pv'] as String?,
  jsonHasilAnalisaAnv: json['hasil_analisa_anv'] as String?,
  jsonHasilAnalisaTotox: json['hasil_analisa_totox'] as String?,
  jsonHasilAnalisaCarotex: json['hasil_analisa_carotex'] as String?,
  jsonHasilAnalisaMineralOil: json['hasil_analisa_mineral_oil'] as String?,
  jsonRemarks: json['remarks'] as String?,
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
            (e) => AnalyticalResultIncomingMaterialByVesselDetailModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
);

Map<String, dynamic>
_$AnalyticalResultIncomingMaterialByVesselHeaderModelToJson(
  AnalyticalResultIncomingMaterialByVesselHeaderModel instance,
) => <String, dynamic>{
  'id': instance.jsonId,
  'company': instance.jsonCompany,
  'plant': instance.jsonPlant,
  'transaction_date': instance.jsonTransactionDate,
  'material': instance.jsonMaterial,
  'arrival': instance.jsonArrival,
  'quantity': instance.jsonQuantity,
  'supplier': instance.jsonSupplier,
  'ship_name': instance.jsonShipName,
  'contract_do_nomor': instance.jsonContractDoNomor,
  'ffa': instance.jsonFfa,
  'mni': instance.jsonMni,
  'dobi': instance.jsonDobi,
  'others': instance.jsonOthers,
  'hasil_analisa_ffa': instance.jsonHasilAnalisaFfa,
  'hasil_analisa_iv': instance.jsonHasilAnalisaIv,
  'hasil_analisa_moisture': instance.jsonHasilAnalisaMoisture,
  'hasil_analisa_dobi': instance.jsonHasilAnalisaDobi,
  'hasil_analisa_pv': instance.jsonHasilAnalisaPv,
  'hasil_analisa_anv': instance.jsonHasilAnalisaAnv,
  'hasil_analisa_totox': instance.jsonHasilAnalisaTotox,
  'hasil_analisa_carotex': instance.jsonHasilAnalisaCarotex,
  'hasil_analisa_mineral_oil': instance.jsonHasilAnalisaMineralOil,
  'remarks': instance.jsonRemarks,
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
