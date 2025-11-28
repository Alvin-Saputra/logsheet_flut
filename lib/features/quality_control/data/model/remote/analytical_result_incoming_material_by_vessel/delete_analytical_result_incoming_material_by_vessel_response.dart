import 'package:json_annotation/json_annotation.dart';

part 'delete_analytical_result_incoming_material_by_vessel_response.g.dart';

@JsonSerializable()
class DeleteAnalyticalResultIncomingMaterialByVesselResponse {
  final bool success;

  DeleteAnalyticalResultIncomingMaterialByVesselResponse({
    required this.success,
  });

  factory DeleteAnalyticalResultIncomingMaterialByVesselResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$DeleteAnalyticalResultIncomingMaterialByVesselResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DeleteAnalyticalResultIncomingMaterialByVesselResponseToJson(this);
}
