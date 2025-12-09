import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_truck/analytical_result_incoming_material_by_truck_header_model.dart';

part 'fetch_analytical_result_incoming_material_by_truck_response.g.dart';

@JsonSerializable(explicitToJson: true)
class FetchAnalyticalResultIncomingMaterialByTruckResponse {
  final bool success;
  final List<AnalyticalResultIncomingMaterialByTruckHeaderModel> data;

  FetchAnalyticalResultIncomingMaterialByTruckResponse({
    required this.success,
    required this.data,
  });

  factory FetchAnalyticalResultIncomingMaterialByTruckResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$FetchAnalyticalResultIncomingMaterialByTruckResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FetchAnalyticalResultIncomingMaterialByTruckResponseToJson(this);
}
