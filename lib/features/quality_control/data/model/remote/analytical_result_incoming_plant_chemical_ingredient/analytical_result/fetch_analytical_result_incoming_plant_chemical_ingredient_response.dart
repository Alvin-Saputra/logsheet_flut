import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_plant_chemical_ingredient/analytical_result/analytical_with_coa_model.dart';

part 'fetch_analytical_result_incoming_plant_chemical_ingredient_response.g.dart';

@JsonSerializable(explicitToJson: true)
class FetchAnalyticalResultIncomingPlantChemicalIngredientResponse {
  final bool success;
  final List<AnalyticalWithCoaModel> data;

  FetchAnalyticalResultIncomingPlantChemicalIngredientResponse({
    required this.success,
    required this.data,
  });

  factory FetchAnalyticalResultIncomingPlantChemicalIngredientResponse.fromJson(
          Map<String, dynamic> json) =>
      _$FetchAnalyticalResultIncomingPlantChemicalIngredientResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FetchAnalyticalResultIncomingPlantChemicalIngredientResponseToJson(this);
}

