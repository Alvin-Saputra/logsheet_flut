// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytical_with_roa_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticalWithRoaModel _$AnalyticalWithRoaModelFromJson(
  Map<String, dynamic> json,
) => AnalyticalWithRoaModel(
  analytical: AnalyticalResultIncomingPlantFuelHeaderModel.fromJson(
    json['analytical'] as Map<String, dynamic>,
  ),
  roa: ReportOfAnalysisIncomingPlantFuelHeaderModel.fromJson(
    json['roa'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$AnalyticalWithRoaModelToJson(
  AnalyticalWithRoaModel instance,
) => <String, dynamic>{
  'analytical': instance.analytical.toJson(),
  'roa': instance.roa.toJson(),
};
