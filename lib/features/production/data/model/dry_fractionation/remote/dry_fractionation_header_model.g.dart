// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dry_fractionation_header_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DryFractionationHeaderModel _$DryFractionationHeaderModelFromJson(
  Map<String, dynamic> json,
) => DryFractionationHeaderModel(
  jsonId: json['id'] as String,
  jsonDate: json['date'] as String?,
  jsonPostingDate: json['posting_date'] as String?,
  jsonCompany: json['company'] as String?,
  jsonPlant: json['plant'] as String?,
  jsonCrystallizer: json['crystallizer'] as String?,
  jsonFeedOilIv: json['feed_oil_iv'] as String?,
  jsonFillingStartTime: json['filling_start_time'] as String?,
  jsonFillingEndTime: json['filling_end_time'] as String?,
  jsonInitialOilLevel: json['initial_oil_level'] as String?,
  jsonCoolingStartTemp: json['cooling_start_temp'] as String?,
  jsonCoolingStartTime: json['cooling_start_time'] as String?,
  jsonAgitatorSpeed: (json['agitator_speed'] as num?)?.toInt(),
  jsonWaterPumpPres: json['water_pump_pres'] as String?,
  jsonRemarks: json['remarks'] as String?,
  jsonFlag: json['flag'] as String?,
  jsonEntryBy: json['entry_by'] as String?,
  jsonEntryDate: json['entry_date'] as String?,
  jsonPreparedBy: json['prepared_by'] as String?,
  jsonPreparedDate: json['prepared_date'] as String?,
  jsonPreparedStatus: json['prepared_status'] as String?,
  jsonPreparedStatusRemarks: json['prepared_status_remarks'] as String?,
  jsonApprovedBy: json['checked_by'] as String?,
  jsonApprovedDate: json['checked_date'] as String?,
  jsonApprovedStatus: json['checked_status'] as String?,
  jsonApprovedStatusRemarks: json['checked_status_remarks'] as String?,
  jsonUpdatedBy: json['updated_by'] as String?,
  jsonUpdatedDate: json['updated_date'] as String?,
  jsonFormNo: json['form_no'] as String?,
  jsonDateIssued: json['date_issued'] as String?,
  jsonRevisionNo: (json['revision_no'] as num?)?.toInt(),
  jsonRevisionDate: json['revision_date'] as String?,
  jsonDetails:
      (json['details'] as List<dynamic>?)
          ?.map(
            (e) =>
                DryFractionationDetailModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
  jsonIsCompleted: (json['is_completed'] as num?)?.toInt(),
);

Map<String, dynamic> _$DryFractionationHeaderModelToJson(
  DryFractionationHeaderModel instance,
) => <String, dynamic>{
  'id': instance.jsonId,
  'date': instance.jsonDate,
  'posting_date': instance.jsonPostingDate,
  'company': instance.jsonCompany,
  'plant': instance.jsonPlant,
  'crystallizer': instance.jsonCrystallizer,
  'feed_oil_iv': instance.jsonFeedOilIv,
  'filling_start_time': instance.jsonFillingStartTime,
  'filling_end_time': instance.jsonFillingEndTime,
  'initial_oil_level': instance.jsonInitialOilLevel,
  'cooling_start_temp': instance.jsonCoolingStartTemp,
  'cooling_start_time': instance.jsonCoolingStartTime,
  'agitator_speed': instance.jsonAgitatorSpeed,
  'water_pump_pres': instance.jsonWaterPumpPres,
  'remarks': instance.jsonRemarks,
  'flag': instance.jsonFlag,
  'entry_by': instance.jsonEntryBy,
  'entry_date': instance.jsonEntryDate,
  'prepared_by': instance.jsonPreparedBy,
  'prepared_date': instance.jsonPreparedDate,
  'prepared_status': instance.jsonPreparedStatus,
  'prepared_status_remarks': instance.jsonPreparedStatusRemarks,
  'checked_by': instance.jsonApprovedBy,
  'checked_date': instance.jsonApprovedDate,
  'checked_status': instance.jsonApprovedStatus,
  'checked_status_remarks': instance.jsonApprovedStatusRemarks,
  'updated_by': instance.jsonUpdatedBy,
  'updated_date': instance.jsonUpdatedDate,
  'form_no': instance.jsonFormNo,
  'date_issued': instance.jsonDateIssued,
  'revision_no': instance.jsonRevisionNo,
  'revision_date': instance.jsonRevisionDate,
  'is_completed': instance.jsonIsCompleted,
  'details': instance.jsonDetails?.map((e) => e.toJson()).toList(),
};
