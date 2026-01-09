import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_header_model.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_outgoing_shipment_product_by_vessel/analytical_result_outgoing_shipment_product_by_vessel_header_model.dart';

part 'fetch_analytical_result_outgoing_shipment_product_by_vessel_response.g.dart';

@JsonSerializable(explicitToJson: true)
class FetchAnalyticalResultOutgoingShipmentProductByVesselResponse {
  final bool success;
  final List<AnalyticalResultOutgoingShipmentProductByVesselHeaderModel> data;

  FetchAnalyticalResultOutgoingShipmentProductByVesselResponse({
    required this.success,
    required this.data,
  });

  factory FetchAnalyticalResultOutgoingShipmentProductByVesselResponse.fromJson(
          Map<String, dynamic> json) =>
      _$FetchAnalyticalResultOutgoingShipmentProductByVesselResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FetchAnalyticalResultOutgoingShipmentProductByVesselResponseToJson(this);
}
