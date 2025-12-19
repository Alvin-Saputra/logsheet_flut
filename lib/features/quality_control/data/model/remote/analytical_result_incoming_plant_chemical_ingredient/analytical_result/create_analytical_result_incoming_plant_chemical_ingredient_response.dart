import 'package:json_annotation/json_annotation.dart';

part 'create_analytical_result_incoming_plant_chemical_ingredient_response.g.dart';

@JsonSerializable()
class CreateAnalyticalResultIncomingPlantChemicalIngredientResponse {
  final bool? success;
  final String? message;
  final CreateAnalyticalResultData? data; // Data berada di dalam objek sendiri

  CreateAnalyticalResultIncomingPlantChemicalIngredientResponse({
    this.success,
    this.message,
    this.data,
  });

  factory CreateAnalyticalResultIncomingPlantChemicalIngredientResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateAnalyticalResultIncomingPlantChemicalIngredientResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CreateAnalyticalResultIncomingPlantChemicalIngredientResponseToJson(this);
}

@JsonSerializable()
class CreateAnalyticalResultData {
  @JsonKey(name: "aroip_header_id")
  final String? idHeaderAroip;

  @JsonKey(name: "coa_header_id") // Sesuai dengan JSON: coa_header_id
  final String? idCoa;

  @JsonKey(name: "aroip_detail_ids")
  final List<String>? idAroipDet;

  @JsonKey(name: "coa_detail_ids")
  final List<String>? idCoaDet;

  CreateAnalyticalResultData({
    this.idHeaderAroip,
    this.idCoa,
    this.idAroipDet,
    this.idCoaDet,
  });

  factory CreateAnalyticalResultData.fromJson(
    Map<String, dynamic> json,
  ) => _$CreateAnalyticalResultDataFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAnalyticalResultDataToJson(this);
}