// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytical_result_outgoing_shipment_product_by_truck_header_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticalResultOutgoingShipmentProductByTruckHeaderModel
_$AnalyticalResultOutgoingShipmentProductByTruckHeaderModelFromJson(
  Map<String, dynamic> json,
) => AnalyticalResultOutgoingShipmentProductByTruckHeaderModel(
  jsonId: json['id'] as String,
  jsonCompany: json['company'] as String?,
  jsonPlant: json['plant'] as String?,
  jsonLoadingDate: json['loading_date'] as String?,
  jsonProductName: json['product_name'] as String?,
  jsonQuantity: json['quantity'] as String?,
  jsonShipsName: json['ships_name'] as String?,
  jsonDestination: json['destination'] as String?,
  jsonLoadPort: json['load_port'] as String?,
  jsonEntryBy: json['entry_by'] as String?,
  jsonEntryDate: json['entry_date'] as String?,
  jsonCorrectedBy: json['corrected_by'] as String?,
  jsonCorrectedDate: json['corrected_date'] as String?,
  jsonCorrectedStatus: json['corrected_status'] as String?,
  jsonCorrectedStatusRemarks: json['corrected_status_remarks'] as String?,
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
                AnalyticalResultOutgoingShipmentProductByTruckDetailModel.fromJson(
                  e as Map<String, dynamic>,
                ),
          )
          .toList(),
);

Map<String, dynamic>
_$AnalyticalResultOutgoingShipmentProductByTruckHeaderModelToJson(
  AnalyticalResultOutgoingShipmentProductByTruckHeaderModel instance,
) => <String, dynamic>{
  'id': instance.jsonId,
  'company': instance.jsonCompany,
  'plant': instance.jsonPlant,
  'loading_date': instance.jsonLoadingDate,
  'product_name': instance.jsonProductName,
  'quantity': instance.jsonQuantity,
  'ships_name': instance.jsonShipsName,
  'destination': instance.jsonDestination,
  'load_port': instance.jsonLoadPort,
  'entry_by': instance.jsonEntryBy,
  'entry_date': instance.jsonEntryDate,
  'corrected_by': instance.jsonCorrectedBy,
  'corrected_date': instance.jsonCorrectedDate,
  'corrected_status': instance.jsonCorrectedStatus,
  'corrected_status_remarks': instance.jsonCorrectedStatusRemarks,
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
