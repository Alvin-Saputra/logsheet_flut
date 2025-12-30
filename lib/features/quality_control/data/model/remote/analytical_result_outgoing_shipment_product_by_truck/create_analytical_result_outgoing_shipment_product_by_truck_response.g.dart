// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_analytical_result_outgoing_shipment_product_by_truck_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateAnalyticalResultOutgoingShipmentProductByTruckResponse
_$CreateAnalyticalResultOutgoingShipmentProductByTruckResponseFromJson(
  Map<String, dynamic> json,
) => CreateAnalyticalResultOutgoingShipmentProductByTruckResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data:
      json['data'] == null
          ? null
          : ResultData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic>
_$CreateAnalyticalResultOutgoingShipmentProductByTruckResponseToJson(
  CreateAnalyticalResultOutgoingShipmentProductByTruckResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

ResultData _$ResultDataFromJson(Map<String, dynamic> json) =>
    ResultData(idHeader: json['aroip_header_id'] as String?);

Map<String, dynamic> _$ResultDataToJson(ResultData instance) =>
    <String, dynamic>{'aroip_header_id': instance.idHeader};
