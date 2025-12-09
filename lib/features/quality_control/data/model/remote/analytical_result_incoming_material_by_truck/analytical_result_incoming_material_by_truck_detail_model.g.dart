// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytical_result_incoming_material_by_truck_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticalResultIncomingMaterialByTruckDetailModel
_$AnalyticalResultIncomingMaterialByTruckDetailModelFromJson(
  Map<String, dynamic> json,
) => AnalyticalResultIncomingMaterialByTruckDetailModel(
  jsonId: json['id'] as String,
  jsonIdHdr: json['id_hdr'] as String,
  jsonNo: json['no'] as String?,
  jsonSamplingDate: json['sampling_date'] as String?,
  jsonPoliceNo: json['police_no'] as String?,
  jsonPFfa: json['p_ffa'] as num?,
  jsonPMoisture: json['p_moisture'] as num?,
  jsonPIv: json['p_iv'] as num?,
  jsonPDobi: json['p_dobi'] as num?,
  jsonPPv: json['p_pv'] as num?,
  jsonPColorR: json['p_color_r'] as num?,
  jsonPColorY: json['p_color_y'] as num?,
  jsonAnalis: json['analis'] as String?,
  jsonRemark: json['remarks'] as String?,
);

Map<String, dynamic> _$AnalyticalResultIncomingMaterialByTruckDetailModelToJson(
  AnalyticalResultIncomingMaterialByTruckDetailModel instance,
) => <String, dynamic>{
  'id': instance.jsonId,
  'id_hdr': instance.jsonIdHdr,
  'no': instance.jsonNo,
  'sampling_date': instance.jsonSamplingDate,
  'police_no': instance.jsonPoliceNo,
  'p_ffa': instance.jsonPFfa,
  'p_moisture': instance.jsonPMoisture,
  'p_iv': instance.jsonPIv,
  'p_dobi': instance.jsonPDobi,
  'p_pv': instance.jsonPPv,
  'p_color_r': instance.jsonPColorR,
  'p_color_y': instance.jsonPColorY,
  'analis': instance.jsonAnalis,
  'remarks': instance.jsonRemark,
};
