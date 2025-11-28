import 'package:json_annotation/json_annotation.dart';

part 'create_analytical_result_incoming_material_by_vessel_response.g.dart';

@JsonSerializable()
class CreateAnalyticalResultIncomingMaterialByVesselResponse {
  final bool success;

  @JsonKey(name: "id_header")
  final String idHeader;

  @JsonKey(name: "id_det")
  final List<String> idDet;

  CreateAnalyticalResultIncomingMaterialByVesselResponse({
    required this.success,
    required this.idHeader,
    required this.idDet,
  });

  factory CreateAnalyticalResultIncomingMaterialByVesselResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateAnalyticalResultIncomingMaterialByVesselResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAnalyticalResultIncomingMaterialByVesselResponseToJson(this);
}
