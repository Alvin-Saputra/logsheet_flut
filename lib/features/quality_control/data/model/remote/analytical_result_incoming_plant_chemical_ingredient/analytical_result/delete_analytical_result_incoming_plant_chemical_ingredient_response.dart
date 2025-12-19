import 'package:json_annotation/json_annotation.dart';

part 'delete_analytical_result_incoming_plant_chemical_ingredient_response.g.dart';

@JsonSerializable()
class DeleteAnalyticalResultIncomingPlantChemicalIngredientResponse {
  final bool success;
  final String message;

  DeleteAnalyticalResultIncomingPlantChemicalIngredientResponse({
    required this.success,
    required this.message,
  });

  factory DeleteAnalyticalResultIncomingPlantChemicalIngredientResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$DeleteAnalyticalResultIncomingPlantChemicalIngredientResponseFromJson(
    json,
  );

  Map<String, dynamic> toJson() =>
      _$DeleteAnalyticalResultIncomingPlantChemicalIngredientResponseToJson(
        this,
      );
}
