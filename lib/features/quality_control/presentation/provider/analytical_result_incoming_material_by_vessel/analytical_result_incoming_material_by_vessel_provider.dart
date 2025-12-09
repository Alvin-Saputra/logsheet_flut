import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/features/auth/data/datasources/local/storage_service/storage_service.dart';
import 'package:logsheet_app/features/quality_control/data/datasources/remote/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_api_service.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_detail_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_header_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_report_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_header_model.dart';
import 'package:logsheet_app/features/quality_control/data/model/remote/analytical_result_incoming_material_by_vessel/fetch_analytical_result_incoming_material_by_vessel_response.dart';
import 'package:logsheet_app/features/quality_control/data/repositories/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_repository.dart';

class AnalyticalResultIncomingMaterialByVesselProvider with ChangeNotifier {
  final AnalyticalResultIncomingMaterialByVesselRepository _repository;
  final AnalyticalResultIncomingMaterialByVesselApiService _apiService;
  final StorageService _storageService;

  AnalyticalResultIncomingMaterialByVesselProvider(
    this._repository,
    this._storageService,
    this._apiService,
  );

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

  List<AnalyticalResultIncomingMaterialByVesselReportEntity> _reportList = [];
  List<AnalyticalResultIncomingMaterialByVesselReportEntity> get reportList =>
      _reportList;

  List<AnalyticalResultIncomingMaterialByVesselHeaderEntity>
  _reportListFromApi = [];
  List<AnalyticalResultIncomingMaterialByVesselHeaderEntity>
  get reportListFromApi => _reportListFromApi;

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
      final response = await _apiService.fetchReports(
        'Bearer $token',
        plantId,
        date ?? '',
      );

