import 'package:json_annotation/json_annotation.dart';

part 'delete_analytical_result_outgoing_shipment_product_by_truck_response.g.dart';

@JsonSerializable()
class DeleteAnalyticalResultOutgoingShipmentProductByTruckResponse {
  final bool success;
  final String? message;

  DeleteAnalyticalResultOutgoingShipmentProductByTruckResponse({
    required this.success,
    this.message,
  });

  factory DeleteAnalyticalResultOutgoingShipmentProductByTruckResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$DeleteAnalyticalResultOutgoingShipmentProductByTruckResponseFromJson(
    json,
  );

  Map<String, dynamic> toJson() =>
      _$DeleteAnalyticalResultOutgoingShipmentProductByTruckResponseToJson(
        this,
      );
}
