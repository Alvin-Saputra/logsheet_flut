import 'package:json_annotation/json_annotation.dart';

part 'update_analytical_result_incoming_plant_chemical_ingredient_response.g.dart';

@JsonSerializable()
class UpdateAnalyticalResultIncomingPlantChemicalIngredientResponse {
  final bool? success;
  final String? message;
  final UpdateAnalyticalResultData? data;

  UpdateAnalyticalResultIncomingPlantChemicalIngredientResponse({
    this.success,
    this.message,
    this.data,
  });

  factory UpdateAnalyticalResultIncomingPlantChemicalIngredientResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateAnalyticalResultIncomingPlantChemicalIngredientResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UpdateAnalyticalResultIncomingPlantChemicalIngredientResponseToJson(this);
}

@JsonSerializable()
class UpdateAnalyticalResultData {
  final AnalyticalUpdateInfo? analytical;
  final CoaUpdateInfo? coa;

  UpdateAnalyticalResultData({
    this.analytical,
    this.coa,
  });

  factory UpdateAnalyticalResultData.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateAnalyticalResultDataFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateAnalyticalResultDataToJson(this);
}

@JsonSerializable()
class AnalyticalUpdateInfo {
  @JsonKey(name: "header_id")
  final String? headerId;

  @JsonKey(name: "detail_ids")
  final List<String>? detailIds;

  AnalyticalUpdateInfo({
    this.headerId,
    this.detailIds,
  });

  factory AnalyticalUpdateInfo.fromJson(
    Map<String, dynamic> json,
  ) => _$AnalyticalUpdateInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AnalyticalUpdateInfoToJson(this);
}

@JsonSerializable()
class CoaUpdateInfo {
  @JsonKey(name: "coa_id")
  final String? coaId;

  @JsonKey(name: "detail_ids")
  final List<String>? detailIds;

  CoaUpdateInfo({
    this.coaId,
    this.detailIds,
  });

  factory CoaUpdateInfo.fromJson(
    Map<String, dynamic> json,
  ) => _$CoaUpdateInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CoaUpdateInfoToJson(this);
}