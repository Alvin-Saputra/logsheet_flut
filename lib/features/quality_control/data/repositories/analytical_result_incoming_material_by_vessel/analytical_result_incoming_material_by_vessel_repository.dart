import 'dart:developer';

import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_detail_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_header_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_report_entity.dart';
import 'package:logsheet_app/features/quality_control/data/datasources/local/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_mysql_service.dart';

class AnalyticalResultIncomingMaterialByVesselRepository {
  final AnalyticalResultIncomingMaterialByVesselMySQLService _mySQLService;

  AnalyticalResultIncomingMaterialByVesselRepository(this._mySQLService);

  Future<bool> insertAnalyticalResultIncomingMaterialByVessel({
    required AnalyticalResultIncomingMaterialByVesselHeaderEntity header,
    required List<AnalyticalResultIncomingMaterialByVesselDetailEntity> details,
  }) async {
    return await _mySQLService.insertAnalyticalResultIncomingMaterialByVessel(
      header: header,
      details: details,
    );
  }

  Future<String?> getLatestId(String plantCode) async {
    return await _mySQLService.getLatestId(plantCode);
  }

  Future<bool> updateAutoNumber(String plantCode, int newAutoNumber) async {
    return await _mySQLService.updateAutoNumber(plantCode, newAutoNumber);
  }

  Future<List<AnalyticalResultIncomingMaterialByVesselReportEntity>>
  getAllAnalyticalResultIncomingMaterialByVessel(String date, String role) async {
    final List<Map<String, dynamic>> reportsData = await _mySQLService
        .getAllAnalyticalResultIncomingMaterialByVessel(date, role);

    log('converting to list...');
    log(reportsData.first.toString());
    final List<AnalyticalResultIncomingMaterialByVesselReportEntity> mapToList =
        reportsData
            .map(
              (maps) =>
                  AnalyticalResultIncomingMaterialByVesselReportEntity.fromMap(maps),
            )
            .toList();

    log('converted ${mapToList.length.toString()}');

    return mapToList;
  }
}
