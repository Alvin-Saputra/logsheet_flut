// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_analytical_result_outgoing_shipment_product_by_truck_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchAnalyticalResultOutgoingShipmentProductByTruckResponse
_$FetchAnalyticalResultOutgoingShipmentProductByTruckResponseFromJson(
  Map<String, dynamic> json,
) => FetchAnalyticalResultOutgoingShipmentProductByTruckResponse(
  success: json['success'] as bool,
  data:
      (json['data'] as List<dynamic>)
          .map(
            (e) =>
                AnalyticalResultOutgoingShipmentProductByTruckHeaderModel.fromJson(
                  e as Map<String, dynamic>,
                ),
          )
          .toList(),
);

Map<String, dynamic>
_$FetchAnalyticalResultOutgoingShipmentProductByTruckResponseToJson(
  FetchAnalyticalResultOutgoingShipmentProductByTruckResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.map((e) => e.toJson()).toList(),
};
