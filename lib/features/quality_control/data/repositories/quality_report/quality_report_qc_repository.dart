import 'dart:developer';

import 'package:logsheet_app/features/daily_production/data/model/daily_production/daily_production_refinery_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/quality_refinery/quality_report_qc_entity.dart';
import 'package:logsheet_app/features/transactions/report_notification_data_entity.dart';
import 'package:logsheet_app/features/quality_control/data/datasources/local/quality_report/quality_report_qc_mysql_service.dart';

class QualityReportQCRepository {
  final QualityReportQCMySQLService _mySQLService;

  QualityReportQCRepository(this._mySQLService);

  // Insert Quality Refinery Report
  Future<bool> insert(QualityReportQcEntity entity) async {
    return await _mySQLService.insertTicket(entity);
  }

  Future<bool> deleteTicket(String id, String username) async {
    return await _mySQLService.deleteTicket(id, username);
  }

  // Fetch all Quality Refinery Report
  Future<List<QualityReportQcEntity>> getAllTickets(
    DateTime? dateFilter,
    String? time,
    String username,
    String role,
    String plantCode,
  ) async {
    final List<Map<String, dynamic>> reportsData = await _mySQLService
        .getAllTickets(dateFilter, time, username, role, plantCode);

    log(reportsData.length.toString());

    log('converting to list...');

    final List<QualityReportQcEntity> mapToList =
        reportsData.map((maps) => QualityReportQcEntity.fromMap(maps)).toList();

    log('converted ${mapToList.length.toString()}');

    return mapToList;
  }

  Future<String?> getLatestTicketId(String plantCode) async {
    return await _mySQLService.getLatestTicketId(plantCode);
  }

  Future<bool> updateAutoNumber(String plantCode, int newAutoNumber) async {
    return await _mySQLService.updateAutoNumber(plantCode, newAutoNumber);
  }

  Future<bool> updateReportTicket(
    QualityReportQcEntity report,
    String role,
  ) async {
    return await _mySQLService.updateTicket(report, role);
  }

  Future<List<QualityReportQcEntity>> getReportsForManager(
    String plantCode,
  ) async {
    final List<Map<String, dynamic>> reportsData = await _mySQLService
        .getReportsForManager(plantCode);

    log('converting to list...');
    return reportsData
        .map((maps) => QualityReportQcEntity.fromMap(maps))
        .toList();
  }

  Future<bool> sendApproveRejectTicket(
    String username,
    String status,
    String userRole,
    int shift,
    String? remark,
    String id,
  ) async {
    return await _mySQLService.sendApproveRejectTicket(
      username,
      status,
      userRole,
      shift,
      remark,
      id,
    );
  }

  Future<bool> sendApproveRejectTicketPerDate(
    final String username,
    final String status,
    final String userRole,
    final int shift,
    final String transactionDate,
    final String plant,
    final String workCenter,
    final String? remark,
  ) async {
    return await _mySQLService.sendApproveRejectTicketPerDate(
      username,
      status,
      userRole,
      shift,
      transactionDate,
      plant,
      workCenter,
      remark ?? '',
    );
  }

  Future<List<int>> getReportedHours(
    DateTime dateFilter,
    String plantCode,
  ) async {
    return await _mySQLService.getReportedHours(dateFilter, plantCode);
  }

  Future<List<ReportNotificationDataEntity>>
  getReadyForManagerApprovalReports() async {
    log("In the Repository calling the mysql service");
    final List<Map<String, dynamic>> reportData =
        await _mySQLService.getReadyForManagerApprovalReports();
    log("Done calling the mysql service, list length is ${reportData.length}");
    return reportData
        .map((maps) => ReportNotificationDataEntity.fromMap(maps))
        .toList();
  }

  Future<List<QualityReportQcEntity>> getFilteredTickets(
    DateTime? dateFilter,
    String plantCode,
    String? shift,
  ) async {
    final List<Map<String, dynamic>> filteredTicketList = await _mySQLService
        .getTickets(dateFilter, plantCode, shift: shift);

    List<QualityReportQcEntity> filteredTicketListFromMap =
        filteredTicketList
            .map((map) => QualityReportQcEntity.fromMap(map))
            .toList();

    return filteredTicketListFromMap;
  }

  Future<List<DailyProductionRefineryEntity>>
  getDailyProductionRefineryByFilter({
    DateTime? transactionDate,
    required String plantCode,
    int? shift,
    String? workCenter,
  }
  ) async {
    final List<Map<String, dynamic>> filteredTicketList = await _mySQLService
        .getDailyProductionRefineryByFilter(
          plantCode: plantCode,
          transactionDate: transactionDate,
          shift: shift,
          workCenter: workCenter,
        );

    List<DailyProductionRefineryEntity> filteredTicketListFromMap =
        filteredTicketList
            .map((map) => DailyProductionRefineryEntity.fromMap(map))
            .toList();

    return filteredTicketListFromMap;
  }
}
