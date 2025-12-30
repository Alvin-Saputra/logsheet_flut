import 'package:json_annotation/json_annotation.dart';

part 'create_analytical_result_outgoing_shipment_product_by_truck_response.g.dart';

@JsonSerializable()
class CreateAnalyticalResultOutgoingShipmentProductByTruckResponse {
  final bool? success;
  final String? message;
  final ResultData? data; // Data berada di dalam objek sendiri

  CreateAnalyticalResultOutgoingShipmentProductByTruckResponse({
    this.success,
    this.message,
    this.data,
  });

  factory CreateAnalyticalResultOutgoingShipmentProductByTruckResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateAnalyticalResultOutgoingShipmentProductByTruckResponseFromJson(
    json,
  );

  Map<String, dynamic> toJson() =>
      _$CreateAnalyticalResultOutgoingShipmentProductByTruckResponseToJson(
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
