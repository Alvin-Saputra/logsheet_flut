import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_detail_entity.dart';
part 'analytical_result_incoming_material_by_vessel_detail_model.g.dart';

@JsonSerializable()
class AnalyticalResultIncomingMaterialByVesselDetailModel
    extends AnalyticalResultIncomingMaterialByVesselDetailEntity {
  @JsonKey(name: 'id')
  final String jsonId;

  @JsonKey(name: 'id_hdr')
  final String jsonIdHdr;

  // Case 1: JSON berupa String (perlu diparse ke double)
  @JsonKey(name: 'palka_s_no')
  final int? jsonPalkaSNo;

  @JsonKey(name: 'palka_c_no')
  final int? jsonPalkaCNo;

  @JsonKey(name: 'palka_p_no')
  final int? jsonPalkaPNo;

  // Case 2: JSON berupa String/angka (perlu di-cast ke double)
  @JsonKey(name: 'palka_s_ffa')
  final String? jsonPalkaSFfa;
  @JsonKey(name: 'palka_s_iv')
  final String? jsonPalkaSIv;
  @JsonKey(name: 'palka_s_dobi')
  final String? jsonPalkaSDobi;
  @JsonKey(name: 'palka_s_mni')
  final String? jsonPalkaSMni;

  @JsonKey(name: 'palka_c_ffa')
  final String? jsonPalkaCFfa;
  @JsonKey(name: 'palka_c_iv')
  final String? jsonPalkaCIv;
  @JsonKey(name: 'palka_c_dobi')
  final String? jsonPalkaCDobi;
  @JsonKey(name: 'palka_c_mni')
  final String? jsonPalkaCMni;

  @JsonKey(name: 'palka_p_ffa')
  final String? jsonPalkaPFfa;
  @JsonKey(name: 'palka_p_iv')
  final String? jsonPalkaPIv;
  @JsonKey(name: 'palka_p_dobi')
  final String? jsonPalkaPDobi;
  @JsonKey(name: 'palka_p_mni')
  final String? jsonPalkaPMni;

  AnalyticalResultIncomingMaterialByVesselDetailModel({
    required this.jsonId,
    required this.jsonIdHdr,
    this.jsonPalkaSNo,
    this.jsonPalkaSFfa,
    this.jsonPalkaSIv,
    this.jsonPalkaSDobi,
    this.jsonPalkaSMni,
    this.jsonPalkaCNo,
    this.jsonPalkaCFfa,
    this.jsonPalkaCIv,
    this.jsonPalkaCDobi,
    this.jsonPalkaCMni,
    this.jsonPalkaPNo,
    this.jsonPalkaPFfa,
    this.jsonPalkaPIv,
    this.jsonPalkaPDobi,
    this.jsonPalkaPMni,
  }) : super(
         // --- MAPPING KE ENTITY ---
         id: jsonId,
         idHdr: jsonIdHdr,

         // 1. Konversi String -> Double
         palkaSNo: jsonPalkaSNo,
         palkaCNo: jsonPalkaCNo,
         palkaPNo: jsonPalkaPNo,

         // 2. Konversi Num -> Double
         // .toDouble() aman digunakan pada tipe 'num'
         palkaSFfa: parseDouble(jsonPalkaSFfa),
         palkaSIv: parseDouble(jsonPalkaSIv),
         palkaSDobi: parseDouble(jsonPalkaSDobi),
         palkaSMni: parseDouble(jsonPalkaSMni),

         palkaCFfa: parseDouble(jsonPalkaCFfa),
         palkaCIv: parseDouble(jsonPalkaCIv),
         palkaCDobi: parseDouble(jsonPalkaCDobi),
         palkaCMni: parseDouble(jsonPalkaCMni),

         palkaPFfa: parseDouble(jsonPalkaPFfa),
         palkaPIv: parseDouble(jsonPalkaPIv),
         palkaPDobi: parseDouble(jsonPalkaPDobi),
         palkaPMni: parseDouble(jsonPalkaPMni),
       );

  factory AnalyticalResultIncomingMaterialByVesselDetailModel.fromJson(
    Map<String, dynamic> json,
  ) => _$AnalyticalResultIncomingMaterialByVesselDetailModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AnalyticalResultIncomingMaterialByVesselDetailModelToJson(this);
}
