import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_outgoing_shipment_product_by_vessel/analytical_result_outgoing_shipment_product_by_vessel_detail_entity.dart';
part 'analytical_result_outgoing_shipment_product_by_vessel_detail_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AnalyticalResultOutgoingShipmentProductByVesselDetailModel
    extends AnalyticalResultOutgoingShipmentProductByVesselDetailEntity {
  @JsonKey(name: 'id')
  final String jsonId;

  @JsonKey(name: 'id_hdr')
  final String jsonIdHdr;

  @JsonKey(name: 'palka_s_palka')
  final int? jsonPalkaSPalka;

  @JsonKey(name: 'palka_s_ffa')
  final String? jsonPalkaSFfa;

  @JsonKey(name: 'palka_s_iv')
  final String? jsonPalkaSIv;

  @JsonKey(name: 'palka_s_colour')
  final String? jsonPalkaSColour;

  @JsonKey(name: 'palka_s_pv')
  final String? jsonPalkaSPv;

  @JsonKey(name: 'palka_s_mni')
  final String? jsonPalkaSMni;

  @JsonKey(name: 'palka_p_palka')
  final int? jsonPalkaPPalka;

  @JsonKey(name: 'palka_p_ffa')
  final String? jsonPalkaPFfa;

  @JsonKey(name: 'palka_p_iv')
  final String? jsonPalkaPIv;

  @JsonKey(name: 'palka_p_colour')
  final String? jsonPalkaPColour;

  @JsonKey(name: 'palka_p_pv')
  final String? jsonPalkaPPv;

  @JsonKey(name: 'palka_p_mni')
  final String? jsonPalkaPMni;

  @JsonKey(name: 'deleted_at')
  final String? jsonDeletedAt;

  AnalyticalResultOutgoingShipmentProductByVesselDetailModel({
    required this.jsonId,
    required this.jsonIdHdr,
    this.jsonPalkaSPalka,
    this.jsonPalkaSFfa,
    this.jsonPalkaSIv,
    this.jsonPalkaSColour,
    this.jsonPalkaSPv,
    this.jsonPalkaSMni,
    this.jsonPalkaPPalka,
    this.jsonPalkaPFfa,
    this.jsonPalkaPIv,
    this.jsonPalkaPColour,
    this.jsonPalkaPPv,
    this.jsonPalkaPMni,
    this.jsonDeletedAt,
  }) : super(
         id: jsonId,
         idHdr: jsonIdHdr,
         palkaSPalka: parseInt(jsonPalkaSPalka),
         palkaSFfa: parseDouble(jsonPalkaSFfa),
         palkaSIv: parseDouble(jsonPalkaSIv),
         palkaSColour: parseDouble(jsonPalkaSColour),
         palkaSPv: parseDouble(jsonPalkaSPv),
         palkaSMni: parseDouble(jsonPalkaSMni),
         palkaPPalka: parseInt(jsonPalkaPPalka),
         palkaPFfa: parseDouble(jsonPalkaPFfa),
         palkaPIv: parseDouble(jsonPalkaPIv),
         palkaPColour: parseDouble(jsonPalkaPColour),
         palkaPPv: parseDouble(jsonPalkaPPv),
         palkaPMni: parseDouble(jsonPalkaPMni),
       );

  factory AnalyticalResultOutgoingShipmentProductByVesselDetailModel.fromJson(
    Map<String, dynamic> json,
  ) => _$AnalyticalResultOutgoingShipmentProductByVesselDetailModelFromJson(
    json,
  );

  Map<String, dynamic> toJson() =>
      _$AnalyticalResultOutgoingShipmentProductByVesselDetailModelToJson(this);
}
