import 'package:json_annotation/json_annotation.dart';

part 'update_analytical_result_outgoing_shipment_product_by_truck_response.g.dart';

@JsonSerializable()
class UpdateAnalyticalResultOutgoingShipmentProductByTruckResponse {
  final bool? success;
  final String? message;

  UpdateAnalyticalResultOutgoingShipmentProductByTruckResponse({
    this.success,
    this.message,
  });

  factory UpdateAnalyticalResultOutgoingShipmentProductByTruckResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateAnalyticalResultOutgoingShipmentProductByTruckResponseFromJson(
    json,
  );

  Map<String, dynamic> toJson() =>
      _$UpdateAnalyticalResultOutgoingShipmentProductByTruckResponseToJson(
        this,
      );
}
