import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/auth/data/datasources/local/storage_service/storage_service.dart';
import 'package:logsheet_app/features/quality_control/data/datasources/remote/analytical_result_incoming_plant_fuel/analytical_result_incoming_plant_fuel_api_service.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_fuel/analytical_result/analytical_result_incoming_plant_fuel_header_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_fuel/analytical_with_report_of_analysis_header_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_fuel/report_of_analysis/report_of_analysis_incoming_plant_fuel_header_entity.dart';

class AnalyticalResultIncomingPlantFuelProvider with ChangeNotifier {
  final AnalyticalResultIncomingPlantFuelApiService _apiService;
  final StorageService _storageService;

  AnalyticalResultIncomingPlantFuelProvider(
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

  List<AnalyticalWithReportOfAnalysisHeaderEntity> _reportList = [];
  List<AnalyticalWithReportOfAnalysisHeaderEntity> get reportList =>
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
    required ReportOfAnalysisIncomingPlantFuelHeaderEntity
    reportOfAnalysisHeaderInput,
    required AnalyticalResultIncomingPlantFuelHeaderEntity
    analyticalResultHeaderInput,
  }) async {
    _setLoadingInput(true);

    try {
      final body = {
        "roa": {
          "report_no": reportOfAnalysisHeaderInput.reportNo,
          "shipper": reportOfAnalysisHeaderInput.shipper,
          "buyer": reportOfAnalysisHeaderInput.buyer,
          "date_received": formatDatetoString(
            reportOfAnalysisHeaderInput.dateReceived ?? DateTime.now(),
            'yyyy-MM-dd',
          ),
          "date_analyzed_start": formatDatetoString(
            reportOfAnalysisHeaderInput.dateAnalyzedStart ?? DateTime.now(),
            'yyyy-MM-dd',
          ),
          "date_analyzed_end": formatDatetoString(
            reportOfAnalysisHeaderInput.dateAnalyzedEnd ?? DateTime.now(),
            'yyyy-MM-dd',
          ),
          "date_reported": formatDatetoString(
            reportOfAnalysisHeaderInput.dateReported ?? DateTime.now(),
            'yyyy-MM-dd',
          ),

          "lab_sample_id": reportOfAnalysisHeaderInput.labSampleId,
          "customer_sample_id": reportOfAnalysisHeaderInput.customerSampleId,
          "seal_no": reportOfAnalysisHeaderInput.sealNo,
          "weight_of_received_sample":
              reportOfAnalysisHeaderInput.weightofReceivedSample.toString(),
          "top_size_of_received_sample":
              reportOfAnalysisHeaderInput.topSizeofReceivedSample.toString(),
          "hardgrove_grindability_index":
              reportOfAnalysisHeaderInput.hardGrooveGrindabilityIndex
                  .toString(),
          "details":
              reportOfAnalysisHeaderInput.details
                  .map(
                    (detail) => {
                      "parameter": detail.parameter,
                      "unit": detail.unit,
                      "basis": detail.basis,
                      "result": detail.result,
                    },
                  )
                  .toList(),
        },

        "analytical": {
          "company": analyticalResultHeaderInput.company,
          "plant": analyticalResultHeaderInput.plant,
          "date": formatDatetoString(
            analyticalResultHeaderInput.date ?? DateTime.now(),
            'yyyy-MM-dd HH:mm:ss',
          ),
          "material": analyticalResultHeaderInput.material,
          "quantity": analyticalResultHeaderInput.quantity,
          "supplier": analyticalResultHeaderInput.supplier,
          "police_no": analyticalResultHeaderInput.policeNo,
          "analyst": analyticalResultHeaderInput.analyst,

          "details":
              analyticalResultHeaderInput.details
                  .map(
                    (detail) => {
                      "parameter": detail.parameter,
                      "specification": detail.specification,

                      "result": detail.result,

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
    // String? purpose,
    bool isFilterBasedOnRole = true,
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
        _reportList = data ?? [];

        // DEBUG LOG 3
        print('DEBUG: Data raw length: ${data?.length}');

        // PERBAIKAN: Gunakan List.from untuk keamanan tipe data
        if (isFilterBasedOnRole && AppRoles.leadQC.contains(role)) {
          _reportList =
              _reportList
                  .where((item) => item.analytical.preparedStatus == null)
                  .toList();
        } else if (isFilterBasedOnRole &&
            AppRoles.qualityControlManagerApproval.contains(role)) {
          _reportList =
              _reportList
                  .where((item) => item.analytical.preparedStatus == "Approved")
                  .toList();
        }

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
    required ReportOfAnalysisIncomingPlantFuelHeaderEntity
    reportOfAnalysisHeaderInput,
    required AnalyticalResultIncomingPlantFuelHeaderEntity
    analyticalResultHeaderInput,
  }) async {
    _setLoadingInput(true);

    try {
      final body = {
        "roa": {
          "report_no": reportOfAnalysisHeaderInput.reportNo,
          "shipper": reportOfAnalysisHeaderInput.shipper,
          "buyer": reportOfAnalysisHeaderInput.buyer,
          "date_received": formatDatetoString(
            reportOfAnalysisHeaderInput.dateReceived ?? DateTime.now(),
            'yyyy-MM-dd',
          ),
          "date_analyzed_start": formatDatetoString(
            reportOfAnalysisHeaderInput.dateAnalyzedStart ?? DateTime.now(),
            'yyyy-MM-dd',
          ),
          "date_analyzed_end": formatDatetoString(
            reportOfAnalysisHeaderInput.dateAnalyzedEnd ?? DateTime.now(),
            'yyyy-MM-dd',
          ),
          "date_reported": formatDatetoString(
            reportOfAnalysisHeaderInput.dateReported ?? DateTime.now(),
            'yyyy-MM-dd',
          ),

          "lab_sample_id": reportOfAnalysisHeaderInput.labSampleId,
          "customer_sample_id": reportOfAnalysisHeaderInput.customerSampleId,
          "seal_no": reportOfAnalysisHeaderInput.sealNo,
          "weight_of_received_sample":
              reportOfAnalysisHeaderInput.weightofReceivedSample.toString(),
          "top_size_of_received_sample":
              reportOfAnalysisHeaderInput.topSizeofReceivedSample.toString(),
          "hardgrove_grindability_index":
              reportOfAnalysisHeaderInput.hardGrooveGrindabilityIndex
                  .toString(),
          "details":
              reportOfAnalysisHeaderInput.details
                  .map(
                    (detail) => {
                      "parameter": detail.parameter,
                      "unit": detail.unit,
                      "basis": detail.basis,
                      "result": detail.result,
                    },
                  )
                  .toList(),
        },

        "analytical": {
          "date": formatDatetoString(
            analyticalResultHeaderInput.date ?? DateTime.now(),
            'yyyy-MM-dd HH:mm:ss',
          ),
          "material": analyticalResultHeaderInput.material,
          "quantity": analyticalResultHeaderInput.quantity,
          "supplier": analyticalResultHeaderInput.supplier,
          "police_no": analyticalResultHeaderInput.policeNo,
          "analyst": analyticalResultHeaderInput.analyst,

          "details":
              analyticalResultHeaderInput.details
                  .map(
                    (detail) => {
                      "parameter": detail.parameter,
                      "specification": detail.specification,

                      "result": detail.result,

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
