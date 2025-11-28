import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_header_model.dart';

part 'fetch_analytical_result_incoming_material_by_vessel_response.g.dart';

@JsonSerializable(explicitToJson: true)
class FetchAnalyticalResultIncomingMaterialByVesselResponse {
  final bool success;
  final List<AnalyticalResultIncomingMaterialByVesselHeaderModel> data;

  FetchAnalyticalResultIncomingMaterialByVesselResponse({
    required this.success,
    required this.data,
  });

  factory FetchAnalyticalResultIncomingMaterialByVesselResponse.fromJson(
          Map<String, dynamic> json) =>
      _$FetchAnalyticalResultIncomingMaterialByVesselResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FetchAnalyticalResultIncomingMaterialByVesselResponseToJson(this);
}
