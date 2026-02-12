import 'package:json_annotation/json_annotation.dart';
import 'form_transfer_detail_model.dart';

part 'form_transfer_header_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FormTransferHeaderModel {
  @JsonKey(name: 'id')
  final String jsonId;

  @JsonKey(name: 'company')
  final String? jsonCompany;

  @JsonKey(name: 'plant')
  final String? jsonPlant;

  @JsonKey(name: 'transaction_date')
  final String? jsonTransactionDate;

  @JsonKey(name: 'to_dept')
  final String? jsonToDept;

  @JsonKey(name: 'from_dept')
  final String? jsonFromDept;

  @JsonKey(name: 'form_no')
  final String? jsonFormNo;

  @JsonKey(name: 'date_issued')
  final String? jsonDateIssued;

  @JsonKey(name: 'revision_no')
  final int? jsonRevisionNo;

  @JsonKey(name: 'revision_date')
  final String? jsonRevisionDate;

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

  @JsonKey(name: 'approved_by')
  final String? jsonApprovedBy;

  @JsonKey(name: 'approved_date')
  final String? jsonApprovedDate;

  @JsonKey(name: 'approved_status')
  final String? jsonApprovedStatus;

  @JsonKey(name: 'approved_status_remarks')
  final String? jsonApprovedStatusRemarks;

  @JsonKey(name: 'updated_by')
  final String? jsonUpdatedBy;

  @JsonKey(name: 'updated_date')
  final String? jsonUpdatedDate;

  @JsonKey(name: 'deleted_at')
  final String? jsonDeletedAt;

  @JsonKey(name: 'details')
  final List<FormTransferDetailModel>? jsonDetail;

  FormTransferHeaderModel({
    required this.jsonId,
    this.jsonCompany,
    this.jsonPlant,
    this.jsonTransactionDate,
    this.jsonToDept,
    this.jsonFromDept,
    this.jsonFormNo,
    this.jsonDateIssued,
    this.jsonRevisionNo,
    this.jsonRevisionDate,
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
    this.jsonDeletedAt,
    this.jsonDetail,
  });

  factory FormTransferHeaderModel.fromJson(Map<String, dynamic> json) =>
      _$FormTransferHeaderModelFromJson(json);

  Map<String, dynamic> toJson() => _$FormTransferHeaderModelToJson(this);
}
