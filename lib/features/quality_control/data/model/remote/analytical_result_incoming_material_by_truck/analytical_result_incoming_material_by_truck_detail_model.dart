import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_truck/analytical_result_incoming_material_by_truck_detail_entity.dart';
part 'analytical_result_incoming_material_by_truck_detail_model.g.dart';

@JsonSerializable()
class AnalyticalResultIncomingMaterialByTruckDetailModel
    extends AnalyticalResultIncomingMaterialByTruckDetailEntity {
  @JsonKey(name: 'id')
  final String jsonId;

  @JsonKey(name: 'id_hdr')
  final String jsonIdHdr;

  // Case 1: JSON berupa String (perlu diparse ke double)
  @JsonKey(name: 'no')
  final String? jsonNo;

  @JsonKey(name: 'sampling_date')
  final String? jsonSamplingDate;

  @JsonKey(name: 'police_no')
  final String? jsonPoliceNo;

  // Case 2: JSON berupa String/angka (perlu di-cast ke double)
  @JsonKey(name: 'p_ffa')
  final String? jsonPFfa;

  @JsonKey(name: 'p_moisture')
  final String? jsonPMoisture;

  @JsonKey(name: 'p_iv')
  final String? jsonPIv;

  @JsonKey(name: 'p_dobi')
  final String? jsonPDobi;

  @JsonKey(name: 'p_pv')
  final String? jsonPPv;

  @JsonKey(name: 'p_color_r')
  final String? jsonPColorR;

  @JsonKey(name: 'p_color_y')
  final String? jsonPColorY;

  @JsonKey(name: 'analis')
  final String? jsonAnalis;

  @JsonKey(name: 'remarks')
  final String? jsonRemark;

  AnalyticalResultIncomingMaterialByTruckDetailModel({
    required this.jsonId,
    required this.jsonIdHdr,
    this.jsonNo,
    this.jsonSamplingDate,
    this.jsonPoliceNo,
    this.jsonPFfa,
    this.jsonPMoisture,
    this.jsonPIv,
    this.jsonPDobi,
    this.jsonPPv,
    this.jsonPColorR,
    this.jsonPColorY,
    this.jsonAnalis,
    this.jsonRemark,
  }) : super(
         id: jsonId,
         idHdr: jsonIdHdr,
         no: jsonNo,
         samplingDate:
             jsonSamplingDate != null
                 ? DateTime.tryParse(jsonSamplingDate)
                 : null,
         policeNo: jsonPoliceNo,
         pFfa: parseDouble(jsonPFfa),
         pMoisture: parseDouble(jsonPMoisture),
         pIv: parseDouble(jsonPIv),
         pDobi: parseDouble(jsonPDobi),
         pPv: parseDouble(jsonPPv),
         pColorR: parseDouble(jsonPColorR),
         pColorY: parseDouble(jsonPColorY),
         analis: jsonAnalis,
         remarks: jsonRemark,
       );

  factory AnalyticalResultIncomingMaterialByTruckDetailModel.fromJson(
    Map<String, dynamic> json,
  ) => _$AnalyticalResultIncomingMaterialByTruckDetailModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AnalyticalResultIncomingMaterialByTruckDetailModelToJson(this);
}
