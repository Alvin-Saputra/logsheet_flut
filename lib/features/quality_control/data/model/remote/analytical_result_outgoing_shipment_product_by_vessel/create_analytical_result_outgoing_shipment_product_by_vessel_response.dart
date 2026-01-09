import 'package:json_annotation/json_annotation.dart';

part 'create_analytical_result_outgoing_shipment_product_by_vessel_response.g.dart';

@JsonSerializable()
class CreateAnalyticalResultOutgoingShipmentProductByVesselResponse {
  final bool? success;
  final String? message;
  final ResultData? data; // Data berada di dalam objek sendiri

  CreateAnalyticalResultOutgoingShipmentProductByVesselResponse({
    this.success,
    this.message,
    this.data,
  });

  factory CreateAnalyticalResultOutgoingShipmentProductByVesselResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateAnalyticalResultOutgoingShipmentProductByVesselResponseFromJson(
    json,
  );

  Map<String, dynamic> toJson() =>
      _$CreateAnalyticalResultOutgoingShipmentProductByVesselResponseToJson(
        this,
      );
}

@JsonSerializable()
class ResultData {
  @JsonKey(name: "aroip_header_id")
  final String? idHeader;

  ResultData({this.idHeader});

  factory ResultData.fromJson(Map<String, dynamic> json) =>
      _$ResultDataFromJson(json);

  Map<String, dynamic> toJson() => _$ResultDataToJson(this);
}
