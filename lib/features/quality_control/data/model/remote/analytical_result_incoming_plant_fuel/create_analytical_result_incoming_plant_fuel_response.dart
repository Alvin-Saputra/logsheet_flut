import 'package:json_annotation/json_annotation.dart';

part 'create_analytical_result_incoming_plant_fuel_response.g.dart';

@JsonSerializable()
class CreateAnalyticalResultIncomingPlantFuelResponse {
  final bool? success;
  final String? message;
  final CreateAnalyticalResultData? data; // Data berada di dalam objek sendiri

  CreateAnalyticalResultIncomingPlantFuelResponse({
    this.success,
    this.message,
    this.data,
  });

  factory CreateAnalyticalResultIncomingPlantFuelResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateAnalyticalResultIncomingPlantFuelResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CreateAnalyticalResultIncomingPlantFuelResponseToJson(this);
}

@JsonSerializable()
class CreateAnalyticalResultData {
  @JsonKey(name: "aroip_header_id")
  final String? idHeaderAroip;

  @JsonKey(name: "roa_header_id") // Sesuai dengan JSON: coa_header_id
  final String? idRoa;

  CreateAnalyticalResultData({
    this.idHeaderAroip,
    this.idRoa,
  });

  factory CreateAnalyticalResultData.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateAnalyticalResultDataFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAnalyticalResultDataToJson(this);
}