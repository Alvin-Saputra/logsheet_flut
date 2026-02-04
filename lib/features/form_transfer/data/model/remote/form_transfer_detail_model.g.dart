// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_transfer_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormTransferDetailModel _$FormTransferDetailModelFromJson(
  Map<String, dynamic> json,
) => FormTransferDetailModel(
  jsonId: json['id'] as String,
  jsonIdHdr: json['id_hdr'] as String,
  jsonOilType: json['oil_type'] as String?,
  jsonQuantity: json['quantity'] as String?,
  jsonFromStorageTankNo: json['from_storage_tank_no'] as String?,
  jsonFromRefineryFractionation: json['from_refinery_fractionation'] as String?,
  jsonFromOther: json['from_other'] as String?,
  jsonToStorageTankNo: json['to_storage_tank_no'] as String?,
  jsonToRefineryFractionation: json['to_refinery_fractionation'] as String?,
  jsonToAutoFillingTank: parseInt(json['to_auto_filling_tank']),
  jsonToOther: json['to_other'] as String?,
  jsonQualityMAndI: parseDouble(json['quality_m_and_i']),
  jsonQualityFfa: parseDouble(json['quality_ffa']),
  jsonQualityLovColorR: parseDouble(json['quality_lov_color_r']),
  jsonQualityLovColorY: parseDouble(json['quality_lov_color_y']),
  jsonQualityCpTemp: parseDouble(json['quality_cp_temp']),
  jsonQualitySmp: parseDouble(json['quality_smp']),
  jsonQualityPv: parseDouble(json['quality_pv']),
  jsonQualityIv: parseDouble(json['quality_iv']),
  jsonRemark: json['remark'] as String?,
  jsonDeletedAt: json['deleted_at'] as String?,
);

Map<String, dynamic> _$FormTransferDetailModelToJson(
  FormTransferDetailModel instance,
) => <String, dynamic>{
  'id': instance.jsonId,
  'id_hdr': instance.jsonIdHdr,
  'oil_type': instance.jsonOilType,
  'quantity': instance.jsonQuantity,
  'from_storage_tank_no': instance.jsonFromStorageTankNo,
  'from_refinery_fractionation': instance.jsonFromRefineryFractionation,
  'from_other': instance.jsonFromOther,
  'to_storage_tank_no': instance.jsonToStorageTankNo,
  'to_refinery_fractionation': instance.jsonToRefineryFractionation,
  'to_auto_filling_tank': instance.jsonToAutoFillingTank,
  'to_other': instance.jsonToOther,
  'quality_m_and_i': instance.jsonQualityMAndI,
  'quality_ffa': instance.jsonQualityFfa,
  'quality_lov_color_r': instance.jsonQualityLovColorR,
  'quality_lov_color_y': instance.jsonQualityLovColorY,
  'quality_cp_temp': instance.jsonQualityCpTemp,
  'quality_smp': instance.jsonQualitySmp,
  'quality_pv': instance.jsonQualityPv,
  'quality_iv': instance.jsonQualityIv,
  'remark': instance.jsonRemark,
  'deleted_at': instance.jsonDeletedAt,
};
