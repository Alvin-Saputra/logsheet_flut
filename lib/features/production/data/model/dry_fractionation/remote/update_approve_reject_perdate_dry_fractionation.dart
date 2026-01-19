import 'package:json_annotation/json_annotation.dart';

part 'update_approve_reject_perdate_dry_fractionation.g.dart';

@JsonSerializable()
class UpdateApproveRejectPerdateDryFractionation {
  final bool success;
  final String message;

  UpdateApproveRejectPerdateDryFractionation({
    required this.success,
    required this.message,
  });

  factory UpdateApproveRejectPerdateDryFractionation.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateApproveRejectPerdateDryFractionationFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UpdateApproveRejectPerdateDryFractionationToJson(this);
}
