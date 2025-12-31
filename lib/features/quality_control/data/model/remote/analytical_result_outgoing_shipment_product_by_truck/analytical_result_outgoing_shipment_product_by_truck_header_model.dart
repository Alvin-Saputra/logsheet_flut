import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_outgoing_shipment_product_by_truck/analytical_result_outgoing_shipment_product_by_truck_header_entity.dart';
import 'analytical_result_outgoing_shipment_product_by_truck_detail_model.dart';

part 'analytical_result_outgoing_shipment_product_by_truck_header_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AnalyticalResultOutgoingShipmentProductByTruckHeaderModel
    extends AnalyticalResultOutgoingShipmentProductByTruckHeaderEntity {
  @JsonKey(name: 'id')
  final String jsonId;

  @JsonKey(name: 'loading_date')
  final String? jsonLoadingDate;

  @JsonKey(name: 'product_name')
  final String? jsonProductName;

  @JsonKey(name: 'quantity')
  final String? jsonQuantity;

  @JsonKey(name: 'ships_name')
  final String? jsonShipsName;

  @JsonKey(name: 'destination')
  final String? jsonDestination;

  @JsonKey(name: 'load_port')
  final String? jsonLoadPort;

  @JsonKey(name: 'entry_by')
  final String? jsonEntryBy;

  @JsonKey(name: 'entry_date')
  final String? jsonEntryDate;

  @JsonKey(name: 'corrected_by')
  final String? jsonCorrectedBy;

  @JsonKey(name: 'corrected_date')
  final String? jsonCorrectedDate;

  @JsonKey(name: 'corrected_status')
  final String? jsonCorrectedStatus;

  @JsonKey(name: 'corrected_status_remarks')
  final String? jsonCorrectedStatusRemarks;

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

  @JsonKey(name: 'form_no')
  final String? jsonFormNo;

  @JsonKey(name: 'date_issued')
  final String? jsonDateIssued;

  @JsonKey(name: 'revision_no')
  final int? jsonRevisionNo;

  @JsonKey(name: 'revision_date')
  final String? jsonRevisionDate;

  // List Detail (Model)
  @JsonKey(name: 'details')
  final List<AnalyticalResultOutgoingShipmentProductByTruckDetailModel>? jsonDetail;

  AnalyticalResultOutgoingShipmentProductByTruckHeaderModel({
    // this.jsonDetail,
    required this.jsonId,
    this.jsonLoadingDate,
    this.jsonProductName,
    this.jsonQuantity,
    this.jsonShipsName,
    this.jsonDestination,
    this.jsonLoadPort,
    this.jsonEntryBy,
    this.jsonEntryDate,
    this.jsonCorrectedBy,
    this.jsonCorrectedDate,
    this.jsonCorrectedStatus,
    this.jsonCorrectedStatusRemarks,
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
    this.jsonDetail,
  }) : super(
    id: jsonId,
    loadingDate: formatStringtoDate(jsonLoadingDate ?? '', 'yyyy-MM-dd'),
    productName: jsonProductName,
    quantity: parseDouble(jsonQuantity),
    shipsName: jsonShipsName,
    destination: jsonDestination,
    loadPort: jsonLoadPort,
    entryBy: jsonEntryBy,
    entryDate: formatStringtoDate(jsonEntryDate ?? '', 'yyyy-MM-dd'),
    correctedBy: jsonCorrectedBy,
    correctedDate: formatStringtoDate(jsonCorrectedDate ?? '', 'yyyy-MM-dd'),
    correctedStatus: jsonCorrectedStatus,
    correctedStatusRemarks: jsonCorrectedStatusRemarks,
    approvedBy: jsonApprovedBy,
    approvedDate:  formatStringtoDate(jsonApprovedDate ?? '', 'yyyy-MM-dd'),
    approvedStatus: jsonApprovedStatus,
    approvedStatusRemarks: jsonApprovedStatusRemarks,
    updatedBy: jsonUpdatedBy,
    updatedDate:  formatStringtoDate(jsonUpdatedDate?? '', 'yyyy-MM-dd'),
    formNo: jsonFormNo,
    dateIssued:  formatStringtoDate(jsonDateIssued?? '', 'yyyy-MM-dd'),
    revisionNo: jsonRevisionNo.toString(),
    revisionDate:  formatStringtoDate(jsonRevisionDate ?? '', 'yyyy-MM-dd'),
    details: jsonDetail??[],
  );

  factory AnalyticalResultOutgoingShipmentProductByTruckHeaderModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$AnalyticalResultOutgoingShipmentProductByTruckHeaderModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AnalyticalResultOutgoingShipmentProductByTruckHeaderModelToJson(this);
}
