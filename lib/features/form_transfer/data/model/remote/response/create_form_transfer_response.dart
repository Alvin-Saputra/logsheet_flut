import 'package:json_annotation/json_annotation.dart';

part 'create_form_transfer_response.g.dart';

@JsonSerializable()
class CreateFormTransferResponse {
  final bool success;

  @JsonKey(name: "id_header")
  final String idHeader;

  @JsonKey(name: "id_det")
  final List<String> idDet;

  CreateFormTransferResponse({
    required this.success,
    required this.idHeader,
    required this.idDet,
  });

  factory CreateFormTransferResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateFormTransferResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CreateFormTransferResponseToJson(this);
}
