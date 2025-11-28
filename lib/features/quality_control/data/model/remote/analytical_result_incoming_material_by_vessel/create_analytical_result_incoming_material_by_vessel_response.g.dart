// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_analytical_result_incoming_material_by_vessel_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateAnalyticalResultIncomingMaterialByVesselResponse
_$CreateAnalyticalResultIncomingMaterialByVesselResponseFromJson(
  Map<String, dynamic> json,
) => CreateAnalyticalResultIncomingMaterialByVesselResponse(
  success: json['success'] as bool,
  idHeader: json['id_header'] as String,
  idDet: (json['id_det'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic>
_$CreateAnalyticalResultIncomingMaterialByVesselResponseToJson(
  CreateAnalyticalResultIncomingMaterialByVesselResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'id_header': instance.idHeader,
  'id_det': instance.idDet,
};
