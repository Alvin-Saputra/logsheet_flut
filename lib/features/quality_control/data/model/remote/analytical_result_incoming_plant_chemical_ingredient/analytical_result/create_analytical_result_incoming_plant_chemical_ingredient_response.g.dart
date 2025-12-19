// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_analytical_result_incoming_plant_chemical_ingredient_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateAnalyticalResultIncomingPlantChemicalIngredientResponse
_$CreateAnalyticalResultIncomingPlantChemicalIngredientResponseFromJson(
  Map<String, dynamic> json,
) => CreateAnalyticalResultIncomingPlantChemicalIngredientResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data:
      json['data'] == null
          ? null
          : CreateAnalyticalResultData.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic>
_$CreateAnalyticalResultIncomingPlantChemicalIngredientResponseToJson(
  CreateAnalyticalResultIncomingPlantChemicalIngredientResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

CreateAnalyticalResultData _$CreateAnalyticalResultDataFromJson(
  Map<String, dynamic> json,
) => CreateAnalyticalResultData(
  idHeaderAroip: json['aroip_header_id'] as String?,
  idCoa: json['coa_header_id'] as String?,
  idAroipDet:
      (json['aroip_detail_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
  idCoaDet:
      (json['coa_detail_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
);

Map<String, dynamic> _$CreateAnalyticalResultDataToJson(
  CreateAnalyticalResultData instance,
) => <String, dynamic>{
  'aroip_header_id': instance.idHeaderAroip,
  'coa_header_id': instance.idCoa,
  'aroip_detail_ids': instance.idAroipDet,
  'coa_detail_ids': instance.idCoaDet,
};
