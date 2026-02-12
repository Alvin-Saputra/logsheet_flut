// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytical_result_outgoing_shipment_product_by_vessel_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticalResultOutgoingShipmentProductByVesselDetailModel
_$AnalyticalResultOutgoingShipmentProductByVesselDetailModelFromJson(
  Map<String, dynamic> json,
) => AnalyticalResultOutgoingShipmentProductByVesselDetailModel(
  jsonId: json['id'] as String,
  jsonIdHdr: json['id_hdr'] as String,
  jsonPalkaSPalka: (json['palka_s_palka'] as num?)?.toInt(),
  jsonPalkaSFfa: json['palka_s_ffa'] as String?,
  jsonPalkaSIv: json['palka_s_iv'] as String?,
  jsonPalkaSColour: json['palka_s_colour'] as String?,
  jsonPalkaSPv: json['palka_s_pv'] as String?,
  jsonPalkaSMni: json['palka_s_mni'] as String?,
  jsonPalkaPPalka: (json['palka_p_palka'] as num?)?.toInt(),
  jsonPalkaPFfa: json['palka_p_ffa'] as String?,
  jsonPalkaPIv: json['palka_p_iv'] as String?,
  jsonPalkaPColour: json['palka_p_colour'] as String?,
  jsonPalkaPPv: json['palka_p_pv'] as String?,
  jsonPalkaPMni: json['palka_p_mni'] as String?,
  jsonDeletedAt: json['deleted_at'] as String?,
);

Map<String, dynamic>
_$AnalyticalResultOutgoingShipmentProductByVesselDetailModelToJson(
  AnalyticalResultOutgoingShipmentProductByVesselDetailModel instance,
) => <String, dynamic>{
  'id': instance.jsonId,
  'id_hdr': instance.jsonIdHdr,
  'palka_s_palka': instance.jsonPalkaSPalka,
  'palka_s_ffa': instance.jsonPalkaSFfa,
  'palka_s_iv': instance.jsonPalkaSIv,
  'palka_s_colour': instance.jsonPalkaSColour,
  'palka_s_pv': instance.jsonPalkaSPv,
  'palka_s_mni': instance.jsonPalkaSMni,
  'palka_p_palka': instance.jsonPalkaPPalka,
  'palka_p_ffa': instance.jsonPalkaPFfa,
  'palka_p_iv': instance.jsonPalkaPIv,
  'palka_p_colour': instance.jsonPalkaPColour,
  'palka_p_pv': instance.jsonPalkaPPv,
  'palka_p_mni': instance.jsonPalkaPMni,
  'deleted_at': instance.jsonDeletedAt,
};
