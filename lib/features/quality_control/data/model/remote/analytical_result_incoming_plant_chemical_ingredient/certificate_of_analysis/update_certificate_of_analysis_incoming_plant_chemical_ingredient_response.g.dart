// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_certificate_of_analysis_incoming_plant_chemical_ingredient_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCertificateOfAnalysisIncomingPlantChemicalIngredientResponse
_$UpdateCertificateOfAnalysisIncomingPlantChemicalIngredientResponseFromJson(
  Map<String, dynamic> json,
) => UpdateCertificateOfAnalysisIncomingPlantChemicalIngredientResponse(
  success: json['success'] as bool,
  idHeader: json['id_header'] as String,
  idDet: (json['id_det'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic>
_$UpdateCertificateOfAnalysisIncomingPlantChemicalIngredientResponseToJson(
  UpdateCertificateOfAnalysisIncomingPlantChemicalIngredientResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'id_header': instance.idHeader,
  'id_det': instance.idDet,
};
