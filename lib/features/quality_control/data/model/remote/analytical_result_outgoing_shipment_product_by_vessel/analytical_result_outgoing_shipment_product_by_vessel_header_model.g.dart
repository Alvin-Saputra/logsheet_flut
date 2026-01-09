// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytical_result_outgoing_shipment_product_by_vessel_header_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticalResultOutgoingShipmentProductByVesselHeaderModel
_$AnalyticalResultOutgoingShipmentProductByVesselHeaderModelFromJson(
  Map<String, dynamic> json,
) => AnalyticalResultOutgoingShipmentProductByVesselHeaderModel(
  jsonId: json['id'] as String,
  jsonCompany: json['company'] as String?,
  jsonPlant: json['plant'] as String?,
  jsonProductName: json['product_name'] as String?,
  jsonSamplingDate: json['sampling_date'] as String?,
  jsonQuantity: json['quantity'] as String?,
  jsonShipper: json['shipper'] as String?,
  jsonDestination: json['destination'] as String?,
  jsonVesselName: json['vessel_name'] as String?,
  jsonHasilAnalisaFfa: json['hasil_analisa_ffa'] as String?,
  jsonHasilAnalisaIv: json['hasil_analisa_iv'] as String?,
  jsonHasilAnalisaMoisture: json['hasil_analisa_moisture'] as String?,
  jsonHasilAnalisaColour: json['hasil_analisa_colour'] as String?,
  jsonHasilAnalisaPv: json['hasil_analisa_pv'] as String?,
  jsonHasilAnalisaSmp: json['hasil_analisa_smp'] as String?,
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
            (e) =>
                AnalyticalResultOutgoingShipmentProductByVesselDetailModel.fromJson(
                  e as Map<String, dynamic>,
                ),
          )
          .toList(),
);

Map<String, dynamic>
_$AnalyticalResultOutgoingShipmentProductByVesselHeaderModelToJson(
  AnalyticalResultOutgoingShipmentProductByVesselHeaderModel instance,
) => <String, dynamic>{
  'id': instance.jsonId,
  'company': instance.jsonCompany,
  'plant': instance.jsonPlant,
  'product_name': instance.jsonProductName,
  'sampling_date': instance.jsonSamplingDate,
  'quantity': instance.jsonQuantity,
  'shipper': instance.jsonShipper,
  'destination': instance.jsonDestination,
  'vessel_name': instance.jsonVesselName,
  'hasil_analisa_ffa': instance.jsonHasilAnalisaFfa,
  'hasil_analisa_iv': instance.jsonHasilAnalisaIv,
  'hasil_analisa_moisture': instance.jsonHasilAnalisaMoisture,
  'hasil_analisa_colour': instance.jsonHasilAnalisaColour,
  'hasil_analisa_pv': instance.jsonHasilAnalisaPv,
  'hasil_analisa_smp': instance.jsonHasilAnalisaSmp,
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
