// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate_of_analysis_incoming_plant_chemical_ingredient_header_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderModel
_$CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderModelFromJson(
  Map<String, dynamic> json,
) => CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderModel(
  jsonId: json['id'] as String,
  jsonNoDoc: json['no_doc'] as String,
  jsonProduct: json['product'] as String,
  jsonGrade: json['grade'] as String?,
  jsonPacking: json['packing'] as String?,
  jsonQuantity: json['quantity'] as String?,
  jsonTanggalPengiriman: json['tanggal_pengiriman'] as String?,
  jsonVehicle: json['vehicle'] as String?,
  jsonLotNo: json['lot_no'] as String?,
  jsonProductionDate: json['production_date'] as String?,
  jsonExpiredDate: json['expired_date'] as String?,
  jsonIssueBy: json['issue_by'] as String?,
  jsonIssueDate: json['issue_date'] as String?,
  jsonUpdatedDate: json['updated_date'] as String?,
  jsonUpdatedBy: json['updated_by'] as String?,
  jsonDetail:
      (json['details'] as List<dynamic>?)
          ?.map(
            (e) =>
                CertificateOfAnalysisIncomingPlantChemicalIngredientDetailModel.fromJson(
                  e as Map<String, dynamic>,
                ),
          )
          .toList(),
);

Map<String, dynamic>
_$CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderModelToJson(
  CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderModel instance,
) => <String, dynamic>{
  'id': instance.jsonId,
  'no_doc': instance.jsonNoDoc,
  'product': instance.jsonProduct,
  'grade': instance.jsonGrade,
  'packing': instance.jsonPacking,
  'quantity': instance.jsonQuantity,
  'tanggal_pengiriman': instance.jsonTanggalPengiriman,
  'vehicle': instance.jsonVehicle,
  'lot_no': instance.jsonLotNo,
  'production_date': instance.jsonProductionDate,
  'expired_date': instance.jsonExpiredDate,
  'issue_by': instance.jsonIssueBy,
  'issue_date': instance.jsonIssueDate,
  'updated_date': instance.jsonUpdatedDate,
  'updated_by': instance.jsonUpdatedBy,
  'details': instance.jsonDetail?.map((e) => e.toJson()).toList(),
};
