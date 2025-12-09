import 'package:json_annotation/json_annotation.dart';

part 'update_analytical_result_incoming_material_by_truck_response.g.dart';

@JsonSerializable()
class UpdateAnalyticalResultIncomingMaterialByTruckResponse {
  final bool success;

  @JsonKey(name: "id_header")
  final String idHeader;

  @JsonKey(name: "id_det")
  final List<String> idDet;

  UpdateAnalyticalResultIncomingMaterialByTruckResponse({
    required this.success,
    required this.idHeader,
    required this.idDet,
  });

  factory UpdateAnalyticalResultIncomingMaterialByTruckResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateAnalyticalResultIncomingMaterialByTruckResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UpdateAnalyticalResultIncomingMaterialByTruckResponseToJson(this);
}
