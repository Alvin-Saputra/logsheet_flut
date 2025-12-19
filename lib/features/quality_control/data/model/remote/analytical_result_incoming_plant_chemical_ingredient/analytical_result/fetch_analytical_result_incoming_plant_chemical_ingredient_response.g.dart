// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_analytical_result_incoming_plant_chemical_ingredient_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchAnalyticalResultIncomingPlantChemicalIngredientResponse
_$FetchAnalyticalResultIncomingPlantChemicalIngredientResponseFromJson(
  Map<String, dynamic> json,
) => FetchAnalyticalResultIncomingPlantChemicalIngredientResponse(
  success: json['success'] as bool,
  data:
      (json['data'] as List<dynamic>)
          .map(
            (e) => AnalyticalWithCoaModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
);

Map<String, dynamic>
_$FetchAnalyticalResultIncomingPlantChemicalIngredientResponseToJson(
  FetchAnalyticalResultIncomingPlantChemicalIngredientResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.map((e) => e.toJson()).toList(),
};
