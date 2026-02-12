// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_transfer_header_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormTransferHeaderModel _$FormTransferHeaderModelFromJson(
  Map<String, dynamic> json,
) => FormTransferHeaderModel(
  jsonId: json['id'] as String,
  jsonCompany: json['company'] as String?,
  jsonPlant: json['plant'] as String?,
  jsonTransactionDate: json['transaction_date'] as String?,
  jsonToDept: json['to_dept'] as String?,
  jsonFromDept: json['from_dept'] as String?,
  jsonFormNo: json['form_no'] as String?,
  jsonDateIssued: json['date_issued'] as String?,
  jsonRevisionNo: (json['revision_no'] as num?)?.toInt(),
  jsonRevisionDate: json['revision_date'] as String?,
  jsonFlag: json['flag'] as String?,
  jsonEntryBy: json['entry_by'] as String?,
  jsonEntryDate: json['entry_date'] as String?,
  jsonPreparedBy: json['prepared_by'] as String?,
  jsonPreparedDate: json['prepared_date'] as String?,
  jsonPreparedStatus: json['prepared_status'] as String?,
  jsonPreparedStatusRemarks: json['prepared_status_remarks'] as String?,
  jsonApprovedBy: json['approved_by'] as String?,
  jsonApprovedDate: json['approved_date'] as String?,
  jsonApprovedStatus: json['approved_status'] as String?,
  jsonApprovedStatusRemarks: json['approved_status_remarks'] as String?,
  jsonUpdatedBy: json['updated_by'] as String?,
  jsonUpdatedDate: json['updated_date'] as String?,
  jsonDeletedAt: json['deleted_at'] as String?,
  jsonDetail:
      (json['details'] as List<dynamic>?)
          ?.map(
            (e) => FormTransferDetailModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
);

Map<String, dynamic> _$FormTransferHeaderModelToJson(
  FormTransferHeaderModel instance,
) => <String, dynamic>{
  'id': instance.jsonId,
  'company': instance.jsonCompany,
  'plant': instance.jsonPlant,
  'transaction_date': instance.jsonTransactionDate,
  'to_dept': instance.jsonToDept,
  'from_dept': instance.jsonFromDept,
  'form_no': instance.jsonFormNo,
  'date_issued': instance.jsonDateIssued,
  'revision_no': instance.jsonRevisionNo,
  'revision_date': instance.jsonRevisionDate,
  'flag': instance.jsonFlag,
  'entry_by': instance.jsonEntryBy,
  'entry_date': instance.jsonEntryDate,
  'prepared_by': instance.jsonPreparedBy,
  'prepared_date': instance.jsonPreparedDate,
  'prepared_status': instance.jsonPreparedStatus,
  'prepared_status_remarks': instance.jsonPreparedStatusRemarks,
  'approved_by': instance.jsonApprovedBy,
  'approved_date': instance.jsonApprovedDate,
  'approved_status': instance.jsonApprovedStatus,
  'approved_status_remarks': instance.jsonApprovedStatusRemarks,
  'updated_by': instance.jsonUpdatedBy,
  'updated_date': instance.jsonUpdatedDate,
  'deleted_at': instance.jsonDeletedAt,
  'details': instance.jsonDetail?.map((e) => e.toJson()).toList(),
};
