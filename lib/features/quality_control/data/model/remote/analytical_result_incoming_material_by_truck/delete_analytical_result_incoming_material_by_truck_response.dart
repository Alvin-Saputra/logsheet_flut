import 'package:json_annotation/json_annotation.dart';

part 'delete_analytical_result_incoming_material_by_truck_response.g.dart';

@JsonSerializable()
class DeleteAnalyticalResultIncomingMaterialByTruckResponse {
  final bool success;

  DeleteAnalyticalResultIncomingMaterialByTruckResponse({
    required this.success,
  });

  factory DeleteAnalyticalResultIncomingMaterialByTruckResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$DeleteAnalyticalResultIncomingMaterialByTruckResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DeleteAnalyticalResultIncomingMaterialByTruckResponseToJson(this);
}
