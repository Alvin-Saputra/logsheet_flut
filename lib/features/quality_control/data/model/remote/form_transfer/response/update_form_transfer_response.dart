import 'package:json_annotation/json_annotation.dart';

part 'update_form_transfer_response.g.dart';

@JsonSerializable()
class UpdateFormTransferResponse {
  final bool success;
  final String message;

  UpdateFormTransferResponse({required this.success, required this.message});

  factory UpdateFormTransferResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateFormTransferResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateFormTransferResponseToJson(this);
}
