import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_plant_fuel/analytical_with_roa_model.dart';

part 'fetch_analytical_result_incoming_plant_fuel_response.g.dart';

@JsonSerializable(explicitToJson: true)
class FetchAnalyticalResultIncomingPlantFuelResponse {
  final bool success;
  final List<AnalyticalWithRoaModel> data;

  FetchAnalyticalResultIncomingPlantFuelResponse({
    required this.success,
    required this.data,
  });

  factory FetchAnalyticalResultIncomingPlantFuelResponse.fromJson(
          Map<String, dynamic> json) =>
      _$FetchAnalyticalResultIncomingPlantFuelResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FetchAnalyticalResultIncomingPlantFuelResponseToJson(this);
}

