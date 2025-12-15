// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_certificate_of_analysis_incoming_plant_chemical_ingredient_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateCertificateOfAnalysisIncomingPlantChemicalIngredientResponse
_$CreateCertificateOfAnalysisIncomingPlantChemicalIngredientResponseFromJson(
  Map<String, dynamic> json,
) => CreateCertificateOfAnalysisIncomingPlantChemicalIngredientResponse(
  success: json['success'] as bool,
  idHeader: json['header_id'] as String,
  idDet: (json['detail_ids'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic>
_$CreateCertificateOfAnalysisIncomingPlantChemicalIngredientResponseToJson(
  CreateCertificateOfAnalysisIncomingPlantChemicalIngredientResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'header_id': instance.idHeader,
  'detail_ids': instance.idDet,
};
