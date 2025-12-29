// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_of_analysis_incoming_plant_fuel_header_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportOfAnalysisIncomingPlantFuelHeaderModel
_$ReportOfAnalysisIncomingPlantFuelHeaderModelFromJson(
  Map<String, dynamic> json,
) => ReportOfAnalysisIncomingPlantFuelHeaderModel(
  jsonId: json['id'] as String,
  jsonReportNo: json['report_no'] as String,
  jsonShipper: json['shipper'] as String?,
  jsonBuyer: json['buyer'] as String?,
  jsonDateReceived: json['date_received'] as String?,
  jsonDateAnalyzedStart: json['date_analyzed_start'] as String?,
  jsonDateAnalyzedEnd: json['date_analyzed_end'] as String?,
  jsonDateReported: json['date_reported'] as String?,
  jsonLabSampleId: json['lab_sample_id'] as String?,
  jsonCustomerSampleId: json['customer_sample_id'] as String?,
  jsonSealNo: json['seal_no'] as String?,
  jsonWeightofReceivedSample: json['weight_of_received_sample'] as String?,
  jsonTopSizeofReceivedSample: json['top_size_of_received_sample'] as String?,
  jsonAuthorizedBy: json['authorized_by'] as String?,
  jsonAuthorizedDate: json['authorized_date'] as String?,
  jsonDetail:
      (json['details'] as List<dynamic>?)
          ?.map(
            (e) => ReportOfAnalysisIncomingPlantFuelDetailModel.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
  jsonHardGrooveGrindabilityIndex:
      json['hardgrove_grindability_index'] as String?,
);

Map<String, dynamic> _$ReportOfAnalysisIncomingPlantFuelHeaderModelToJson(
  ReportOfAnalysisIncomingPlantFuelHeaderModel instance,
) => <String, dynamic>{
  'id': instance.jsonId,
  'report_no': instance.jsonReportNo,
  'shipper': instance.jsonShipper,
  'buyer': instance.jsonBuyer,
  'date_received': instance.jsonDateReceived,
  'date_analyzed_start': instance.jsonDateAnalyzedStart,
  'date_analyzed_end': instance.jsonDateAnalyzedEnd,
  'date_reported': instance.jsonDateReported,
  'lab_sample_id': instance.jsonLabSampleId,
  'customer_sample_id': instance.jsonCustomerSampleId,
  'seal_no': instance.jsonSealNo,
  'weight_of_received_sample': instance.jsonWeightofReceivedSample,
  'top_size_of_received_sample': instance.jsonTopSizeofReceivedSample,
  'hardgrove_grindability_index': instance.jsonHardGrooveGrindabilityIndex,
  'authorized_by': instance.jsonAuthorizedBy,
  'authorized_date': instance.jsonAuthorizedDate,
  'details': instance.jsonDetail?.map((e) => e.toJson()).toList(),
};
