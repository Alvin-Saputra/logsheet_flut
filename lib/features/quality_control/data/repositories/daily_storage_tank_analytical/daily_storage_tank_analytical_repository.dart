import 'dart:developer';

import 'package:logsheet_app/features/quality_control/data/model/local/daily_storage_tank_analytical/daily_storage_tank_analytical_from_db_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/daily_storage_tank_analytical/daily_storage_tank_analytical_to_db_entity.dart';
import 'package:logsheet_app/features/quality_control/data/datasources/local/daily_storage_tank_analytical/daily_storage_tank_analytical_mysql_service.dart';

class DailyStorageTankAnalyticalRepository {
  final DailyStorageTankAnalyticalMySQLService _mySQLService;

  DailyStorageTankAnalyticalRepository(this._mySQLService);

  Future<bool> insertDailyStorageTankAnalytical({
    required DailyStorageTankAnalyticalToDbEntity report,
  }) async {
    return await _mySQLService.insertDailyStorageTankAnalytical(report: report);
  }

  Future<bool> updateAutoNumber(String plantCode, int newAutoNumber) async {
    return await _mySQLService.updateAutoNumber(plantCode, newAutoNumber);
  }

  Future<String?> getLatestId(String plantCode) async {
    return await _mySQLService.getLatestId(plantCode);
  }

  Future<List<DailyStorageTankAnalyticalFromDbEntity>> getAllDailyStorageTankReport(
    String date,
    String role,
    String plantcode,
  ) async {
    final List<Map<String, dynamic>> reportsData = await _mySQLService
        .getAllDailyStorageTankReport(date, role, plantcode);

    log('converting to list...');

    final List<DailyStorageTankAnalyticalFromDbEntity> mapToList = [];

    for (final maps in reportsData) {
      try {
        log("Converting: $maps");
        final entity = DailyStorageTankAnalyticalFromDbEntity.fromMap(maps);
        mapToList.add(entity);
      } catch (e, st) {
        log("❌ Error converting map: $e\n$st");
      }
    }

    log('converted ${mapToList.length}');
    return mapToList;
  }

    Future<bool> deleteDailyStorageTankAnalyticalReport(String id) async {
    return await _mySQLService.deleteDailyStorageTankAnalyticalReport(id);
  }

  Future<bool> updatedeleteDailyStorageTankAnalyticalReport(DailyStorageTankAnalyticalToDbEntity entity, String id) async {
    return await _mySQLService.updateDailyStorageTankAnalyticalReport(report: entity, id: id);
  }

  
  Future<bool> updateApproveRejectToHeader({
    required String id,
    required String approvedBy,
    required String status,
    required String role,
    String? remarks,
  }) async {
    return await _mySQLService.updateApproveRejectToHeader(
      id: id,
      approvedBy: approvedBy,
      status: status,
      role: role,
      remarks: remarks,
    );
  }


  Future<List<DailyStorageTankAnalyticalFromDbEntity>> getAllDailyStorageTankApproval(
  String? plantCode) async {
    final List<Map<String, dynamic>> reportsData = await _mySQLService
        .getAllDailyStorageTankApproval(plantCode);

    log('converting to list...');

    final List<DailyStorageTankAnalyticalFromDbEntity> mapToList = [];

    for (final maps in reportsData) {
      try {
        log("Converting: $maps");
        final entity = DailyStorageTankAnalyticalFromDbEntity.fromMap(maps);
        mapToList.add(entity);
      } catch (e, st) {
        log("❌ Error converting map: $e\n$st");
      }
    }

    log('converted ${mapToList.length}');
    return mapToList;
  }

}
