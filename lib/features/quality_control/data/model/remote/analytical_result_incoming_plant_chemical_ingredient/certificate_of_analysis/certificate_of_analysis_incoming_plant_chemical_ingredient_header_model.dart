import 'package:json_annotation/json_annotation.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/certificate_of_analysis_incoming_plant_chemical_ingredient_header_entity.dart';
import 'certificate_of_analysis_incoming_plant_chemical_ingredient_detail_model.dart';

part 'certificate_of_analysis_incoming_plant_chemical_ingredient_header_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderModel
    extends CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderEntity {
  @JsonKey(name: 'id')
  final String jsonId;

  @JsonKey(name: 'no_doc')
  final String jsonNoDoc;

  @JsonKey(name: 'product')
  final String jsonProduct;

  @JsonKey(name: 'grade')
  final String? jsonGrade;

  @JsonKey(name: 'packing')
  final String? jsonPacking;

  @JsonKey(name: 'quantity')
  final String? jsonQuantity;

  @JsonKey(name: 'tanggal_pengiriman')
  final String? jsonTanggalPengiriman;

  @JsonKey(name: 'vehicle')
  final String? jsonVehicle;

  @JsonKey(name: 'lot_no')
  final String? jsonLotNo;

  @JsonKey(name: 'production_date')
  final String? jsonProductionDate;

  @JsonKey(name: 'expired_date')
  final String? jsonExpiredDate;

  @JsonKey(name: 'issue_by')
  final String? jsonIssueBy;

  @JsonKey(name: 'issue_date')
  final String? jsonIssueDate;

  @JsonKey(name: 'updated_date')
  final String? jsonUpdatedDate;

  @JsonKey(name: 'updated_by')
  final String? jsonUpdatedBy;

  // List Detail (Model)
  @JsonKey(name: 'details')
  final List<CertificateOfAnalysisIncomingPlantChemicalIngredientDetailModel>?
  jsonDetail;

  CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderModel({
    required this.jsonId,
    required this.jsonNoDoc,
    required this.jsonProduct,
    this.jsonGrade,
    this.jsonPacking,
    this.jsonQuantity,
    this.jsonTanggalPengiriman,
    this.jsonVehicle,
    this.jsonLotNo,
    this.jsonProductionDate,
    this.jsonExpiredDate,
    this.jsonIssueBy,
    this.jsonIssueDate,
    this.jsonUpdatedDate,
    this.jsonUpdatedBy,
    this.jsonDetail,
  }) : super(
         id: jsonId,
         noDoc: jsonNoDoc,
         product: jsonProduct,
         grade: jsonGrade,
         packing: jsonPacking,
         quantity: parseDouble(jsonQuantity) ?? 0,
         tanggalPengiriman: formatStringtoDate(
           jsonTanggalPengiriman ?? '',
           'yyyy-MM-dd HH:mm:ss',
         ),
         vehicle: jsonVehicle,
         lotNo: jsonLotNo,
         productionDate: formatStringtoDate(
           jsonProductionDate ?? '',
           'yyyy-MM-dd HH:mm:ss',
         ),
         expiredDate: formatStringtoDate(
           jsonExpiredDate ?? '',
           'yyyy-MM-dd HH:mm:ss',
         ),
         issueBy: jsonIssueBy,
         issueDate: formatStringtoDate(
           jsonIssueDate ?? '',
           'yyyy-MM-dd HH:mm:ss',
         ),
         updatedDate: formatStringtoDate(
           jsonUpdatedDate, // Hapus "?? ''"
           'yyyy-MM-dd HH:mm:ss',
         ),
         updatedBy: jsonUpdatedBy,
         details: jsonDetail ?? [],
       );

  factory CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderModelFromJson(
        json,
      );

  Map<String, dynamic> toJson() =>
      _$CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderModelToJson(
        this,
      );
}
