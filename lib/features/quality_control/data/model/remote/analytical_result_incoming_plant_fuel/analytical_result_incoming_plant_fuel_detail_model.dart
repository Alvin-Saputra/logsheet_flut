import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_fuel/analytical_result/analytical_result_incoming_plant_fuel_detail_entity.dart';
part 'analytical_result_incoming_plant_fuel_detail_model.g.dart';

@JsonSerializable()
class AnalyticalResultIncomingPlantFuelDetailModel
    extends AnalyticalResultIncomingPlantFuelDetailEntity {
  @JsonKey(name: 'id')
  final String jsonId;

  @JsonKey(name: 'id_hdr')
  final String jsonIdHdr;

  @JsonKey(name: 'specification')
  final String? jsonSpecification;

  @JsonKey(name: 'status_ok')
  final String? jsonStatusOk;

  @JsonKey(name: 'parameter')
  final String? jsonParameter;

  @JsonKey(name: 'result')
  final String? jsonResult;

  @JsonKey(name: 'remark')
  final String? jsonRemark;

  @JsonKey(name: 'deleted_at')
  final String? jsonDeletedAt;

  AnalyticalResultIncomingPlantFuelDetailModel({
    required this.jsonId,
    required this.jsonIdHdr,
    this.jsonSpecification,
    this.jsonStatusOk,
    this.jsonParameter,
    this.jsonResult,
    this.jsonRemark,
    this.jsonDeletedAt,
  }) : super(
         id: jsonId,
         idHdr: jsonIdHdr,
         specification: parseDouble(jsonSpecification),
         statusOk: jsonStatusOk,
         parameter: jsonParameter,
         result: parseDouble(jsonResult),
         remark: jsonRemark,
         deletedAt: formatStringtoDate(
           jsonDeletedAt ?? '',
           'yyyy-MM-dd HH:mm:ss',
         ),
       );

  factory AnalyticalResultIncomingPlantFuelDetailModel.fromJson(
    Map<String, dynamic> json,
  ) => _$AnalyticalResultIncomingPlantFuelDetailModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AnalyticalResultIncomingPlantFuelDetailModelToJson(this);
}
