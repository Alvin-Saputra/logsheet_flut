// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_analytical_result_incoming_material_by_truck_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateAnalyticalResultIncomingMaterialByTruckResponse
_$UpdateAnalyticalResultIncomingMaterialByTruckResponseFromJson(
  Map<String, dynamic> json,
) => UpdateAnalyticalResultIncomingMaterialByTruckResponse(
  success: json['success'] as bool,
  idHeader: json['id_header'] as String,
  idDet: (json['id_det'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic>
_$UpdateAnalyticalResultIncomingMaterialByTruckResponseToJson(
  UpdateAnalyticalResultIncomingMaterialByTruckResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'id_header': instance.idHeader,
  'id_det': instance.idDet,
};
