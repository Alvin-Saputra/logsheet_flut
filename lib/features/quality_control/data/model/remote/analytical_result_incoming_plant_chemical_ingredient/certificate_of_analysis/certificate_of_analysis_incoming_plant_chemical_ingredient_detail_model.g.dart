// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate_of_analysis_incoming_plant_chemical_ingredient_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CertificateOfAnalysisIncomingPlantChemicalIngredientDetailModel
_$CertificateOfAnalysisIncomingPlantChemicalIngredientDetailModelFromJson(
  Map<String, dynamic> json,
) => CertificateOfAnalysisIncomingPlantChemicalIngredientDetailModel(
  jsonId: json['id'] as String,
  jsonIdHdr: json['id_hdr'] as String,
  jsonParameter: json['parameter'] as String?,
  jsonActualMin: json['actual_min'] as String?,
  jsonActualMax: json['actual_max'] as String?,
  jsonStandardMin: json['standard_min'] as String?,
  jsonStandardMax: json['standard_max'] as String?,
  jsonMethod: json['method'] as String?,
);

Map<String, dynamic>
_$CertificateOfAnalysisIncomingPlantChemicalIngredientDetailModelToJson(
  CertificateOfAnalysisIncomingPlantChemicalIngredientDetailModel instance,
) => <String, dynamic>{
  'id': instance.jsonId,
  'id_hdr': instance.jsonIdHdr,
  'parameter': instance.jsonParameter,
  'actual_min': instance.jsonActualMin,
  'actual_max': instance.jsonActualMax,
  'standard_min': instance.jsonStandardMin,
  'standard_max': instance.jsonStandardMax,
  'method': instance.jsonMethod,
};
