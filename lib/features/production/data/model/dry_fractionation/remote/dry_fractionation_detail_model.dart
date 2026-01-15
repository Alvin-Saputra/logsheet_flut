import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/production/data/model/dry_fractionation/local/dry_fractionation_detail_entity.dart';

part 'dry_fractionation_detail_model.g.dart';

@JsonSerializable()
class DryFractionationDetailModel extends DryFractionationDetailEntity {
  @JsonKey(name: 'id')
  final String jsonId;

  @JsonKey(name: 'id_hdr')
  final String jsonIdHdr;

  @JsonKey(name: 'filtration_cycle_number')
  final int jsonFiltrationCycleNumber;

  @JsonKey(name: 'filtration_date')
  final String? jsonFiltrationDate;

  @JsonKey(name: 'filtration_temp')
  final String? jsonFiltrationTemp;

  @JsonKey(name: 'time_start_filtration')
  final String? jsonTimeStartFiltration;

  @JsonKey(name: 'time_end_filtration')
  final String? jsonTimeEndFiltration;

  @JsonKey(name: 'load')
  final String? jsonLoad;

  // ===== OLEIN =====
  @JsonKey(name: 'olein_iv')
  final String? jsonOleinIv;

  @JsonKey(name: 'olein_cp')
  final String? jsonOleinCp;

  @JsonKey(name: 'olein_ffa')
  final String? jsonOleinFfa;

  @JsonKey(name: 'olein_color_red')
  final String? jsonOleinColorRed;

  // ===== STEARIN =====
  @JsonKey(name: 'stearin_iv')
  final String? jsonStearinIv;

  @JsonKey(name: 'stearin_ffa')
  final String? jsonStearinFfa;

  @JsonKey(name: 'stearin_color_red')
  final String? jsonStearinColorRed;

  @JsonKey(name: 'stearin_pv')
  final String? jsonStearinPv;

  DryFractionationDetailModel({
    required this.jsonId,
    required this.jsonIdHdr,
    required this.jsonFiltrationCycleNumber,
    this.jsonFiltrationDate,
    this.jsonFiltrationTemp,
    this.jsonTimeStartFiltration,
    this.jsonTimeEndFiltration,
    this.jsonLoad,
    this.jsonOleinIv,
    this.jsonOleinCp,
    this.jsonOleinFfa,
    this.jsonOleinColorRed,
    this.jsonStearinIv,
    this.jsonStearinFfa,
    this.jsonStearinColorRed,
    this.jsonStearinPv,
  }) : super(
         id: jsonId,
         idHdr: jsonIdHdr,
         filtrationCycleNumber: jsonFiltrationCycleNumber,
         filtrationDate:
             jsonFiltrationDate != null
                 ? formatStringtoDate(
                   jsonFiltrationDate ?? '',
                   'yyyy-MM-dd HH:mm:ss',
                 )
                 : null,
         filtrationTemp: parseDouble(jsonFiltrationTemp),
         timeStartFiltration: parseTimeOfDay(jsonTimeStartFiltration),
         timeEndFiltration: parseTimeOfDay(jsonTimeEndFiltration),
         load: parseDouble(jsonLoad),

         // OLEIN
         oleinIv: parseDouble(jsonOleinIv),
         oleinCp: parseDouble(jsonOleinCp),
         oleinFfa: parseDouble(jsonOleinFfa),
         oleinColorRed: parseDouble(jsonOleinColorRed),

         // STEARIN
         stearinIv: parseDouble(jsonStearinIv),
         stearinFfa: parseDouble(jsonStearinFfa),
         stearinColorRed: parseDouble(jsonStearinColorRed),
         stearinPv: parseDouble(jsonStearinPv),
       );

  factory DryFractionationDetailModel.fromJson(Map<String, dynamic> json) =>
      _$DryFractionationDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$DryFractionationDetailModelToJson(this);
}
