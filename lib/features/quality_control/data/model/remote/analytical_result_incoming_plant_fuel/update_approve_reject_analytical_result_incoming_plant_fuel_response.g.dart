// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_approve_reject_analytical_result_incoming_plant_fuel_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateApproveRejectAnalyticalResultIncomingPlantFuelResponse
_$UpdateApproveRejectAnalyticalResultIncomingPlantFuelResponseFromJson(
  Map<String, dynamic> json,
) => UpdateApproveRejectAnalyticalResultIncomingPlantFuelResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  data:
      json['data'] == null
          ? null
          : UpdateApproveRejectAnalyticalResultData.fromJson(
            json['data'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic>
_$UpdateApproveRejectAnalyticalResultIncomingPlantFuelResponseToJson(
  UpdateApproveRejectAnalyticalResultIncomingPlantFuelResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'message': instance.message,
  'data': instance.data,
};

UpdateApproveRejectAnalyticalResultData
_$UpdateApproveRejectAnalyticalResultDataFromJson(Map<String, dynamic> json) =>
    UpdateApproveRejectAnalyticalResultData(
      id: json['id'] as String,
      status: json['status'] as String,
      remarks: json['remarks'] as String?,
      updatedBy: json['updated_by'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$UpdateApproveRejectAnalyticalResultDataToJson(
  UpdateApproveRejectAnalyticalResultData instance,
) => <String, dynamic>{
  'id': instance.id,
  'status': instance.status,
  'remarks': instance.remarks,
  'updated_by': instance.updatedBy,
  'updated_at': instance.updatedAt,
};
