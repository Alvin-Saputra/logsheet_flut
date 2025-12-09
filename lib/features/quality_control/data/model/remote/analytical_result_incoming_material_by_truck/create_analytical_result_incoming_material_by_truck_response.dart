import 'package:json_annotation/json_annotation.dart';

part 'create_analytical_result_incoming_material_by_truck_response.g.dart';

@JsonSerializable()
class CreateAnalyticalResultIncomingMaterialByTruckResponse {
  final bool success;

  @JsonKey(name: "id_header")
  final String idHeader;

  @JsonKey(name: "id_det")
  final List<String> idDet;

  CreateAnalyticalResultIncomingMaterialByTruckResponse({
    required this.success,
    required this.idHeader,
    required this.idDet,
  });

  factory CreateAnalyticalResultIncomingMaterialByTruckResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateAnalyticalResultIncomingMaterialByTruckResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAnalyticalResultIncomingMaterialByTruckResponseToJson(this);
}
