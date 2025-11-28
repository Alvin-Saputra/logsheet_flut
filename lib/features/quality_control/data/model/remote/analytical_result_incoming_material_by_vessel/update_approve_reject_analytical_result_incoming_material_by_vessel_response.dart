import 'package:json_annotation/json_annotation.dart';

part 'update_approve_reject_analytical_result_incoming_material_by_vessel_response.g.dart';

@JsonSerializable()
class UpdateApproveRejectAnalyticalResultIncomingMaterialByVesselResponse {
  final bool success;
  final String message;

  UpdateApproveRejectAnalyticalResultIncomingMaterialByVesselResponse({
    required this.success,
    required this.message,
  });

  factory UpdateApproveRejectAnalyticalResultIncomingMaterialByVesselResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateApproveRejectAnalyticalResultIncomingMaterialByVesselResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateApproveRejectAnalyticalResultIncomingMaterialByVesselResponseToJson(this);
}