      if (response != null && response.success == true) {
        final data = response.data;
        _reportListFromApi = data;

        if (purpose == "list" && AppRoles.leadQC.contains(role)) {
          _reportListFromApi =
              _reportListFromApi
                  .where(
                    (item) => item.flag == 'T' && item.preparedStatus == null,
                  )
                  .toList();
        } else {
          _reportListFromApi =
              _reportListFromApi.where((item) => item.flag == 'T').toList();
        }

        notifyListeners();
      } else {
        _setErrorMessage('Fetch report failed.');
      }
      notifyListeners();
    } catch (e) {
      _setErrorMessage("$e");
      notifyListeners();
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<bool> insertReport({
    required AnalyticalResultIncomingMaterialByVesselHeaderEntity headerInput,
    required String menudId,
  }) async {
    _setLoadingInput(true);

    try {
      final body = {
        "menu_id": menudId,
        "company": headerInput.company,
        "plant": headerInput.plant,
        "arrival": DateFormat(
          'yyyy-MM-dd HH:mm:ss',
        ).format(headerInput.arrival!),
        "material": headerInput.material,
        "quantity": headerInput.quantity.toString(),
        "supplier": headerInput.supplier,
        "ship_name": headerInput.shipName,
        "contract_do_nomor": headerInput.contractDoNomor,
        "hasil_analisa_ffa": headerInput.hasilAnalisaFfa.toString(),
        "hasil_analisa_iv": headerInput.hasilAnalisaIv.toString(),
        "hasil_analisa_moisture": headerInput.hasilAnalisaMoisture.toString(),
        "hasil_analisa_dobi": headerInput.hasilAnalisaDobi.toString(),
        "hasil_analisa_pv": headerInput.hasilAnalisaPv.toString(),
        "hasil_analisa_anv": headerInput.hasilAnalisaAnv.toString(),
        "ffa": headerInput.ffa.toString(),
        "mni": headerInput.mni.toString(),
        "dobi": headerInput.dobi.toString(),
        "others": headerInput.others,
        "remarks": headerInput.remarks,
        "detail":
            headerInput.details
                .map(
                  (detail) => {
                    "palka_s_no": detail.palkaSNo.toString(),
                    "palka_s_ffa": detail.palkaSFfa.toString(),
                    "palka_s_iv": detail.palkaSIv.toString(),
                    "palka_s_dobi": detail.palkaSDobi.toString(),
                    "palka_s_mni": detail.palkaSMni.toString(),
                    "palka_c_no": detail.palkaCNo.toString(),
                    "palka_c_ffa": detail.palkaCFfa.toString(),
                    "palka_c_iv": detail.palkaCIv.toString(),
                    "palka_c_dobi": detail.palkaCDobi.toString(),
                    "palka_c_mni": detail.palkaCMni.toString(),
                    "palka_p_no": detail.palkaPNo.toString(),
                    "palka_p_ffa": detail.palkaPFfa.toString(),
                    "palka_p_iv": detail.palkaPIv.toString(),
                    "palka_p_dobi": detail.palkaPDobi.toString(),
                    "palka_p_mni": detail.palkaPMni.toString(),
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
    required AnalyticalResultIncomingMaterialByVesselHeaderEntity headerInput,
    required String menudId,
  }) async {
    _setLoadingInput(true);

    try {
      final body = {
        "id": headerInput.id,
        "material": headerInput.material,
        "quantity": headerInput.quantity.toString(),
        "supplier": headerInput.supplier,
        "ship_name": headerInput.shipName,
        "hasil_analisa_ffa": headerInput.hasilAnalisaFfa.toString(),
        "hasil_analisa_iv": headerInput.hasilAnalisaIv.toString(),
        "hasil_analisa_moisture": headerInput.hasilAnalisaMoisture.toString(),
        "hasil_analisa_dobi": headerInput.hasilAnalisaDobi.toString(),
        "hasil_analisa_pv": headerInput.hasilAnalisaPv.toString(),
        "hasil_analisa_anv": headerInput.hasilAnalisaAnv.toString(),
        "ffa": headerInput.ffa.toString(),
        "mni": headerInput.mni.toString(),
        "dobi": headerInput.dobi.toString(),
        "others": headerInput.others,
        "remarks": headerInput.remarks,
        "detail":
            headerInput.details
                .map(
                  (detail) => {
                    "id": detail.id,
                    "palka_s_no": detail.palkaSNo.toString(),
                    "palka_s_ffa": detail.palkaSFfa.toString(),
                    "palka_s_iv": detail.palkaSIv.toString(),
                    "palka_s_dobi": detail.palkaSDobi.toString(),
                    "palka_s_mni": detail.palkaSMni.toString(),
                    "palka_c_no": detail.palkaCNo.toString(),
                    "palka_c_ffa": detail.palkaCFfa.toString(),
                    "palka_c_iv": detail.palkaCIv.toString(),
                    "palka_c_dobi": detail.palkaCDobi.toString(),
                    "palka_c_mni": detail.palkaCMni.toString(),
                    "palka_p_no": detail.palkaPNo.toString(),
                    "palka_p_ffa": detail.palkaPFfa.toString(),
                    "palka_p_iv": detail.palkaPIv.toString(),
                    "palka_p_dobi": detail.palkaPDobi.toString(),
                    "palka_p_mni": detail.palkaPMni.toString(),
                  },
                )
                .toList(),
      };

      String token = await _storageService.readSessionToken() ?? '';

      final response = await _apiService.updateReport('Bearer $token', body);

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

  Future<bool> updateApproveRejectReport({
    required String id,
    required String userName,
    // required String role,
    required String status,
    required String remarks,
  }) async {
    _setLoadingEdit(true);
    _setErrorMessage(null);
    try {
      final body = {
        "id": id,
        "username": userName,
        // "role": role,
        "approve_status": status,
        "remark": remarks,
      };

      String token = await _storageService.readSessionToken() ?? '';
      final response = await _apiService.updateApproveRejectReport(
        'Bearer $token',
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
    _reportListFromApi.clear();
  }
}
