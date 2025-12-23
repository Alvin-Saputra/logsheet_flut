class CertificateOfAnalysisIncomingPlantChemicalIngredientDetailEntity {
  final String id;
  final String idHdr;
  final String? parameter;
  final double? actualMin;
  final double? actualMax;
  final double? standardMin;
  final double? standardMax;
  final String? method;

  CertificateOfAnalysisIncomingPlantChemicalIngredientDetailEntity({
    required this.id,
    required this.idHdr,
    required this.parameter,
    required this.actualMin,
    required this.actualMax,
    required this.standardMin,
    required this.standardMax,
    required this.method,
  });
}
