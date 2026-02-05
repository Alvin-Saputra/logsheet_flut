import 'package:json_annotation/json_annotation.dart';

part 'create_dry_fractionation_response.g.dart';

@JsonSerializable()
class CreateDryFractionationResponse {
  final bool? success;
  final String? message;// Data berada di dalam objek sendiri

  CreateDryFractionationResponse({this.success, this.message});

  factory CreateDryFractionationResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateDryFractionationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateDryFractionationResponseToJson(this);
}

