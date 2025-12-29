// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_of_analysis_incoming_plant_fuel_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportOfAnalysisIncomingPlantFuelDetailModel
_$ReportOfAnalysisIncomingPlantFuelDetailModelFromJson(
  Map<String, dynamic> json,
) => ReportOfAnalysisIncomingPlantFuelDetailModel(
  jsonId: json['id'] as String,
  jsonIdHdr: json['id_hdr'] as String,
  jsonParameter: json['parameter'] as String?,
  jsonUnit: json['unit'] as String?,
  jsonBasis: json['basis'] as String?,
  jsonResult: json['result'] as String?,
);

Map<String, dynamic> _$ReportOfAnalysisIncomingPlantFuelDetailModelToJson(
  ReportOfAnalysisIncomingPlantFuelDetailModel instance,
) => <String, dynamic>{
  'id': instance.jsonId,
  'id_hdr': instance.jsonIdHdr,
  'parameter': instance.jsonParameter,
  'unit': instance.jsonUnit,
  'basis': instance.jsonBasis,
  'result': instance.jsonResult,
};
