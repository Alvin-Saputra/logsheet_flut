import 'package:json_annotation/json_annotation.dart';

part 'update_analytical_result_incoming_plant_fuel_response.g.dart';

@JsonSerializable()
class UpdateAnalyticalResultIncomingPlantFuelResponse {
  final bool? success;
  final String? message;

  UpdateAnalyticalResultIncomingPlantFuelResponse({
    this.success,
    this.message,
  });

  factory UpdateAnalyticalResultIncomingPlantFuelResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateAnalyticalResultIncomingPlantFuelResponseFromJson(
    json,
  );

  Map<String, dynamic> toJson() =>
      _$UpdateAnalyticalResultIncomingPlantFuelResponseToJson(
        this,
      );
}
