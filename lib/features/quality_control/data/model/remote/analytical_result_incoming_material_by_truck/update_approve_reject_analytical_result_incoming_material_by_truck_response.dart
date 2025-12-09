import 'package:json_annotation/json_annotation.dart';

part 'update_approve_reject_analytical_result_incoming_material_by_truck_response.g.dart';

@JsonSerializable()
class UpdateApproveRejectAnalyticalResultIncomingMaterialByTruckResponse {
  final bool success;
  final String message;

  UpdateApproveRejectAnalyticalResultIncomingMaterialByTruckResponse({
    required this.success,
    required this.message,
  });

  factory UpdateApproveRejectAnalyticalResultIncomingMaterialByTruckResponse.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$UpdateApproveRejectAnalyticalResultIncomingMaterialByTruckResponseFromJson(
        json,
      );

  Map<String, dynamic> toJson() =>
      _$UpdateApproveRejectAnalyticalResultIncomingMaterialByTruckResponseToJson(
        this,
      );
}
