import 'package:json_annotation/json_annotation.dart';

part 'delete_form_transfer_response.g.dart';

@JsonSerializable()
class DeleteFormTransferResponse {
  final bool success;
  final String message;

  DeleteFormTransferResponse({required this.success, required this.message});

  factory DeleteFormTransferResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteFormTransferResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteFormTransferResponseToJson(this);
}
