import 'package:json_annotation/json_annotation.dart';

part 'delete_analytical_result_incoming_plant_fuel_response.g.dart';

@JsonSerializable()
class DeleteAnalyticalResultIncomingPlantFuelResponse {
  final bool success;
  final String message;

  DeleteAnalyticalResultIncomingPlantFuelResponse({
    required this.success,
    required this.message,
  });

  factory DeleteAnalyticalResultIncomingPlantFuelResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$DeleteAnalyticalResultIncomingPlantFuelResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DeleteAnalyticalResultIncomingPlantFuelResponseToJson(this);
}
