import 'package:json_annotation/json_annotation.dart';

part 'update_approve_reject_dry_fractionation.g.dart';

@JsonSerializable()
class UpdateApproveRejectDryFractionation {
  final bool success;
  final String message;

  UpdateApproveRejectDryFractionation({
    required this.success,
    required this.message,
  });

  factory UpdateApproveRejectDryFractionation.fromJson(Map<String, dynamic> json) =>
      _$UpdateApproveRejectDryFractionationFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateApproveRejectDryFractionationToJson(this);
}
