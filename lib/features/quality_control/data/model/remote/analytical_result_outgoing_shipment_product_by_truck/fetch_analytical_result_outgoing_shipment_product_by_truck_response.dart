import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_outgoing_shipment_product_by_truck/analytical_result_outgoing_shipment_product_by_truck_header_model.dart';

part 'fetch_analytical_result_outgoing_shipment_product_by_truck_response.g.dart';

@JsonSerializable(explicitToJson: true)
class FetchAnalyticalResultOutgoingShipmentProductByTruckResponse {
  final bool success;
  final List<AnalyticalResultOutgoingShipmentProductByTruckHeaderModel> data;

  FetchAnalyticalResultOutgoingShipmentProductByTruckResponse({
    required this.success,
    required this.data,
  });

  factory FetchAnalyticalResultOutgoingShipmentProductByTruckResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$FetchAnalyticalResultOutgoingShipmentProductByTruckResponseFromJson(
    json,
  );

  Map<String, dynamic> toJson() =>
      _$FetchAnalyticalResultOutgoingShipmentProductByTruckResponseToJson(this);
}
