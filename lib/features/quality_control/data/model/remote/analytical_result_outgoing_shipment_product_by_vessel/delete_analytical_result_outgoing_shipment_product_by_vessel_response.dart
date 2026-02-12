import 'package:json_annotation/json_annotation.dart';

part 'delete_analytical_result_outgoing_shipment_product_by_vessel_response.g.dart';

@JsonSerializable()
class DeleteAnalyticalResultOutgoingShipmentProductByVesselResponse {
  final bool success;
  final String? message;

  DeleteAnalyticalResultOutgoingShipmentProductByVesselResponse({
    required this.success,
    this.message,
  });

  factory DeleteAnalyticalResultOutgoingShipmentProductByVesselResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$DeleteAnalyticalResultOutgoingShipmentProductByVesselResponseFromJson(
    json,
  );

  Map<String, dynamic> toJson() =>
      _$DeleteAnalyticalResultOutgoingShipmentProductByVesselResponseToJson(
        this,
      );
}
