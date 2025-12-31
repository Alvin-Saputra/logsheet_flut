// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytical_result_outgoing_shipment_product_by_truck_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticalResultOutgoingShipmentProductByTruckDetailModel
_$AnalyticalResultOutgoingShipmentProductByTruckDetailModelFromJson(
  Map<String, dynamic> json,
) => AnalyticalResultOutgoingShipmentProductByTruckDetailModel(
  jsonId: json['id'] as String,
  jsonIdHdr: json['id_hdr'] as String,
  jsonShipsTank: json['ships_tank'] as String?,
  jsonPoliceNo: json['no_police'] as String?,
  jsonFfa: json['ffa'] as String?,
  jsonMni: json['m_and_i'] as String?,
  jsonIv: json['iv'] as String?,
  jsonLovibondColorRed: json['lovibond_color_red'] as String?,
  jsonLovibondColorYellow: json['lovibond_color_yellow'] as String?,
  jsonPv: json['pv'] as String?,
  jsonOther: json['other'] as String?,
  jsonRemark: json['remark'] as String?,
);

Map<String, dynamic>
_$AnalyticalResultOutgoingShipmentProductByTruckDetailModelToJson(
  AnalyticalResultOutgoingShipmentProductByTruckDetailModel instance,
) => <String, dynamic>{
  'id': instance.jsonId,
  'id_hdr': instance.jsonIdHdr,
  'ships_tank': instance.jsonShipsTank,
  'no_police': instance.jsonPoliceNo,
  'ffa': instance.jsonFfa,
  'm_and_i': instance.jsonMni,
  'iv': instance.jsonIv,
  'lovibond_color_red': instance.jsonLovibondColorRed,
  'lovibond_color_yellow': instance.jsonLovibondColorYellow,
  'pv': instance.jsonPv,
  'other': instance.jsonOther,
  'remark': instance.jsonRemark,
};
