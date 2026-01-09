// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_analytical_result_outgoing_shipment_product_by_vessel_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateAnalyticalResultOutgoingShipmentProductByVesselResponse
_$CreateAnalyticalResultOutgoingShipmentProductByVesselResponseFromJson(
  Map<String, dynamic> json,
) => CreateAnalyticalResultOutgoingShipmentProductByVesselResponse(
  success: json['success'] as bool?,
  message: json['message'] as String?,
  data:
      json['data'] == null
          ? null
          : ResultData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic>
_$CreateAnalyticalResultOutgoingShipmentProductByVesselResponseToJson(
  CreateAnalyticalResultOutgoingShipmentProductByVesselResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

ResultData _$ResultDataFromJson(Map<String, dynamic> json) =>
    ResultData(idHeader: json['aroip_header_id'] as String?);

Map<String, dynamic> _$ResultDataToJson(ResultData instance) =>
    <String, dynamic>{'aroip_header_id': instance.idHeader};
