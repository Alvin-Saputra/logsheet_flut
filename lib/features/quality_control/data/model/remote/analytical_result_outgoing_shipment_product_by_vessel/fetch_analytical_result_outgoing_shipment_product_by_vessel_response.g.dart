// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_analytical_result_outgoing_shipment_product_by_vessel_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchAnalyticalResultOutgoingShipmentProductByVesselResponse
_$FetchAnalyticalResultOutgoingShipmentProductByVesselResponseFromJson(
  Map<String, dynamic> json,
) => FetchAnalyticalResultOutgoingShipmentProductByVesselResponse(
  success: json['success'] as bool,
  data:
      (json['data'] as List<dynamic>)
          .map(
            (e) =>
                AnalyticalResultOutgoingShipmentProductByVesselHeaderModel.fromJson(
                  e as Map<String, dynamic>,
                ),
          )
          .toList(),
);

Map<String, dynamic>
_$FetchAnalyticalResultOutgoingShipmentProductByVesselResponseToJson(
  FetchAnalyticalResultOutgoingShipmentProductByVesselResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.map((e) => e.toJson()).toList(),
};
