// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytical_result_incoming_material_by_vessel_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticalResultIncomingMaterialByVesselDetailModel
_$AnalyticalResultIncomingMaterialByVesselDetailModelFromJson(
  Map<String, dynamic> json,
) => AnalyticalResultIncomingMaterialByVesselDetailModel(
  jsonId: json['id'] as String,
  jsonIdHdr: json['id_hdr'] as String,
  jsonPalkaSNo: (json['palka_s_no'] as num?)?.toInt(),
  jsonPalkaSFfa: json['palka_s_ffa'] as String?,
  jsonPalkaSIv: json['palka_s_iv'] as String?,
  jsonPalkaSDobi: json['palka_s_dobi'] as String?,
  jsonPalkaSMni: json['palka_s_mni'] as String?,
  jsonPalkaCNo: (json['palka_c_no'] as num?)?.toInt(),
  jsonPalkaCFfa: json['palka_c_ffa'] as String?,
  jsonPalkaCIv: json['palka_c_iv'] as String?,
  jsonPalkaCDobi: json['palka_c_dobi'] as String?,
  jsonPalkaCMni: json['palka_c_mni'] as String?,
  jsonPalkaPNo: (json['palka_p_no'] as num?)?.toInt(),
  jsonPalkaPFfa: json['palka_p_ffa'] as String?,
  jsonPalkaPIv: json['palka_p_iv'] as String?,
  jsonPalkaPDobi: json['palka_p_dobi'] as String?,
  jsonPalkaPMni: json['palka_p_mni'] as String?,
);

Map<String, dynamic>
_$AnalyticalResultIncomingMaterialByVesselDetailModelToJson(
  AnalyticalResultIncomingMaterialByVesselDetailModel instance,
) => <String, dynamic>{
  'id': instance.jsonId,
  'id_hdr': instance.jsonIdHdr,
  'palka_s_no': instance.jsonPalkaSNo,
  'palka_c_no': instance.jsonPalkaCNo,
  'palka_p_no': instance.jsonPalkaPNo,
  'palka_s_ffa': instance.jsonPalkaSFfa,
  'palka_s_iv': instance.jsonPalkaSIv,
  'palka_s_dobi': instance.jsonPalkaSDobi,
  'palka_s_mni': instance.jsonPalkaSMni,
  'palka_c_ffa': instance.jsonPalkaCFfa,
  'palka_c_iv': instance.jsonPalkaCIv,
  'palka_c_dobi': instance.jsonPalkaCDobi,
  'palka_c_mni': instance.jsonPalkaCMni,
  'palka_p_ffa': instance.jsonPalkaPFfa,
  'palka_p_iv': instance.jsonPalkaPIv,
  'palka_p_dobi': instance.jsonPalkaPDobi,
  'palka_p_mni': instance.jsonPalkaPMni,
};
