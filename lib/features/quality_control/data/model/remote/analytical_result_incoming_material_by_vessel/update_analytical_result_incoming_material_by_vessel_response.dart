import 'package:json_annotation/json_annotation.dart';

part 'update_analytical_result_incoming_material_by_vessel_response.g.dart';

@JsonSerializable()
class UpdateAnalyticalResultIncomingMaterialByVesselResponse {
  final bool success;

  @JsonKey(name: "id_header")
  final String idHeader;

  @JsonKey(name: "id_det")
  final List<String> idDet;

  UpdateAnalyticalResultIncomingMaterialByVesselResponse({
    required this.success,
    required this.idHeader,
    required this.idDet,
  });

  factory UpdateAnalyticalResultIncomingMaterialByVesselResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateAnalyticalResultIncomingMaterialByVesselResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateAnalyticalResultIncomingMaterialByVesselResponseToJson(this);
}
