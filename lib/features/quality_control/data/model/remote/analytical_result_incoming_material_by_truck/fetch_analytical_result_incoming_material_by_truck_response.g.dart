// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_analytical_result_incoming_material_by_truck_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchAnalyticalResultIncomingMaterialByTruckResponse
_$FetchAnalyticalResultIncomingMaterialByTruckResponseFromJson(
  Map<String, dynamic> json,
) => FetchAnalyticalResultIncomingMaterialByTruckResponse(
  success: json['success'] as bool,
  data:
      (json['data'] as List<dynamic>)
          .map(
            (e) => AnalyticalResultIncomingMaterialByTruckHeaderModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
);

Map<String, dynamic>
_$FetchAnalyticalResultIncomingMaterialByTruckResponseToJson(
  FetchAnalyticalResultIncomingMaterialByTruckResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.map((e) => e.toJson()).toList(),
};
