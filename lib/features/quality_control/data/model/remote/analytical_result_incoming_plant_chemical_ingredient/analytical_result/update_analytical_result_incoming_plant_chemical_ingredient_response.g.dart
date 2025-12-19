// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_analytical_result_incoming_plant_chemical_ingredient_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateAnalyticalResultIncomingPlantChemicalIngredientResponse
_$UpdateAnalyticalResultIncomingPlantChemicalIngredientResponseFromJson(
  Map<String, dynamic> json,
) => UpdateAnalyticalResultIncomingPlantChemicalIngredientResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data:
      json['data'] == null
          ? null
          : UpdateAnalyticalResultData.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic>
_$UpdateAnalyticalResultIncomingPlantChemicalIngredientResponseToJson(
  UpdateAnalyticalResultIncomingPlantChemicalIngredientResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

UpdateAnalyticalResultData _$UpdateAnalyticalResultDataFromJson(
  Map<String, dynamic> json,
) => UpdateAnalyticalResultData(
  analytical:
      json['analytical'] == null
          ? null
          : AnalyticalUpdateInfo.fromJson(
            json['analytical'] as Map<String, dynamic>,
          ),
  coa:
      json['coa'] == null
          ? null
          : CoaUpdateInfo.fromJson(json['coa'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UpdateAnalyticalResultDataToJson(
  UpdateAnalyticalResultData instance,
) => <String, dynamic>{'analytical': instance.analytical, 'coa': instance.coa};

AnalyticalUpdateInfo _$AnalyticalUpdateInfoFromJson(
  Map<String, dynamic> json,
) => AnalyticalUpdateInfo(
  headerId: json['header_id'] as String?,
  detailIds:
      (json['detail_ids'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$AnalyticalUpdateInfoToJson(
  AnalyticalUpdateInfo instance,
) => <String, dynamic>{
  'header_id': instance.headerId,
  'detail_ids': instance.detailIds,
};

CoaUpdateInfo _$CoaUpdateInfoFromJson(Map<String, dynamic> json) =>
    CoaUpdateInfo(
      coaId: json['coa_id'] as String?,
      detailIds:
          (json['detail_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$CoaUpdateInfoToJson(CoaUpdateInfo instance) =>
    <String, dynamic>{
      'coa_id': instance.coaId,
      'detail_ids': instance.detailIds,
    };
