// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytical_result_incoming_plant_fuel_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticalResultIncomingPlantFuelDetailModel
_$AnalyticalResultIncomingPlantFuelDetailModelFromJson(
  Map<String, dynamic> json,
) => AnalyticalResultIncomingPlantFuelDetailModel(
  jsonId: json['id'] as String,
  jsonIdHdr: json['id_hdr'] as String,
  jsonSpecification: json['specification'] as String?,
  jsonStatusOk: json['status_ok'] as String?,
  jsonParameter: json['parameter'] as String?,
  jsonResult: json['result'] as String?,
  jsonRemark: json['remark'] as String?,
  jsonDeletedAt: json['deleted_at'] as String?,
);

Map<String, dynamic> _$AnalyticalResultIncomingPlantFuelDetailModelToJson(
  AnalyticalResultIncomingPlantFuelDetailModel instance,
) => <String, dynamic>{
  'id': instance.jsonId,
  'id_hdr': instance.jsonIdHdr,
  'specification': instance.jsonSpecification,
  'status_ok': instance.jsonStatusOk,
  'parameter': instance.jsonParameter,
  'result': instance.jsonResult,
  'remark': instance.jsonRemark,
  'deleted_at': instance.jsonDeletedAt,
};
