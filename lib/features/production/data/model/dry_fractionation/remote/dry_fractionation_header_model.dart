import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/production/data/model/dry_fractionation/local/dry_fractionation_header_entity.dart';
import 'dry_fractionation_detail_model.dart';

part 'dry_fractionation_header_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DryFractionationHeaderModel extends DryFractionationHeaderEntity {
  @JsonKey(name: 'id')
  final String jsonId;

  @JsonKey(name: 'date')
  final String? jsonDate;

  @JsonKey(name: 'posting_date')
  final String? jsonPostingDate;

  @JsonKey(name: 'company')
  final String? jsonCompany;

  @JsonKey(name: 'plant')
  final String? jsonPlant;

  @JsonKey(name: 'crystallizer')
  final String? jsonCrystallizer;

  @JsonKey(name: 'feed_oil_iv')
  final String? jsonFeedOilIv;

  @JsonKey(name: 'filling_start_time')
  final String? jsonFillingStartTime;

  @JsonKey(name: 'filling_end_time')
  final String? jsonFillingEndTime;

  @JsonKey(name: 'initial_oil_level')
  final String? jsonInitialOilLevel;

  @JsonKey(name: 'cooling_start_temp')
  final String? jsonCoolingStartTemp;

  @JsonKey(name: 'cooling_start_time')
  final String? jsonCoolingStartTime;

  @JsonKey(name: 'agitator_speed')
  final int? jsonAgitatorSpeed;

  @JsonKey(name: 'water_pump_pres')
  final String? jsonWaterPumpPres;

  @JsonKey(name: 'remarks')
  final String? jsonRemarks;

  @JsonKey(name: 'flag')
  final String? jsonFlag;

  @JsonKey(name: 'entry_by')
  final String? jsonEntryBy;

  @JsonKey(name: 'entry_date')
  final String? jsonEntryDate;

  @JsonKey(name: 'prepared_by')
  final String? jsonPreparedBy;

  @JsonKey(name: 'prepared_date')
  final String? jsonPreparedDate;

  @JsonKey(name: 'prepared_status')
  final String? jsonPreparedStatus;

  @JsonKey(name: 'prepared_status_remarks')
  final String? jsonPreparedStatusRemarks;

  @JsonKey(name: 'checked_by')
  final String? jsonApprovedBy;

  @JsonKey(name: 'checked_date')
  final String? jsonApprovedDate;

  @JsonKey(name: 'checked_status')
  final String? jsonApprovedStatus;

  @JsonKey(name: 'checked_status_remarks')
  final String? jsonApprovedStatusRemarks;

  @JsonKey(name: 'updated_by')
  final String? jsonUpdatedBy;

  @JsonKey(name: 'updated_date')
  final String? jsonUpdatedDate;

  @JsonKey(name: 'form_no')
  final String? jsonFormNo;

  @JsonKey(name: 'date_issued')
  final String? jsonDateIssued;

  @JsonKey(name: 'revision_no')
  final int? jsonRevisionNo;

  @JsonKey(name: 'revision_date')
  final String? jsonRevisionDate;

  @JsonKey(name: 'is_completed')
  final int? jsonIsCompleted;

  @JsonKey(name: 'details')
  final List<DryFractionationDetailModel>? jsonDetails;

  DryFractionationHeaderModel({
    required this.jsonId,
    this.jsonDate,
    this.jsonPostingDate,
    this.jsonCompany,
    this.jsonPlant,
    this.jsonCrystallizer,
    this.jsonFeedOilIv,
    this.jsonFillingStartTime,
    this.jsonFillingEndTime,
    this.jsonInitialOilLevel,
    this.jsonCoolingStartTemp,
    this.jsonCoolingStartTime,
    this.jsonAgitatorSpeed,
    this.jsonWaterPumpPres,
    this.jsonRemarks,
    this.jsonFlag,
    this.jsonEntryBy,
    this.jsonEntryDate,
    this.jsonPreparedBy,
    this.jsonPreparedDate,
    this.jsonPreparedStatus,
    this.jsonPreparedStatusRemarks,
    this.jsonApprovedBy,
    this.jsonApprovedDate,
    this.jsonApprovedStatus,
    this.jsonApprovedStatusRemarks,
    this.jsonUpdatedBy,
    this.jsonUpdatedDate,
    this.jsonFormNo,
    this.jsonDateIssued,
    this.jsonRevisionNo,
    this.jsonRevisionDate,
    this.jsonDetails,
    this.jsonIsCompleted,
  }) : super(
         id: jsonId,
         date:
             jsonDate != null
                 ? formatStringtoDate(jsonDate ?? '', 'yyyy-MM-dd HH:mm:ss')
                 : null,
         postingDate:
             jsonPostingDate != null
                 ? formatStringtoDate(
                   jsonPostingDate ?? '',
                   'yyyy-MM-dd HH:mm:ss',
                 )
                 : null,
         company: jsonCompany,
         plant: jsonPlant,
         crystallizer: jsonCrystallizer,
         feedOilIv: parseDouble(jsonFeedOilIv),
         fillingStartTime: parseTimeOfDay(jsonFillingStartTime),
         fillingEndTime: parseTimeOfDay(jsonFillingEndTime),
         initialOilLevel: parseDouble(jsonInitialOilLevel),
         coolingStartTemp: parseDouble(jsonCoolingStartTemp),
         coolingStartTime: parseTimeOfDay(jsonCoolingStartTime),
         agitatorSpeed: jsonAgitatorSpeed,
         waterPumpPres: parseDouble(jsonWaterPumpPres),
         remarks: jsonRemarks,
         flag: jsonFlag,
         entryBy: jsonEntryBy,
         entryDate:
             jsonEntryDate != null
                 ? formatStringtoDate(
                   jsonEntryDate ?? '',
                   'yyyy-MM-dd HH:mm:ss',
                 )
                 : null,
         preparedBy: jsonPreparedBy,
         preparedDate:
             jsonPreparedDate != null
                 ? formatStringtoDate(
                   jsonPreparedDate ?? '',
                   'yyyy-MM-dd HH:mm:ss',
                 )
                 : null,
         preparedStatus: jsonPreparedStatus,
         preparedStatusRemarks: jsonPreparedStatusRemarks,
         approvedBy: jsonApprovedBy,
         approvedDate:
             jsonApprovedDate != null
                 ? formatStringtoDate(
                   jsonApprovedDate ?? '',
                   'yyyy-MM-dd HH:mm:ss',
                 )
                 : null,
         approvedStatus: jsonApprovedStatus,
         approvedStatusRemarks: jsonApprovedStatusRemarks,
         updatedBy: jsonUpdatedBy,
         updatedDate:
             jsonUpdatedDate != null
                 ? formatStringtoDate(
                   jsonUpdatedDate ?? '',
                   'yyyy-MM-dd HH:mm:ss',
                 )
                 : null,
         formNo: jsonFormNo,
         dateIssued:
             jsonDateIssued != null
                 ? formatStringtoDate(
                   jsonDateIssued ?? '',
                   'yyyy-MM-dd HH:mm:ss',
                 )
                 : null,
         revisionNo: jsonRevisionNo?.toString(),
         revisionDate:
             jsonRevisionDate != null
                 ? formatStringtoDate(
                   jsonRevisionDate ?? '',
                   'yyyy-MM-dd HH:mm:ss',
                 )
                 : null,
         isCompleted:
             jsonIsCompleted == null
                 ? null
                 : (jsonIsCompleted == 1 ? true : false),
         details: jsonDetails ?? [],
       );

  factory DryFractionationHeaderModel.fromJson(Map<String, dynamic> json) =>
      _$DryFractionationHeaderModelFromJson(json);

  Map<String, dynamic> toJson() => _$DryFractionationHeaderModelToJson(this);
}
