import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/auth/data/datasources/local/storage_service/storage_service.dart';
import 'package:logsheet_app/features/quality_control/data/datasources/remote/analytical_result_outgoing_shipment_product_by_vessel/analytical_result_outgoing_shipment_product_by_vessel_api_service.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_outgoing_shipment_product_by_truck/analytical_result_outgoing_shipment_product_by_truck_header_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_outgoing_shipment_product_by_vessel/analytical_result_outgoing_shipment_product_by_vessel_header_entity.dart';

class AnalyticalResultOutgoingShipmentProductByVesselProvider
    with ChangeNotifier {
  final AnalyticalResultOutgoingShipmentProductByVesselApiService _apiService;
  final StorageService _storageService;

  AnalyticalResultOutgoingShipmentProductByVesselProvider(
    this._apiService,
    this._storageService,
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

  List<AnalyticalResultOutgoingShipmentProductByVesselHeaderEntity>
  _reportList = [];
  List<AnalyticalResultOutgoingShipmentProductByVesselHeaderEntity>
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
    required AnalyticalResultOutgoingShipmentProductByVesselHeaderEntity
    headerInput,
  }) async {
    _setLoadingInput(true);

    try {
      final body = {
        "company": headerInput.company,
        "plant": headerInput.plant,
        "product_name": headerInput.productName ?? '',
        "sampling_date":
            formatDatetoString(
              headerInput.samplingDate,
              'yyy-MM-dd HH:mm:ss',
            ) ??
            '',
        "quantity": headerInput.quantity,
        "shipper": headerInput.shipper ?? '',
        "destination": headerInput.destination ?? '',
        "vessel_name": headerInput.vesselName ?? '',
        "hasil_analisa_ffa": headerInput.hasilAnalisaFfa,
        "hasil_analisa_iv": headerInput.hasilAnalisaIv,
        "hasil_analisa_moisture": headerInput.hasilAnalisaMoisture,
        "hasil_analisa_colour": headerInput.hasilAnalisaColorR,
        "hasil_analisa_pv": headerInput.hasilAnalisaPv,
        "hasil_analisa_smp": headerInput.hasilAnalisaSMP,
        "remark": headerInput.remark,
        "details":
            headerInput.details
                .map(
                  (detail) => {
                    "palka_s_palka": detail.palkaSPalka,
                    "palka_s_ffa": detail.palkaSFfa,
                    "palka_s_iv": detail.palkaSIv,
                    "palka_s_colour": detail.palkaSColour,
                    "palka_s_pv": detail.palkaSPv,
                    "palka_s_mni": detail.palkaSMni,
                    "palka_p_palka": detail.palkaPPalka,
                    "palka_p_ffa": detail.palkaPFfa,
                    "palka_p_iv": detail.palkaPIv,
                    "palka_p_colour": detail.palkaPColour,
                    "palka_p_pv": detail.palkaPPv,
                    "palka_p_mni": detail.palkaPMni,
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
    String? date, {
    String? role,
    bool isFilterBasedOnRole = false,
  }) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      String token = await _storageService.readSessionToken() ?? '';
      final response = await _apiService.fetchReports(
        'Bearer $token',
        date ?? '',
      );

      if (response.success == true) {
        final data = response.data;
        _reportList = data;

        log("report List Length: ${_reportList.length}");
        if (isFilterBasedOnRole == true && AppRoles.leadQC.contains(role)) {
          _reportList =
              _reportList.where((item) => item.preparedStatus == null).toList();
        } else if (isFilterBasedOnRole == true &&
            AppRoles.qualityControlManagerApproval.contains(role)) {
          _reportList =
              _reportList.where((item) => item.preparedStatus != null).toList();
        }
        log("report List Length: ${_reportList.length}");

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
    required AnalyticalResultOutgoingShipmentProductByVesselHeaderEntity
    headerInput,
  }) async {
    _setLoadingInput(true);

    try {
      final body = {
        "company": headerInput.company,
        "plant": headerInput.plant,
        "product_name": headerInput.productName ?? '',
        "sampling_date":
            formatDatetoString(
              headerInput.samplingDate,
              'yyy-MM-dd HH:mm:ss',
            ) ??
            '',
        "quantity": headerInput.quantity,
        "shipper": headerInput.shipper ?? '',
        "destination": headerInput.destination ?? '',
        "vessel_name": headerInput.vesselName ?? '',
        "hasil_analisa_ffa": headerInput.hasilAnalisaFfa,
        "hasil_analisa_iv": headerInput.hasilAnalisaIv,
        "hasil_analisa_moisture": headerInput.hasilAnalisaMoisture,
        "hasil_analisa_colour": headerInput.hasilAnalisaColorR,
        "hasil_analisa_pv": headerInput.hasilAnalisaPv,
        "hasil_analisa_smp": headerInput.hasilAnalisaSMP,
        "remark": headerInput.remark,
        "details":
            headerInput.details
                .map(
                  (detail) => {
                    "id": detail.id,
                    "palka_s_palka": detail.palkaSPalka,
                    "palka_s_ffa": detail.palkaSFfa,
                    "palka_s_iv": detail.palkaSIv,
                    "palka_s_colour": detail.palkaSColour,
                    "palka_s_pv": detail.palkaSPv,
                    "palka_s_mni": detail.palkaSMni,
                    "palka_p_palka": detail.palkaPPalka,
                    "palka_p_ffa": detail.palkaPFfa,
                    "palka_p_iv": detail.palkaPIv,
                    "palka_p_colour": detail.palkaPColour,
                    "palka_p_pv": detail.palkaPPv,
                    "palka_p_mni": detail.palkaPMni,
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

  Future<bool> updateApproveRejectReport({
    required String id,
    // required String role,
    required String status,
    required String remarks,
  }) async {
    _setLoadingEdit(true);
    _setErrorMessage(null);
    try {
      final body = {"id": id, "status": status, "remarks": remarks};

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
