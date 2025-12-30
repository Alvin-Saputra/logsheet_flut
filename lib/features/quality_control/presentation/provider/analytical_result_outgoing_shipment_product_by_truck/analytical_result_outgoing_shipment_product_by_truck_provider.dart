import 'package:flutter/foundation.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/auth/data/datasources/local/storage_service/storage_service.dart';
import 'package:logsheet_app/features/quality_control/data/datasources/remote/analytical_result_outgoing_shipment_product_by_truck/analytical_result_outgoing_shipment_product_by_truck_api_service.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_truck/analytical_result_incoming_material_by_truck_header_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_outgoing_shipment_product_by_truck/analytical_result_outgoing_shipment_product_by_truck_header_entity.dart';

class AnalyticalResultOutgoingShipmentProductByTruckProvider
    with ChangeNotifier {
  final AnalyticalResultOutgoingShipmentProductByTruckApiService _apiService;
  final StorageService _storageService;

  AnalyticalResultOutgoingShipmentProductByTruckProvider(
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

  List<AnalyticalResultIncomingMaterialByTruckHeaderEntity> _reportList = [];
  List<AnalyticalResultIncomingMaterialByTruckHeaderEntity> get reportList =>
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
    required AnalyticalResultOutgoingShipmentProductByTruckHeaderEntity
    headerInput,
  }) async {
    _setLoadingInput(true);

    try {
      final body = {
        "loading_date":
            formatDatetoString(headerInput.loadingDate, 'yyy-MM-dd HH:mm:ss') ??
            '',
        "product_name": headerInput.productName,
        "quantity": (headerInput.quantity ?? 0).toString(),
        "ships_name": headerInput.shipsName ?? '',
        "destination": headerInput.destination,
        "load_port": headerInput.loadPort,
        "details":
            headerInput.details
                .map(
                  (detail) => {
                    "ships_tank": detail.shipsTank ?? '',
                    "no_police": detail.shipsTank ?? '',
                    "ffa": detail.ffa ?? '',
                    "m_and_i": detail.mni ?? 0,
                    "iv": detail.iv ?? 0,
                    "lovibond_color_red": detail.lovibondColorRed ?? 0,
                    "lovibond_color_yellow": detail.lovibondColorYellow ?? 0,
                    "pv": detail.pv ?? 0,
                    "other": detail.other ?? '',
                    "remarks": detail.remark,
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

  // Future<void> fetchReport(
  //   String plantId,
  //   String? date, {
  //   String? role,
  //   String? purpose,
  // }) async {
  //   _setLoading(true);
  //   _setErrorMessage(null);

  //   try {
  //     String token = await _storageService.readSessionToken() ?? '';
  //     final response = await _apiService.fetchReports(
  //       'Bearer $token',
  //       plantId,
  //       date ?? '',
  //     );

  //     if (response != null && response.success == true) {
  //       final data = response.data;
  //       _reportList = data;

  //       if (purpose == "list" && AppRoles.leadQC.contains(role)) {
  //         _reportList =
  //             _reportList
  //                 .where(
  //                   (item) => item.flag == 'T' && item.preparedStatus == null,
  //                 )
  //                 .toList();
  //       } else {
  //         _reportList = _reportList.where((item) => item.flag == 'T').toList();
  //       }

  //       notifyListeners();
  //     } else {
  //       _setErrorMessage('Fetch report failed.');
  //     }
  //     notifyListeners();
  //   } catch (e) {
  //     _setErrorMessage("$e");
  //     notifyListeners();
  //   } finally {
  //     _setLoading(false);
  //     notifyListeners();
  //   }
  // }

  // Future<bool> deleteReport({required String id}) async {
  //   _setLoadingDelete(true);
  //   _setErrorMessage(null);

  //   try {
  //     String token = await _storageService.readSessionToken() ?? '';
  //     final response = await _apiService.deleteReport('Bearer $token', id);

  //     if (response != null && response.success == true) {
  //       notifyListeners();
  //       return true;
  //     } else {
  //       _setErrorMessage('Delete Report Failed');
  //       notifyListeners();
  //       return false;
  //     }
  //   } catch (e) {
  //     _setErrorMessage("$e");
  //     notifyListeners();
  //     return false;
  //   } finally {
  //     _setLoadingDelete(false);
  //     notifyListeners();
  //   }
  // }

  // Future<bool> updateReport({
  //   required AnalyticalResultIncomingMaterialByTruckHeaderEntity headerInput,
  //   required String menuId,
  // }) async {
  //   _setLoadingInput(true);

  //   try {
  //     final body = {
  //       "id": headerInput.id,
  //       "material": headerInput.material,
  //       "arrival_date": formatDatetoString(
  //         headerInput.arrival ?? DateTime.now(),
  //         'yyy-MM-dd HH:mm:ss',
  //       ),
  //       "contract_do": headerInput.contractDoNomor,
  //       "supplier": headerInput.supplier,
  //       "vessel_vehicle": headerInput.vesselVehicle,
  //       "ss_ffa": headerInput.ssFfa.toString(),
  //       "ss_mni": headerInput.ssMni.toString(),
  //       "ss_others": headerInput.ssOthers.toString(),
  //       "detail":
  //           headerInput.details
  //               .map(
  //                 (detail) => {
  //                   "id": detail.id,
  //                   "no": detail.no,
  //                   "sampling_date": formatDatetoString(
  //                     detail.samplingDate ?? DateTime.now(),
  //                     'yyy-MM-dd HH:mm:ss',
  //                   ),
  //                   "police_no": detail.policeNo,
  //                   "p_ffa": detail.pFfa.toString(),
  //                   "p_moisture": detail.pMoisture.toString(),
  //                   "p_iv": detail.pIv.toString(),
  //                   "p_dobi": detail.pDobi.toString(),
  //                   "p_pv": detail.pPv.toString(),
  //                   "p_color_r": detail.pColorR.toString(),
  //                   "p_color_y": detail.pColorY.toString(),
  //                   "analis": detail.analis,
  //                   "remarks": detail.remarks,
  //                 },
  //               )
  //               .toList(),
  //     };

  //     String token = await _storageService.readSessionToken() ?? '';

  //     final response = await _apiService.updateReport('Bearer $token', body);

  //     if (response != null && response.success == true) {
  //       notifyListeners();
  //       return true;
  //     } else {
  //       _setErrorMessage('Update report failed.');
  //       notifyListeners();
  //       return false;
  //     }
  //   } catch (e) {
  //     _setErrorMessage(e.toString());
  //     notifyListeners();
  //     return false;
  //   } finally {
  //     _setLoadingInput(false);
  //     notifyListeners();
  //   }
  // }

  // Future<bool> updateApproveRejectReport({
  //   required String id,
  //   // required String role,
  //   required String status,
  //   required String remarks,
  // }) async {
  //   _setLoadingEdit(true);
  //   _setErrorMessage(null);
  //   try {
  //     final body = {"id": id, "approve_status": status, "remark": remarks};

  //     String token = await _storageService.readSessionToken() ?? '';
  //     final response = await _apiService.updateApproveRejectReport(
  //       'Bearer $token',
  //       body,
  //     );

  //     if (response != null && response.success == true) {
  //       notifyListeners();
  //       return true;
  //     } else {
  //       _setErrorMessage('Update Approve/Reject Report Failed');
  //       notifyListeners();
  //       return false;
  //     }
  //   } catch (e) {
  //     _setErrorMessage(e.toString());
  //     notifyListeners();
  //     return false;
  //   } finally {
  //     _setLoadingEdit(false);
  //     notifyListeners();
  //   }
  // }

  void clearReports() {
    _reportList.clear();
  }
}
