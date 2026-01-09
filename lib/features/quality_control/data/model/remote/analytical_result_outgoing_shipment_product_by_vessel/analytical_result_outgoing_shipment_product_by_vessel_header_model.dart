import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_outgoing_shipment_product_by_vessel/analytical_result_outgoing_shipment_product_by_vessel_header_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_outgoing_shipment_product_by_vessel/analytical_result_outgoing_shipment_product_by_vessel_detail_model.dart';
part 'analytical_result_outgoing_shipment_product_by_vessel_header_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AnalyticalResultOutgoingShipmentProductByVesselHeaderModel
    extends AnalyticalResultOutgoingShipmentProductByVesselHeaderEntity {
  @JsonKey(name: 'id')
  final String jsonId;

  @JsonKey(name: 'company')
  final String? jsonCompany;

  @JsonKey(name: 'plant')
  final String? jsonPlant;

  @JsonKey(name: 'product_name')
  final String? jsonProductName;

  @JsonKey(name: 'sampling_date')
  final String? jsonSamplingDate;

  @JsonKey(name: 'quantity')
  final String? jsonQuantity;

  @JsonKey(name: 'shipper')
  final String? jsonShipper;

  @JsonKey(name: 'destination')
  final String? jsonDestination;

  @JsonKey(name: 'vessel_name')
  final String? jsonVesselName;

  @JsonKey(name: 'hasil_analisa_ffa')
  final String? jsonHasilAnalisaFfa;

  @JsonKey(name: 'hasil_analisa_iv')
  final String? jsonHasilAnalisaIv;

  @JsonKey(name: 'hasil_analisa_moisture')
  final String? jsonHasilAnalisaMoisture;

  @JsonKey(name: 'hasil_analisa_colour')
  final String? jsonHasilAnalisaColour;

  @JsonKey(name: 'hasil_analisa_pv')
  final String? jsonHasilAnalisaPv;

  @JsonKey(name: 'hasil_analisa_smp')
  final String? jsonHasilAnalisaSmp;

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

  @JsonKey(name: 'form_no')
  final String? jsonFormNo;

  @JsonKey(name: 'date_issued')
  final String? jsonDateIssued;

  @JsonKey(name: 'revision_no')
  final int? jsonRevisionNo;

  @JsonKey(name: 'revision_date')
  final String? jsonRevisionDate;

  // List Detail (Model)
  @JsonKey(name: 'detail')
  final List<AnalyticalResultOutgoingShipmentProductByVesselDetailModel>? jsonDetail;

  AnalyticalResultOutgoingShipmentProductByVesselHeaderModel({
    required this.jsonId,
    required this.jsonCompany,
    required this.jsonPlant,
    this.jsonProductName,
    this.jsonSamplingDate,
    this.jsonQuantity,
    this.jsonShipper,
    this.jsonDestination,
    this.jsonVesselName,
    this.jsonHasilAnalisaFfa,
    this.jsonHasilAnalisaIv,
    this.jsonHasilAnalisaMoisture,
    this.jsonHasilAnalisaColour,
    this.jsonHasilAnalisaPv,
    this.jsonHasilAnalisaSmp,
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
    this.jsonDetail,
  }) : super(
         id: jsonId,
         company: jsonCompany ?? '',
         plant: jsonPlant ?? '',
         productName: jsonProductName,
         samplingDate: formatStringtoDate(jsonSamplingDate ?? '', 'yyyy-MM-dd'),
         quantity: parseDouble(jsonQuantity),
         shipper: jsonShipper,
         destination: jsonDestination,
         vesselName: jsonVesselName,
         hasilAnalisaFfa: parseDouble(jsonHasilAnalisaFfa),
         hasilAnalisaIv: parseDouble(jsonHasilAnalisaIv),
         hasilAnalisaMoisture: parseDouble(jsonHasilAnalisaMoisture),
         hasilAnalisaColorR: parseDouble(jsonHasilAnalisaColour),
         hasilAnalisaPv: parseDouble(jsonHasilAnalisaPv),
         hasilAnalisaSMP: parseDouble(jsonHasilAnalisaSmp),
         entryBy: jsonEntryBy,
         entryDate: formatStringtoDate(jsonEntryDate ?? '', 'yyyy-MM-dd'),
         preparedBy: jsonPreparedBy,
         preparedDate: formatStringtoDate(jsonPreparedDate ?? '', 'yyyy-MM-dd'),
         preparedStatus: jsonPreparedStatus,
         preparedStatusRemarks: jsonPreparedStatusRemarks,
         approvedBy: jsonApprovedBy,
         approvedDate: formatStringtoDate(jsonApprovedDate ?? '', 'yyyy-MM-dd'),
         approvedStatus: jsonApprovedStatus,
         approvedStatusRemarks: jsonApprovedStatusRemarks,
         updatedBy: jsonUpdatedBy,
         updatedDate: formatStringtoDate(jsonUpdatedDate ?? '', 'yyyy-MM-dd'),
         formNo: jsonFormNo,
         dateIssued: formatStringtoDate(jsonDateIssued ?? '', 'yyyy-MM-dd'),
         revisionNo: jsonRevisionNo.toString(),
         revisionDate: formatStringtoDate(jsonRevisionDate ?? '', 'yyyy-MM-dd'),
         details: jsonDetail??[],
       );

  factory AnalyticalResultOutgoingShipmentProductByVesselHeaderModel.fromJson(
    Map<String, dynamic> json,
  ) => _$AnalyticalResultOutgoingShipmentProductByVesselHeaderModelFromJson(
    json,
  );

  Map<String, dynamic> toJson() =>
      _$AnalyticalResultOutgoingShipmentProductByVesselHeaderModelToJson(this);
}
