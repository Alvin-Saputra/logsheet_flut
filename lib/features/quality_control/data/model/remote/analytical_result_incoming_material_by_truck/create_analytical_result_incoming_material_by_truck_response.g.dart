// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_analytical_result_incoming_material_by_truck_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateAnalyticalResultIncomingMaterialByTruckResponse
_$CreateAnalyticalResultIncomingMaterialByTruckResponseFromJson(
  Map<String, dynamic> json,
) => CreateAnalyticalResultIncomingMaterialByTruckResponse(
  success: json['success'] as bool,
  idHeader: json['id_header'] as String,
  idDet: (json['id_det'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic>
_$CreateAnalyticalResultIncomingMaterialByTruckResponseToJson(
  CreateAnalyticalResultIncomingMaterialByTruckResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'id_header': instance.idHeader,
  'id_det': instance.idDet,
};
