import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/auth/data/datasources/local/storage_service/storage_service.dart';
import 'package:logsheet_app/features/quality_control/data/datasources/remote/analytical_result_incoming_plant_chemical_ingredient/analytical_result/analytical_result_incoming_plant_chemical_ingredient_api_service.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_chemical_ingredient/analytical_result/analytical_result_incoming_plant_chemical_ingredient_header_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_chemical_ingredient/analytical_with_certificate_of_analysis_header_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/certificate_of_analysis_incoming_plant_chemical_ingredient_header_entity.dart';

class AnalyticalResultIncomingPlantChemicalIngredientProvider
    with ChangeNotifier {
  final AnalyticalResultIncomingPlantChemicalIngredientApiService _apiService;
  final StorageService _storageService;

  AnalyticalResultIncomingPlantChemicalIngredientProvider(
    this._apiService,
    this._storageService,
  );

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Loading state for input
  bool _isLoadingInput = false;
  bool get isLoadingInput => _isLoadingInput;

  // Loading state for edit
  bool _isLoadingEdit = false;
  bool get isLoadingEdit => _isLoadingEdit;

  // Loading state for delete
  bool _isLoadingDelete = false;
  bool get isLoadingDelete => _isLoadingDelete;

  // Loading state for approval
  bool _isLoadingApproval = false;
  bool get isLoadingApproval => _isLoadingApproval;

  // Error Message
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _latestId;
  String? get latestId => _latestId;

  List<AnalyticalWithCertificateOfAnalysisHeaderEntity> _reportList = [];
  List<AnalyticalWithCertificateOfAnalysisHeaderEntity> get reportList =>
      _reportList;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setLoadingInput(bool value) {
    _isLoadingInput = value;
    notifyListeners();
  }

  void _setLoadingEdit(bool value) {
    _isLoadingEdit = value;
    notifyListeners();
  }

  void _setLoadingDelete(bool value) {
    _isLoadingDelete = value;
    notifyListeners();
  }

  void _setLoadingApproval(bool value) {
    _isLoadingApproval = value;
    notifyListeners();
  }

  // Set Error Message
  void _setErrorMessage(String? value) {
    // _setErrorMessage(value);
    _errorMessage = value;
    notifyListeners();
  }

  Future<bool> insertReport({
    required CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderEntity
    certificateOfAnalysisHeaderInput,
    required AnalyticalResultIncomingPlantChemicalIngredientHeaderEntity
    analyticalResultHeaderInput,
  }) async {
    _setLoadingInput(true);

    try {
      final body = {
        "coa": {
          "no_doc": certificateOfAnalysisHeaderInput.noDoc,
          "product": certificateOfAnalysisHeaderInput.product,
          "grade": certificateOfAnalysisHeaderInput.grade,
          "packing": certificateOfAnalysisHeaderInput.packing,
          "quantity": certificateOfAnalysisHeaderInput.quantity.toString(),
          "tanggal_pengiriman": formatDatetoString(
            certificateOfAnalysisHeaderInput.tanggalPengiriman ??
                DateTime.now(),
            'yyyy-MM-dd HH:mm:ss',
          ),
          "vehicle": certificateOfAnalysisHeaderInput.vehicle,
          "lot_no": certificateOfAnalysisHeaderInput.lotNo,
          "production_date": formatDatetoString(
            certificateOfAnalysisHeaderInput.productionDate ?? DateTime.now(),
            'yyyy-MM-dd HH:mm:ss',
          ),
          "expired_date": formatDatetoString(
            certificateOfAnalysisHeaderInput.expiredDate ?? DateTime.now(),
            'yyyy-MM-dd HH:mm:ss',
          ),
          "details":
              certificateOfAnalysisHeaderInput.details
                  .map(
                    (detail) => {
                      "parameter": detail.parameter,
                      "actual_min": detail.actualMin.toString(),
                      "actual_max": detail.actualMax.toString(),
                      "standard_min": detail.standardMin.toString(),
                      "standard_max": detail.standardMax.toString(),
                      "method": detail.method,
                    },
                  )
                  .toList(),
        },

        "analytical": {
          "material": analyticalResultHeaderInput.material,
          "no_ref_coa": analyticalResultHeaderInput.noRefCoa,
          "received_quantity": analyticalResultHeaderInput.quantity,
          "analyst": analyticalResultHeaderInput.analyst,
          "supplier": analyticalResultHeaderInput.supplier,
          "police_no": analyticalResultHeaderInput.policeNo,
          "batch_lot": analyticalResultHeaderInput.batchLot,
          "status": analyticalResultHeaderInput.status,
          "date": formatDatetoString(
            analyticalResultHeaderInput.date ?? DateTime.now(),
            'yyyy-MM-dd HH:mm:ss',
          ),
          "exp_date": formatDatetoString(
            analyticalResultHeaderInput.expDate ?? DateTime.now(),
            'yyyy-MM-dd HH:mm:ss',
          ),
          // "entry_by": analyticalResultHeaderInput.entryBy,
          // "entry_date": formatDatetoString(
          //   analyticalResultHeaderInput.entryDate ?? DateTime.now(),
          //   'yyyy-MM-dd HH:mm:ss',
          // ),
          // "form_no": "F/QCO-011",
          // "date_issued": "2025-03-14",
          // "revision_no": 1,
          // "revision_date": "2025-03-17",
          "details":
              analyticalResultHeaderInput.details
                  .map(
                    (detail) => {
                      "parameter": detail.parameter,
                      "specification_min": detail.specificationMin.toString(),
                      "specification_max": detail.specificationMax.toString(),
                      "result_min": detail.resultMin.toString(),
                      "result_max": detail.resultMax.toString(),
                      "status_ok": detail.statusOk,
                      "remark": detail.remark,
                    },
                  )
                  .toList(),
        },
      };

      String token = await _storageService.readSessionToken() ?? '';

      final response = await _apiService.insertReport(body, 'Bearer $token');
      print('DEBUG: Response received. Success: ${response?.success}');
      if (response.success == true) {
        notifyListeners();
        return true;
      } else {
        print('DEBUG: Fetch failed logic triggered');
        _setErrorMessage('Fetch report failed.');
        _setErrorMessage('Insert report failed.');
        notifyListeners();
        return false;
      }
    } catch (e, stacktrace) {
      print('DEBUG ERROR: $e');
      print('DEBUG STACKTRACE: $stacktrace');
      _setErrorMessage(e.toString());
      notifyListeners();
      return false;
    } finally {
      _setLoadingInput(false);
      notifyListeners();
    }
  }

  Future<void> fetchReport(
    String plantId,
    String? date, {
    String? role,
    String? purpose,
  }) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      String token = await _storageService.readSessionToken() ?? '';

      // DEBUG LOG 1
      print('DEBUG: Start fetching...');

      final response = await _apiService.fetchReports(
        'Bearer $token',
        date ?? '',
      );

      // DEBUG LOG 2
      print('DEBUG: Response received. Success: ${response?.success}');

      if (response != null && response.success == true) {
        final data = response.data;

        // DEBUG LOG 3
        print('DEBUG: Data raw length: ${data?.length}');

        // PERBAIKAN: Gunakan List.from untuk keamanan tipe data
        _reportList = data ?? [];

        // DEBUG LOG 4
        print('DEBUG: _reportList updated. Length: ${_reportList.length}');

        notifyListeners();
      } else {
        print('DEBUG: Fetch failed logic triggered');
        _setErrorMessage('Fetch report failed.');
      }
      // Hapus notifyListeners() kedua disini karena sudah ada di dalam if dan finally
      // notifyListeners();
    } catch (e, stacktrace) {
      // Tambahkan stacktrace
      // DEBUG LOG ERROR
      print('DEBUG ERROR: $e');
      print('DEBUG STACKTRACE: $stacktrace');

      _setErrorMessage("$e");
      notifyListeners();
    } finally {
      _setLoading(false);
      // notifyListeners(); // Ini sebenarnya redundant karena _setLoading sudah memanggil notifyListeners
    }
  }

  Future<bool> updateReport({
    required CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderEntity
    certificateOfAnalysisHeaderInput,
    required AnalyticalResultIncomingPlantChemicalIngredientHeaderEntity
    analyticalResultHeaderInput,
  }) async {
    _setLoadingInput(true);

    try {
      final body = {
        "coa": {
          "no_doc": certificateOfAnalysisHeaderInput.noDoc,
          "product": certificateOfAnalysisHeaderInput.product,
          "grade": certificateOfAnalysisHeaderInput.grade,
          "packing": certificateOfAnalysisHeaderInput.packing,
          "quantity": certificateOfAnalysisHeaderInput.quantity,
          "tanggal_pengiriman": formatDatetoString(
            certificateOfAnalysisHeaderInput.tanggalPengiriman ??
                DateTime.now(),
            'yyyy-MM-dd HH:mm:ss',
          ),
          "vehicle": certificateOfAnalysisHeaderInput.vehicle,
          "lot_no": certificateOfAnalysisHeaderInput.lotNo,
          "production_date": formatDatetoString(
            certificateOfAnalysisHeaderInput.productionDate ?? DateTime.now(),
            'yyyy-MM-dd HH:mm:ss',
          ),
          "expired_date": formatDatetoString(
            certificateOfAnalysisHeaderInput.expiredDate ?? DateTime.now(),
            'yyyy-MM-dd HH:mm:ss',
          ),
          "details":
              certificateOfAnalysisHeaderInput.details
                  .map(
                    (detail) => {
                      "id": detail.id,
                      "parameter": detail.parameter,
                      "actual_min": detail.actualMin,
                      "actual_max": detail.actualMax,
                      "standard_min": detail.standardMin,
                      "standard_max": detail.standardMax,
                      "method": detail.method,
                    },
                  )
                  .toList(),
        },
        "analytical": {
          "no_ref_coa": analyticalResultHeaderInput.noRefCoa,
          "date": formatDatetoString(
            analyticalResultHeaderInput.date ?? DateTime.now(),
            'yyyy-MM-dd HH:mm:ss',
          ),
          "exp_date": formatDatetoString(
            analyticalResultHeaderInput.expDate ?? DateTime.now(),
            'yyyy-MM-dd HH:mm:ss',
          ),
          "material": analyticalResultHeaderInput.material,

          "received_quantity": analyticalResultHeaderInput.quantity,
          "analyst": analyticalResultHeaderInput.analyst,
          "supplier": analyticalResultHeaderInput.supplier,
          "police_no": analyticalResultHeaderInput.policeNo,
          "batch_lot": analyticalResultHeaderInput.batchLot,
          "status": analyticalResultHeaderInput.status,

          "details":
              analyticalResultHeaderInput.details
                  .map(
                    (detail) => {
                      "id": detail.id,
                      // "id_hdr": detail.idHdr,
                      "parameter": detail.parameter,
                      "specification_min": detail.specificationMin,
                      "specification_max": detail.specificationMax,
                      "result_min": detail.resultMin,
                      "result_max": detail.resultMax,
                      "status_ok": detail.statusOk,
                      "remark": detail.remark,
                    },
                  )
                  .toList(),
        },
      };

      String token = await _storageService.readSessionToken() ?? '';

      final response = await _apiService.updateReport(
        'Bearer $token',
        analyticalResultHeaderInput.id,
        body,
      );

      if (response != null && response.success == true) {
        notifyListeners();
        return true;
      } else {
        _setErrorMessage('Update report failed.');
        notifyListeners();
        return false;
      }
    } catch (e) {
      _setErrorMessage(e.toString());
      notifyListeners();
      return false;
    } finally {
      _setLoadingInput(false);
      notifyListeners();
    }
  }

  Future<bool> deleteReport({required String id}) async {
    _setLoadingDelete(true);
    _setErrorMessage(null);

    try {
      String token = await _storageService.readSessionToken() ?? '';
      final response = await _apiService.deleteReport('Bearer $token', id);

      if (response != null && response.success == true) {
        notifyListeners();
        return true;
      } else {
        _setErrorMessage('Delete Report Failed');
        notifyListeners();
        return false;
      }
    } catch (e) {
      _setErrorMessage("$e");
      notifyListeners();
      return false;
    } finally {
      _setLoadingDelete(false);
      notifyListeners();
    }
  }

  Future<bool> updateApproveRejectReport({
    required String id,
    required String status,
    required String remarks,
  }) async {
    _setLoadingEdit(true);
    _setErrorMessage(null);
    try {
      final body = {"status": status, "remark": remarks};

      String token = await _storageService.readSessionToken() ?? '';
      final response = await _apiService.updateApprovalReport(
        'Bearer $token',
        id,
        body,
      );

      if (response != null && response.success == true) {
        notifyListeners();
        return true;
      } else {
        _setErrorMessage('Update Approve/Reject Report Failed');
        notifyListeners();
        return false;
      }
    } catch (e) {
      _setErrorMessage(e.toString());
      notifyListeners();
      return false;
    } finally {
      _setLoadingEdit(false);
      notifyListeners();
    }
  }

  void clearReports() {
    _reportList.clear();
  }
}
