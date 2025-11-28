// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_analytical_result_incoming_material_by_vessel_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchAnalyticalResultIncomingMaterialByVesselResponse
_$FetchAnalyticalResultIncomingMaterialByVesselResponseFromJson(
  Map<String, dynamic> json,
) => FetchAnalyticalResultIncomingMaterialByVesselResponse(
  success: json['success'] as bool,
  data:
      (json['data'] as List<dynamic>)
          .map(
            (e) => AnalyticalResultIncomingMaterialByVesselHeaderModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
);

Map<String, dynamic>
_$FetchAnalyticalResultIncomingMaterialByVesselResponseToJson(
  FetchAnalyticalResultIncomingMaterialByVesselResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.map((e) => e.toJson()).toList(),
};
