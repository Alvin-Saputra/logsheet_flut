// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_certificate_of_analysis_incoming_plant_chemical_ingredient_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchCertificateOfAnalysisIncomingPlantChemicalIngredientResponse
_$FetchCertificateOfAnalysisIncomingPlantChemicalIngredientResponseFromJson(
  Map<String, dynamic> json,
) => FetchCertificateOfAnalysisIncomingPlantChemicalIngredientResponse(
  success: json['success'] as bool,
  data:
      (json['data'] as List<dynamic>)
          .map(
            (e) =>
                CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderModel.fromJson(
                  e as Map<String, dynamic>,
                ),
          )
          .toList(),
);

Map<String, dynamic>
_$FetchCertificateOfAnalysisIncomingPlantChemicalIngredientResponseToJson(
  FetchCertificateOfAnalysisIncomingPlantChemicalIngredientResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.map((e) => e.toJson()).toList(),
};
