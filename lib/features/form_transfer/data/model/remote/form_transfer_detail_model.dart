import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';

part 'form_transfer_detail_model.g.dart';

@JsonSerializable()
class FormTransferDetailModel {
  @JsonKey(name: 'id')
  final String jsonId;

  @JsonKey(name: 'id_hdr')
  final String jsonIdHdr;

  @JsonKey(name: 'oil_type')
  final String? jsonOilType;

  @JsonKey(name: 'quantity')
  final String? jsonQuantity;

  @JsonKey(name: 'from_storage_tank_no')
  final String? jsonFromStorageTankNo;

  @JsonKey(name: 'from_refinery_fractionation')
  final String? jsonFromRefineryFractionation;

  @JsonKey(name: 'from_other')
  final String? jsonFromOther;

  @JsonKey(name: 'to_storage_tank_no')
  final String? jsonToStorageTankNo;

  @JsonKey(name: 'to_refinery_fractionation')
  final String? jsonToRefineryFractionation;

  @JsonKey(name: 'to_auto_filling_tank', fromJson: parseInt)
  final int? jsonToAutoFillingTank;

  @JsonKey(name: 'to_other')
  final String? jsonToOther;

  @JsonKey(name: 'quality_m_and_i', fromJson: parseDouble)
  final num? jsonQualityMAndI;

  @JsonKey(name: 'quality_ffa', fromJson: parseDouble)
  final num? jsonQualityFfa;

  @JsonKey(name: 'quality_lov_color_r', fromJson: parseDouble)
  final num? jsonQualityLovColorR;

  @JsonKey(name: 'quality_lov_color_y', fromJson: parseDouble)
  final num? jsonQualityLovColorY;

  @JsonKey(name: 'quality_cp_temp', fromJson: parseDouble)
  final num? jsonQualityCpTemp;

  @JsonKey(name: 'quality_smp', fromJson: parseDouble)
  final num? jsonQualitySmp;

  @JsonKey(name: 'quality_pv', fromJson: parseDouble)
  final num? jsonQualityPv;

  @JsonKey(name: 'quality_iv', fromJson: parseDouble)
  final num? jsonQualityIv;

  @JsonKey(name: 'remark')
  final String? jsonRemark;

  @JsonKey(name: 'deleted_at')
  final String? jsonDeletedAt;

  FormTransferDetailModel({
    required this.jsonId,
    required this.jsonIdHdr,
    this.jsonOilType,
    this.jsonQuantity,
    this.jsonFromStorageTankNo,
    this.jsonFromRefineryFractionation,
    this.jsonFromOther,
    this.jsonToStorageTankNo,
    this.jsonToRefineryFractionation,
    this.jsonToAutoFillingTank,
    this.jsonToOther,
    this.jsonQualityMAndI,
    this.jsonQualityFfa,
    this.jsonQualityLovColorR,
    this.jsonQualityLovColorY,
    this.jsonQualityCpTemp,
    this.jsonQualitySmp,
    this.jsonQualityPv,
    this.jsonQualityIv,
    this.jsonRemark,
    this.jsonDeletedAt,
  });

  factory FormTransferDetailModel.fromJson(Map<String, dynamic> json) =>
      _$FormTransferDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$FormTransferDetailModelToJson(this);
}
