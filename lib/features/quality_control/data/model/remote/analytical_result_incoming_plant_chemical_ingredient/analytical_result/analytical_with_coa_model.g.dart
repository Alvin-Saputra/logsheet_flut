// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytical_with_coa_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnalyticalWithCoaModel _$AnalyticalWithCoaModelFromJson(
  Map<String, dynamic> json,
) => AnalyticalWithCoaModel(
  analytical:
      AnalyticalResultIncomingPlantChemicalIngredientHeaderModel.fromJson(
        json['analytical'] as Map<String, dynamic>,
      ),
  coa: CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderModel.fromJson(
    json['coa'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$AnalyticalWithCoaModelToJson(
  AnalyticalWithCoaModel instance,
) => <String, dynamic>{
  'analytical': instance.analytical.toJson(),
  'coa': instance.coa.toJson(),
};
