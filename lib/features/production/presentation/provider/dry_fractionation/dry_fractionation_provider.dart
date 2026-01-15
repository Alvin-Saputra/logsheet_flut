import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/auth/data/datasources/local/storage_service/storage_service.dart';
import 'package:logsheet_app/features/production/data/datasources/dry_fractionation/dry_fractionation_api_service.dart';
import 'package:logsheet_app/features/production/data/model/dry_fractionation/local/dry_fractionation_header_entity.dart';
import 'package:logsheet_app/features/quality_control/data/datasources/remote/analytical_result_incoming_material_by_truck/analytical_result_incoming_material_by_truck_api_service.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_truck/analytical_result_incoming_material_by_truck_header_entity.dart';

class DryFractionationProvider with ChangeNotifier {
  final DryFractionationApiService _apiService;
  final StorageService _storageService;

  DryFractionationProvider(this._apiService, this._storageService);

  // Loading state for fetching
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

  List<DryFractionationHeaderEntity> _reportList = [];
  List<DryFractionationHeaderEntity> get reportList => _reportList;

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
    required DryFractionationHeaderEntity headerInput,
    required String menuId,
  }) async {
    _setLoadingInput(true);

    try {
      final body = {
        "date": formatDatetoString(
          headerInput.date ?? DateTime.now(),
          'yyyy-MM-dd HH:mm:ss',
        ),
        "posting_date": formatDatetoString(
          headerInput.postingDate ?? DateTime.now(),
          'yyyy-MM-dd HH:mm:ss',
        ),
        "company": headerInput.company,
        "plant": headerInput.plant,
        "crystallizer": headerInput.crystallizer,
        "feed_oil_iv": headerInput.feedOilIv,
        "initial_oil_level": headerInput.initialOilLevel,
        "filling_start_time": formatTimeOfDay(
          headerInput.fillingStartTime,
          showSecond: false,
        ),
        "filling_end_time": formatTimeOfDay(
          headerInput.fillingEndTime,
          showSecond: false,
        ),
        "cooling_start_temp": headerInput.coolingStartTemp,
        "cooling_start_time": formatTimeOfDay(
          headerInput.coolingStartTime,
          showSecond: false,
        ),
        "agitator_speed": headerInput.agitatorSpeed,
        "water_pump_pres": headerInput.waterPumpPres,
        "remarks": headerInput.remarks,
        "is_completed":
            headerInput.isCompleted == null
                ? null
                : (headerInput.isCompleted! ? 1 : 0),
        "details":
            headerInput.details
                .map(
                  (detail) => {
                    "filtration_cycle_number": detail.filtrationCycleNumber,
                    "filtration_date": formatDatetoString(
                      detail.filtrationDate ?? DateTime.now(),
                      'yyyy-MM-dd',
                    ),
                    "filtration_temp": detail.filtrationTemp,
                    "time_start_filtration": formatTimeOfDay(
                      detail.timeStartFiltration,
                      showSecond: false,
                    ),
                    "time_end_filtration": formatTimeOfDay(
                      detail.timeEndFiltration,
                      showSecond: false,
                    ),
                    "load": detail.load,
                    "olein_iv": detail.oleinIv,
                    "olein_cp": detail.oleinCp,
                    "olein_ffa": detail.oleinFfa,
                    "olein_color_red": detail.oleinColorRed,
                    "stearin_iv": detail.stearinIv,
                    "stearin_ffa": detail.stearinFfa,
                    "stearin_color_red": detail.stearinColorRed,
                    "stearin_pv": detail.stearinPv,
                  },
                )
                .toList(),
      };

      String token = await _storageService.readSessionToken() ?? '';

      final response = await _apiService.insertReport(body, 'Bearer $token');

      if (response.success == true) {
        notifyListeners();
        return true;
      } else {
        // Jika server return 200 tapi success: false (jarang terjadi di REST standard, tapi jaga-jaga)
        _setErrorMessage(response.message ?? 'Insert report failed.');
        notifyListeners();
        return false;
      }
    } on DioException catch (e) {
      // --- MENANGKAP ERROR DARI API (400, 422, 500) ---

      String msg = 'Terjadi kesalahan jaringan.';

      if (e.response != null) {
        // Ambil data JSON error dari server
        final errorData = e.response?.data;

        // Cek apakah response berupa Map/JSON
        if (errorData is Map<String, dynamic>) {
          // Prioritas 1: Ambil key 'message' (Ini yang dikirim oleh Controller Laravel Anda)
          if (errorData.containsKey('message')) {
            msg = errorData['message'];
          }
          // Prioritas 2: Ambil key 'error' (Format error default lain)
          else if (errorData.containsKey('error')) {
            msg = errorData['error'];
          }

          // Opsi Tambahan: Jika ada validasi field spesifik (Laravel biasanya kirim key 'errors')
          // if (errorData.containsKey('errors')) {
          //   msg += "\nDetail: ${errorData['errors']}";
          // }
        } else {
          // Jika error body berupa string mentah
          msg = errorData.toString();
        }
      } else {
        // Error tanpa response (Timeout, No Internet)
        msg = e.message ?? 'Koneksi gagal.';
      }

      _setErrorMessage(msg);
      notifyListeners();
      return false;
    } catch (e) {
      _setErrorMessage(e.toString());
      notifyListeners();
      return false;
    } finally {
      _setLoadingInput(false);
      notifyListeners();
    }
  }

  Future<void> fetchReport(String plantId, String? date, {String? role}) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      String token = await _storageService.readSessionToken() ?? '';

      // DEBUG LOG 1
      print('DEBUG: Start fetching...');

      final response = await _apiService.fetchReports(
        'Bearer $token',
        plantId ?? '',
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

        if (AppRoles.leadProd.contains(role) ||
            AppRoles.qualityControlManagerApproval.contains(role)) {
          _reportList =
              _reportList.where((report) => report.preparedBy == null).toList();
          notifyListeners();
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

  Future<bool> updateReport({
    required DryFractionationHeaderEntity headerInput,
    required String menuId,
  }) async {
    _setLoadingInput(true);

    try {
      final body = {
        "date": formatDatetoString(
          headerInput.date ?? DateTime.now(),
          'yyyy-MM-dd HH:mm:ss',
        ),
        "posting_date": formatDatetoString(
          headerInput.postingDate ?? DateTime.now(),
          'yyyy-MM-dd HH:mm:ss',
        ),
        "company": headerInput.company,
        "plant": headerInput.plant,
        "crystallizer": headerInput.crystallizer,
        "feed_oil_iv": headerInput.feedOilIv,
        "initial_oil_level": headerInput.initialOilLevel,
        "filling_start_time": formatTimeOfDay(
          headerInput.fillingStartTime,
          showSecond: false,
        ),
        "filling_end_time": formatTimeOfDay(
          headerInput.fillingEndTime,
          showSecond: false,
        ),
        "cooling_start_temp": headerInput.coolingStartTemp,
        "cooling_start_time": formatTimeOfDay(
          headerInput.coolingStartTime,
          showSecond: false,
        ),
        "agitator_speed": headerInput.agitatorSpeed,
        "water_pump_pres": headerInput.waterPumpPres,
        "remarks": headerInput.remarks,
        "is_completed":
            headerInput.isCompleted == null
                ? null
                : (headerInput.isCompleted! ? 1 : 0),
        "details":
            headerInput.details
                .map(
                  (detail) => {
                    "id":detail.id,
                    "filtration_cycle_number": detail.filtrationCycleNumber,
                    // "filtration_date": formatDatetoString(
                    //   detail.filtrationDate ?? DateTime.now(),
                    //   'yyyy-MM-dd',
                    // ),
                    "filtration_temp": detail.filtrationTemp,
                    "time_start_filtration": formatTimeOfDay(
                      detail.timeStartFiltration,
                      showSecond: false,
                    ),
                    "time_end_filtration": formatTimeOfDay(
                      detail.timeEndFiltration,
                      showSecond: false,
                    ),
                    "load": detail.load,
                    "olein_iv": detail.oleinIv,
                    "olein_cp": detail.oleinCp,
                    "olein_ffa": detail.oleinFfa,
                    "olein_color_red": detail.oleinColorRed,
                    "stearin_iv": detail.stearinIv,
                    "stearin_ffa": detail.stearinFfa,
                    "stearin_color_red": detail.stearinColorRed,
                    "stearin_pv": detail.stearinPv,
                  },
                )
                .toList(),
      };

      String token = await _storageService.readSessionToken() ?? '';

      final response = await _apiService.updateReport(
        'Bearer $token',
        body,
        headerInput.id,
      );

      if (response.success == true) {
        notifyListeners();
        return true;
      } else {
        // Jika server return 200 tapi success: false (jarang terjadi di REST standard, tapi jaga-jaga)
        _setErrorMessage(response.message ?? 'Insert report failed.');
        notifyListeners();
        return false;
      }
    } on DioException catch (e) {
      // --- MENANGKAP ERROR DARI API (400, 422, 500) ---

      String msg = 'Terjadi kesalahan jaringan.';

      if (e.response != null) {
        // Ambil data JSON error dari server
        final errorData = e.response?.data;

        // Cek apakah response berupa Map/JSON
        if (errorData is Map<String, dynamic>) {
          // Prioritas 1: Ambil key 'message' (Ini yang dikirim oleh Controller Laravel Anda)
          if (errorData.containsKey('message')) {
            msg = errorData['message'];
          }
          // Prioritas 2: Ambil key 'error' (Format error default lain)
          else if (errorData.containsKey('error')) {
            msg = errorData['error'];
          }

          // Opsi Tambahan: Jika ada validasi field spesifik (Laravel biasanya kirim key 'errors')
          // if (errorData.containsKey('errors')) {
          //   msg += "\nDetail: ${errorData['errors']}";
          // }
        } else {
          // Jika error body berupa string mentah
          msg = errorData.toString();
        }
      } else {
        // Error tanpa response (Timeout, No Internet)
        msg = e.message ?? 'Koneksi gagal.';
      }

      _setErrorMessage(msg);
      notifyListeners();
      return false;
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
