import 'package:json_annotation/json_annotation.dart';

part 'update_dry_fractionation_response.g.dart';

@JsonSerializable()
class UpdateDryFractionationResponse {
  final bool? success;
  final String? message;

  UpdateDryFractionationResponse({this.success, this.message});

  factory UpdateDryFractionationResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateDryFractionationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateDryFractionationResponseToJson(this);
}
