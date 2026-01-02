import 'package:json_annotation/json_annotation.dart';

part 'update_approve_reject_analytical_result_outgoing_shipment_product_by_truck_response.g.dart';

@JsonSerializable()
class UpdateApproveRejectAnalyticalResultOutgoingShipmentProductByTruckResponse {
  final bool success;
  final String message;
  final UpdateApproveRejectAnalyticalResultData? data;

  UpdateApproveRejectAnalyticalResultOutgoingShipmentProductByTruckResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory UpdateApproveRejectAnalyticalResultOutgoingShipmentProductByTruckResponse.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$UpdateApproveRejectAnalyticalResultOutgoingShipmentProductByTruckResponseFromJson(
        json,
      );

  Map<String, dynamic> toJson() =>
      _$UpdateApproveRejectAnalyticalResultOutgoingShipmentProductByTruckResponseToJson(
        this,
      );
}

@JsonSerializable()
class UpdateApproveRejectAnalyticalResultData {
  final String id;
  final String status;
  final String? remarks;

  @JsonKey(name: 'updated_by')
  final String updatedBy;

  @JsonKey(name: 'updated_at')
  final String updatedAt;

  UpdateApproveRejectAnalyticalResultData({
    required this.id,
    required this.status,
    this.remarks,
    required this.updatedBy,
    required this.updatedAt,
  });

  factory UpdateApproveRejectAnalyticalResultData.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateApproveRejectAnalyticalResultDataFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UpdateApproveRejectAnalyticalResultDataToJson(this);
}
