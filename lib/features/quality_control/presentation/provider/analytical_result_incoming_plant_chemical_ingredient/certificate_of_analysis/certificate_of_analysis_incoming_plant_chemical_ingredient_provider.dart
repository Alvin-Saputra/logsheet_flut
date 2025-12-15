import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/auth/data/datasources/local/storage_service/storage_service.dart';
import 'package:logsheet_app/features/quality_control/data/datasources/remote/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_api_service.dart';
import 'package:logsheet_app/features/quality_control/data/datasources/remote/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/certificate_of_analysis_incoming_plant_chemical_ingredient_api_service.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/certificate_of_analysis_incoming_plant_chemical_ingredient_header_entity.dart';

class CertificateOfAnalysisIncomingPlantChemicalIngredientProvider
    with ChangeNotifier {
  final CertificateOfAnalysisIncomingPlantChemicalIngredientApiService
  _apiService;
  final StorageService _storageService;

  CertificateOfAnalysisIncomingPlantChemicalIngredientProvider(
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

  List<CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderEntity>
  _reportList = [];
  List<CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderEntity>
  get reportList => _reportList;

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
    headerInput,
    required String menuId,
  }) async {
    _setLoadingInput(true);

    try {
      final body = {
        "no_doc": headerInput.noDoc,
        "product": headerInput.product,
        "grade": headerInput.grade,
        "packing": headerInput.packing,
        "quantity": headerInput.quantity.toString(),
        "tanggal_pengiriman": formatDatetoString(
          headerInput.tanggalPengiriman ?? DateTime.now(),
          'yyy-MM-dd HH:mm:ss',
        ),
        "vehicle": headerInput.vehicle,
        "lot_no": headerInput.lotNo,
        "production_date": formatDatetoString(
          headerInput.productionDate ?? DateTime.now(),
          'yyy-MM-dd HH:mm:ss',
        ),
        "expired_date": formatDatetoString(
          headerInput.expiredDate ?? DateTime.now(),
          'yyy-MM-dd HH:mm:ss',
        ),

        "detail":
            headerInput.details
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
      };

      String token = await _storageService.readSessionToken() ?? '';

      final response = await _apiService.insertReport(body, 'Bearer $token');

      if (response != null && response.success == true) {
        notifyListeners();
        return true;
      } else {
        _setErrorMessage('Insert report failed.');
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
        _reportList = List<
          CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderEntity
        >.from(data ?? []);

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
    headerInput,
    required String menuId,
  }) async {
    _setLoadingInput(true);

    try {
      final body = {
        "no_doc": headerInput.noDoc,
        "product": headerInput.product,
        "grade": headerInput.grade,
        "packing": headerInput.packing,
        "quantity": headerInput.quantity.toString(),
        "tanggal_pengiriman": formatDatetoString(
          headerInput.tanggalPengiriman ?? DateTime.now(),
          'yyy-MM-dd HH:mm:ss',
        ),
        "vehicle": headerInput.vehicle,
        "lot_no": headerInput.lotNo,
        "production_date": formatDatetoString(
          headerInput.productionDate ?? DateTime.now(),
          'yyy-MM-dd HH:mm:ss',
        ),
        "expired_date": formatDatetoString(
          headerInput.expiredDate ?? DateTime.now(),
          'yyy-MM-dd HH:mm:ss',
        ),
        "detail":
            headerInput.details
                .map(
                  (detail) => {
                    "parameter": detail.parameter,
                    "actual_min": detail.actualMin,
                    "actual_max": detail.actualMax,
                    "standard_min": detail.standardMin,
                    "standard_max": detail.standardMax,
                    "method": detail.method,
                  },
                )
                .toList(),
      };

      String token = await _storageService.readSessionToken() ?? '';

      final response = await _apiService.updateReport(
        'Bearer $token',
        headerInput.id,
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

  void clearReports() {
    _reportList.clear();
  }
}
