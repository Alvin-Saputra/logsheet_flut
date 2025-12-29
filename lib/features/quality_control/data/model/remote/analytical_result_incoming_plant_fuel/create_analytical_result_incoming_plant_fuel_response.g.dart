// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_analytical_result_incoming_plant_fuel_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateAnalyticalResultIncomingPlantFuelResponse
_$CreateAnalyticalResultIncomingPlantFuelResponseFromJson(
  Map<String, dynamic> json,
) => CreateAnalyticalResultIncomingPlantFuelResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data:
      json['data'] == null
          ? null
          : CreateAnalyticalResultData.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic> _$CreateAnalyticalResultIncomingPlantFuelResponseToJson(
  CreateAnalyticalResultIncomingPlantFuelResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

CreateAnalyticalResultData _$CreateAnalyticalResultDataFromJson(
  Map<String, dynamic> json,
) => CreateAnalyticalResultData(
  idHeaderAroip: json['aroip_header_id'] as String?,
  idRoa: json['roa_header_id'] as String?,
);

Map<String, dynamic> _$CreateAnalyticalResultDataToJson(
  CreateAnalyticalResultData instance,
) => <String, dynamic>{
  'aroip_header_id': instance.idHeaderAroip,
  'roa_header_id': instance.idRoa,
};
