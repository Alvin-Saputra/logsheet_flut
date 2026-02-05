// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dry_fractionation_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DryFractionationDetailModel _$DryFractionationDetailModelFromJson(
  Map<String, dynamic> json,
) => DryFractionationDetailModel(
  jsonId: json['id'] as String,
  jsonIdHdr: json['id_hdr'] as String,
  jsonFiltrationCycleNumber: (json['filtration_cycle_number'] as num).toInt(),
  jsonFiltrationDate: json['filtration_date'] as String?,
  jsonFiltrationTemp: json['filtration_temp'] as String?,
  jsonTimeStartFiltration: json['time_start_filtration'] as String?,
  jsonTimeEndFiltration: json['time_end_filtration'] as String?,
  jsonLoad: json['load'] as String?,
  jsonOleinIv: json['olein_iv'] as String?,
  jsonOleinCp: json['olein_cp'] as String?,
  jsonOleinFfa: json['olein_ffa'] as String?,
  jsonOleinColorRed: json['olein_color_red'] as String?,
  jsonStearinIv: json['stearin_iv'] as String?,
  jsonStearinFfa: json['stearin_ffa'] as String?,
  jsonStearinColorRed: json['stearin_color_red'] as String?,
  jsonStearinPv: json['stearin_pv'] as String?,
);

Map<String, dynamic> _$DryFractionationDetailModelToJson(
  DryFractionationDetailModel instance,
) => <String, dynamic>{
  'id': instance.jsonId,
  'id_hdr': instance.jsonIdHdr,
  'filtration_cycle_number': instance.jsonFiltrationCycleNumber,
  'filtration_date': instance.jsonFiltrationDate,
  'filtration_temp': instance.jsonFiltrationTemp,
  'time_start_filtration': instance.jsonTimeStartFiltration,
  'time_end_filtration': instance.jsonTimeEndFiltration,
  'load': instance.jsonLoad,
  'olein_iv': instance.jsonOleinIv,
  'olein_cp': instance.jsonOleinCp,
  'olein_ffa': instance.jsonOleinFfa,
  'olein_color_red': instance.jsonOleinColorRed,
  'stearin_iv': instance.jsonStearinIv,
  'stearin_ffa': instance.jsonStearinFfa,
  'stearin_color_red': instance.jsonStearinColorRed,
  'stearin_pv': instance.jsonStearinPv,
};
