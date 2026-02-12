import 'package:json_annotation/json_annotation.dart';

part 'approve_form_transfer_response.g.dart';

@JsonSerializable()
class ApproveFormTransferResponse {
  final bool success;
  final String message;

  ApproveFormTransferResponse({required this.success, required this.message});

  factory ApproveFormTransferResponse.fromJson(Map<String, dynamic> json) =>
      _$ApproveFormTransferResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApproveFormTransferResponseToJson(this);
}
