import 'package:json_annotation/json_annotation.dart';

part 'update_analytical_result_outgoing_shipment_product_by_vessel_response.g.dart';

@JsonSerializable()
class UpdateAnalyticalResultOutgoingShipmentProductByVesselResponse {
  final bool? success;
  final String? message;

  UpdateAnalyticalResultOutgoingShipmentProductByVesselResponse({
    this.success,
    this.message,
  });

  factory UpdateAnalyticalResultOutgoingShipmentProductByVesselResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateAnalyticalResultOutgoingShipmentProductByVesselResponseFromJson(
    json,
  );

  Map<String, dynamic> toJson() =>
      _$UpdateAnalyticalResultOutgoingShipmentProductByVesselResponseToJson(
        this,
      );
}
