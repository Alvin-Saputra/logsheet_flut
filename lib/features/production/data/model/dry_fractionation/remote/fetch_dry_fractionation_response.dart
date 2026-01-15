import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/features/production/data/model/dry_fractionation/remote/dry_fractionation_header_model.dart';

part 'fetch_dry_fractionation_response.g.dart';

@JsonSerializable(explicitToJson: true)
class FetchDryFractionationResponse {
  final bool success;
  final List<DryFractionationHeaderModel> data;

  FetchDryFractionationResponse({
    required this.success,
    required this.data,
  });

  factory FetchDryFractionationResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$FetchDryFractionationResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$FetchDryFractionationResponseToJson(this);
}
