// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytical_result_incoming_plant_chemical_ingredient_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticalResultIncomingPlantChemicalIngredientDetailModel
_$AnalyticalResultIncomingPlantChemicalIngredientDetailModelFromJson(
  Map<String, dynamic> json,
) => AnalyticalResultIncomingPlantChemicalIngredientDetailModel(
  jsonId: json['id'] as String,
  jsonIdHdr: json['id_hdr'] as String,
  jsonSpecificationMin: json['specification_min'] as String?,
  jsonSpecificationMax: json['specification_max'] as String?,
  jsonStatusOk: json['status_ok'] as String?,
  jsonParameter: json['parameter'] as String?,
  jsonResultMin: json['result_min'] as String?,
  jsonResultMax: json['result_max'] as String?,
  jsonRemark: json['remark'] as String?,
  jsonDeletedAt: json['deleted_at'] as String?,
);

Map<String, dynamic>
_$AnalyticalResultIncomingPlantChemicalIngredientDetailModelToJson(
  AnalyticalResultIncomingPlantChemicalIngredientDetailModel instance,
) => <String, dynamic>{
  'id': instance.jsonId,
  'id_hdr': instance.jsonIdHdr,
  'specification_min': instance.jsonSpecificationMin,
  'specification_max': instance.jsonSpecificationMax,
  'status_ok': instance.jsonStatusOk,
  'parameter': instance.jsonParameter,
  'result_min': instance.jsonResultMin,
  'result_max': instance.jsonResultMax,
  'remark': instance.jsonRemark,
  'deleted_at': instance.jsonDeletedAt,
};
