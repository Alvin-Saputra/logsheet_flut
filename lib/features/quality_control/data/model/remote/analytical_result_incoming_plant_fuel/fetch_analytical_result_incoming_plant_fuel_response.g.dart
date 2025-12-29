// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_analytical_result_incoming_plant_fuel_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchAnalyticalResultIncomingPlantFuelResponse
_$FetchAnalyticalResultIncomingPlantFuelResponseFromJson(
  Map<String, dynamic> json,
) => FetchAnalyticalResultIncomingPlantFuelResponse(
  success: json['success'] as bool,
  data:
      (json['data'] as List<dynamic>)
          .map(
            (e) => AnalyticalWithRoaModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
);

Map<String, dynamic> _$FetchAnalyticalResultIncomingPlantFuelResponseToJson(
  FetchAnalyticalResultIncomingPlantFuelResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.map((e) => e.toJson()).toList(),
};
