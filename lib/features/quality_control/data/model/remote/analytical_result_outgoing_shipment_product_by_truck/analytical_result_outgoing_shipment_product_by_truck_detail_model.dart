import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_outgoing_shipment_product_by_truck/analytical_result_outgoing_shipment_product_by_truck_detail_entity.dart';

part 'analytical_result_outgoing_shipment_product_by_truck_detail_model.g.dart';

@JsonSerializable()
class AnalyticalResultOutgoingShipmentProductByTruckDetailModel
    extends AnalyticalResultOutgoingShipmentProductByTruckDetailEntity {
  @JsonKey(name: 'id')
  final String jsonId;

  @JsonKey(name: 'id_hdr')
  final String jsonIdHdr;

  @JsonKey(name: 'ships_tank')
  final String? jsonShipsTank;

  @JsonKey(name: 'no_police')
  final String? jsonPoliceNo;

  // --- PERBAIKAN DI SINI (Ubah num? jadi String?) ---
  
  @JsonKey(name: 'ffa')
  final String? jsonFfa; // API mengirim String "0.0000"

  @JsonKey(name: 'm_and_i')
  final String? jsonMni; // API mengirim String "0.0000"

  @JsonKey(name: 'iv')
  final String? jsonIv; // API mengirim String "0.0000"

  @JsonKey(name: 'lovibond_color_red')
  final String? jsonLovibondColorRed; // API mengirim String "0.0000"

  @JsonKey(name: 'lovibond_color_yellow')
  final String? jsonLovibondColorYellow; // API mengirim String "0.0000"

  @JsonKey(name: 'pv')
  final String? jsonPv; // API mengirim String "0.0000"

  // --------------------------------------------------

  @JsonKey(name: 'other')
  final String? jsonOther;

  @JsonKey(name: 'remark')
  final String? jsonRemark;

  AnalyticalResultOutgoingShipmentProductByTruckDetailModel({
    required this.jsonId,
    required this.jsonIdHdr,
    this.jsonShipsTank,
    this.jsonPoliceNo,
    this.jsonFfa,
    this.jsonMni,
    this.jsonIv,
    this.jsonLovibondColorRed,
    this.jsonLovibondColorYellow,
    this.jsonPv,
    this.jsonOther,
    this.jsonRemark,
  }) : super(
          id: jsonId,
          idHdr: jsonIdHdr,
          shipsTank: jsonShipsTank,
          noPolice: jsonPoliceNo,
          // parseDouble biasanya aman menerima String maupun num
          ffa: parseDouble(jsonFfa), 
          mni: parseDouble(jsonMni),
          iv: parseDouble(jsonIv),
          lovibondColorRed: parseDouble(jsonLovibondColorRed),
          lovibondColorYellow: parseDouble(jsonLovibondColorYellow),
          pv: parseDouble(jsonPv),
          other: jsonOther,
          remark: jsonRemark,
        );

  factory AnalyticalResultOutgoingShipmentProductByTruckDetailModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$AnalyticalResultOutgoingShipmentProductByTruckDetailModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AnalyticalResultOutgoingShipmentProductByTruckDetailModelToJson(this);
}