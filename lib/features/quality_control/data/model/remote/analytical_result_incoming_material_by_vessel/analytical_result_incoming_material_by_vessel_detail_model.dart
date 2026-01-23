import 'package:json_annotation/json_annotation.dart';
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
  final num? jsonPalkaSNo;

  @JsonKey(name: 'palka_c_no')
  final num? jsonPalkaCNo;

  @JsonKey(name: 'palka_p_no')
  final num? jsonPalkaPNo;

  // Case 2: JSON berupa num/angka (perlu di-cast ke double)
  @JsonKey(name: 'palka_s_ffa')
  final num? jsonPalkaSFfa;
  @JsonKey(name: 'palka_s_iv')
  final num? jsonPalkaSIv;
  @JsonKey(name: 'palka_s_dobi')
  final num? jsonPalkaSDobi;
  @JsonKey(name: 'palka_s_mni')
  final num? jsonPalkaSMni;

  @JsonKey(name: 'palka_c_ffa')
  final num? jsonPalkaCFfa;
  @JsonKey(name: 'palka_c_iv')
  final num? jsonPalkaCIv;
  @JsonKey(name: 'palka_c_dobi')
  final num? jsonPalkaCDobi;
  @JsonKey(name: 'palka_c_mni')
  final num? jsonPalkaCMni;

  @JsonKey(name: 'palka_p_ffa')
  final num? jsonPalkaPFfa;
  @JsonKey(name: 'palka_p_iv')
  final num? jsonPalkaPIv;
  @JsonKey(name: 'palka_p_dobi')
  final num? jsonPalkaPDobi;
  @JsonKey(name: 'palka_p_mni')
  final num? jsonPalkaPMni;

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
          palkaSNo: jsonPalkaSNo?.toInt(),
          palkaCNo: jsonPalkaCNo?.toInt(),
          palkaPNo: jsonPalkaPNo?.toInt(),

          // 2. Konversi Num -> Double
          // .toDouble() aman digunakan pada tipe 'num'
          palkaSFfa: jsonPalkaSFfa?.toDouble(),
          palkaSIv: jsonPalkaSIv?.toDouble(),
          palkaSDobi: jsonPalkaSDobi?.toDouble(),
          palkaSMni: jsonPalkaSMni?.toDouble(),
          
          palkaCFfa: jsonPalkaCFfa?.toDouble(),
          palkaCIv: jsonPalkaCIv?.toDouble(),
          palkaCDobi: jsonPalkaCDobi?.toDouble(),
          palkaCMni: jsonPalkaCMni?.toDouble(),

          palkaPFfa: jsonPalkaPFfa?.toDouble(),
          palkaPIv: jsonPalkaPIv?.toDouble(),
          palkaPDobi: jsonPalkaPDobi?.toDouble(),
          palkaPMni: jsonPalkaPMni?.toDouble(),
        );

  factory AnalyticalResultIncomingMaterialByVesselDetailModel.fromJson(
    Map<String, dynamic> json,
  ) => _$AnalyticalResultIncomingMaterialByVesselDetailModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AnalyticalResultIncomingMaterialByVesselDetailModelToJson(this);
}
