import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_chemical_ingredient/analytical_result/analytical_result_incoming_plant_chemical_ingredient_detail_entity.dart';
part 'analytical_result_incoming_plant_chemical_ingredient_detail_model.g.dart';

@JsonSerializable()
class AnalyticalResultIncomingPlantChemicalIngredientDetailModel
    extends AnalyticalResultIncomingPlantChemicalIngredientDetailEntity {
  @JsonKey(name: 'id')
  final String jsonId;

  @JsonKey(name: 'id_hdr')
  final String jsonIdHdr;

  @JsonKey(name: 'specification_min')
  final String? jsonSpecificationMin;

  @JsonKey(name: 'specification_max')
  final String? jsonSpecificationMax;

  @JsonKey(name: 'status_ok')
  final String? jsonStatusOk;

  @JsonKey(name: 'parameter')
  final String? jsonParameter;

  @JsonKey(name: 'result_min')
  final String? jsonResultMin;

  @JsonKey(name: 'result_max')
  final String? jsonResultMax;

  @JsonKey(name: 'remark')
  final String? jsonRemark;

  @JsonKey(name: 'deleted_at')
  final String? jsonDeletedAt;

  AnalyticalResultIncomingPlantChemicalIngredientDetailModel({
    required this.jsonId,
    required this.jsonIdHdr,
    this.jsonSpecificationMin,
    this.jsonSpecificationMax,
    this.jsonStatusOk,
    this.jsonParameter,
    this.jsonResultMin,
    this.jsonResultMax,
    this.jsonRemark,
    this.jsonDeletedAt,
  }) : super(
         id: jsonId,
         idHdr: jsonIdHdr,
         specificationMin: parseDouble(jsonSpecificationMin),
         specificationMax: parseDouble(jsonSpecificationMax),
         statusOk: jsonStatusOk,
         parameter: jsonParameter,
         resultMin: parseDouble(jsonResultMin),
         resultMax: parseDouble(jsonResultMax),
         remark: jsonRemark,
         deletedAt: formatStringtoDate(
           jsonDeletedAt ?? '',
           'yyyy-MM-dd HH:mm:ss',
         ),
       );

  factory AnalyticalResultIncomingPlantChemicalIngredientDetailModel.fromJson(
    Map<String, dynamic> json,
  ) => _$AnalyticalResultIncomingPlantChemicalIngredientDetailModelFromJson(
    json,
  );

  Map<String, dynamic> toJson() =>
      _$AnalyticalResultIncomingPlantChemicalIngredientDetailModelToJson(this);
}
