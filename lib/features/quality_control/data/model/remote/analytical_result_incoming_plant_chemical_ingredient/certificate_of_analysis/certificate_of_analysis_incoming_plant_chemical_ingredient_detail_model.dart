import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_truck/analytical_result_incoming_material_by_truck_detail_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/certificate_of_analysis_incoming_plant_chemical_ingredient_detail_entity.dart';
part 'certificate_of_analysis_incoming_plant_chemical_ingredient_detail_model.g.dart';

@JsonSerializable()
class CertificateOfAnalysisIncomingPlantChemicalIngredientDetailModel
    extends CertificateOfAnalysisIncomingPlantChemicalIngredientDetailEntity {
  @JsonKey(name: 'id')
  final String jsonId;

  @JsonKey(name: 'id_hdr')
  final String jsonIdHdr;

  // Case 1: JSON berupa String (perlu diparse ke double)
  @JsonKey(name: 'parameter')
  final String? jsonParameter;

  @JsonKey(name: 'actual_min')
  final String? jsonActualMin;

  @JsonKey(name: 'actual_max')
  final String? jsonActualMax;

  @JsonKey(name: 'standard_min')
  final String? jsonStandardMin;

  @JsonKey(name: 'standard_max')
  final String? jsonStandardMax;

  // Case 2: JSON berupa num/angka (perlu di-cast ke double)
  @JsonKey(name: 'method')
  final String? jsonMethod;

  CertificateOfAnalysisIncomingPlantChemicalIngredientDetailModel({
    required this.jsonId,
    required this.jsonIdHdr,
    this.jsonParameter,
    this.jsonActualMin,
    this.jsonActualMax,
    this.jsonStandardMin,
    this.jsonStandardMax,
    this.jsonMethod,
  }) : super(
         id: jsonId,
         idHdr: jsonIdHdr,
         parameter: jsonParameter,
         actualMin: parseDouble(jsonActualMin),
         actualMax: parseDouble(jsonActualMax),
         standardMin: parseDouble(jsonStandardMin),
         standardMax: parseDouble(jsonStandardMax),
         method: jsonMethod,
       );

  factory CertificateOfAnalysisIncomingPlantChemicalIngredientDetailModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CertificateOfAnalysisIncomingPlantChemicalIngredientDetailModelFromJson(
        json,
      );

  Map<String, dynamic> toJson() =>
      _$CertificateOfAnalysisIncomingPlantChemicalIngredientDetailModelToJson(
        this,
      );
}
