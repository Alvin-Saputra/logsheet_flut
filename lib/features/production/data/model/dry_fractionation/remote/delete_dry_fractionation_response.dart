import 'package:json_annotation/json_annotation.dart';

part 'delete_dry_fractionation_response.g.dart';

@JsonSerializable()
class DeleteDryFractionationResponse {
  final bool success;

  DeleteDryFractionationResponse({
    required this.success,
  });

  factory DeleteDryFractionationResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$DeleteDryFractionationResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DeleteDryFractionationResponseToJson(this);
}
