import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/features/form_transfer/data/model/remote/form_transfer_header_model.dart';

part 'fetch_form_transfer_response.g.dart';

@JsonSerializable(explicitToJson: true)
class FetchFormTransferResponse {
  final bool success;
  final List<FormTransferHeaderModel> data;

  FetchFormTransferResponse({required this.success, required this.data});

  factory FetchFormTransferResponse.fromJson(Map<String, dynamic> json) =>
      _$FetchFormTransferResponseFromJson(json);

  Map<String, dynamic> toJson() => _$FetchFormTransferResponseToJson(this);
}
