import 'dart:async';
import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:logsheet_app/core/database/mysql/mysql_client.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/quality_refinery/quality_report_qc_entity.dart';
import 'package:mysql_client/mysql_client.dart';

class QualityReportQCMySQLService {
  Future<bool> insertTicket(QualityReportQcEntity entity) async {
    MySQLConnection? connection;
    try {
      var connResult = await getMySQLConnection();
      await closeMySQLConnection(connection);
      log("closed? ${connResult.connection?.connected}");
      connResult = await getMySQLConnection();

      if (connResult.connection == null) {
        log(
          '(Quality Report QC MySQL) Failed to get MySQL connection for insert ticket.',
        );
        return false;
      }

      connection = connResult.connection;

      List<String> columns = [];
      List<String> params = [];
      final Map<String, dynamic> entityData = entity.toMap();
      final Map<String, dynamic> sqlExecuteParams = {};

      entityData.forEach((keyInEntityMap, value) {
        String actualDbColumnName = keyInEntityMap;
        String safeParameterName = keyInEntityMap;
        dynamic formattedValue = value;

        if (keyInEntityMap == 'transaction_date' ||
            keyInEntityMap == 'posting_date' ||
            keyInEntityMap == 'entry_date') {
          if (value != null && value is DateTime) {
            formattedValue = DateFormat('yyyy-MM-dd HH:mm:ss').format(value);
          }
        }

        if (keyInEntityMap == 'rm_mni') {
          actualDbColumnName = 'rm_m&i';
          safeParameterName = 'rm_mni_param';
        } else if (keyInEntityMap == 'fg_mni') {
          actualDbColumnName = 'fg_m&i';
          safeParameterName = 'fg_mni_param';
        } else if (keyInEntityMap == 'bp_mni') {
          actualDbColumnName = 'bp_m&i';
          safeParameterName = 'bp_mni_param';
        } else if (keyInEntityMap == 'wsbeqc') {
          actualDbColumnName = 'w_sbe_qc';
          safeParameterName = 'w_sbe_qc_param';
        } else if (keyInEntityMap == 'w_sbe_mni') {
          actualDbColumnName = 'w_sbe_m&i';
          safeParameterName = 'w_sbe_mni_param';
        } else if (keyInEntityMap == 'w_sbe_m&i') {
          actualDbColumnName = 'w_sbe_m&i';
          safeParameterName = 'w_sbe_mni_param';
        }

        columns.add('`$actualDbColumnName`');
        params.add(':$safeParameterName');
        sqlExecuteParams[safeParameterName] = formattedValue;
      });

      final String sql =
          'INSERT INTO t_quality_report_qc (${columns.join(', ')}) VALUES (${params.join(', ')})';

      // final String sql =
      //     'INSERT INTO t_quality_report_refinery_2 (`id`) VALUES ("QRMPS2125000108")';

      log('Generated SQL: $sql');
      log('Data for SQL: $sqlExecuteParams');
      log(
        connection!.connected
            ? "Connected to the database"
            : "Not Connected to the database",
      );

      final result = await connection.execute(sql, sqlExecuteParams);

      // connResult.connection?.close();

      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error inserting Quality Report Refinery Report: $e');
      return false;
    } finally {
      try {
        await closeMySQLConnection(connection);
        log("Is still connected: ${connection?.connected}");
      } catch (e) {
        log('Error closing connection: $e');
      }
    }
  }

  Future<List<Map<String, dynamic>>> getAllTickets(
    DateTime? dateFilter,
    String? time,
    String username,
    String role,
    String plantCode,
  ) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all reports.');
        return [];
      }
      connection = connResult.connection;
      String baseQuery;
      final Map<String, dynamic> params = {};

      const String dailyProductionColumns = """
      a.daily_production_refinery_id,
      c.be_ref_tank,
      c.be_ref_qty,
      c.be_total_bag,
      c.be_total_jenis,
      c.be_lot_batch_number,
      c.be_yield_percent,
      c.pa_ref_tank,
      c.pa_ref_qty,
      c.pa_total,
      c.pa_lot_batch_number,
      c.pa_yield_percent,
      c.uu_item,
      c.uu_budget_ref_tank,
      c.uu_budget_qty,
      c.uu_total_cpo,
      c.uu_total_steam,
      c.uu_steam_cpo,
      c.uu_yield_percent
    """;

      switch (role) {
        case 'LEAD' || 'LEAD_QC':
          baseQuery = """
          SELECT
            a.id,
            a.company,
            a.plant,
            a.transaction_date,
            a.posting_date,
            a.work_center,
            a.oil_type AS oil_type_id,
            b.raw_material AS oil_type,
            a.`time`,
            a.shift,
            a.rm_flowrate,
            a.rm_tank_source,
            a.rm_temp,
            a.rm_ffa,
            a.rm_iv,
            a.rm_dobi,
            a.rm_av,
            a.`rm_m&i`,
            a.rm_pv,
            a.rm_totox,
            a.rm_color_r,
            a.rm_color_y,
            a.rm_color_b,
            a.bo_color_r,
            a.bo_color_y,
            a.bo_color_b,
            a.bo_break_test,
            a.fg_ffa,
            a.fg_iv,
            a.fg_pv,
            a.fg_moisture,
            a.fg_impurities,
            a.fg_color_r,
            a.fg_color_y,
            a.fg_color_b,
            a.fg_tank_to,
            a.fg_tank_to_others_remarks,
            a.bp_ffa,
            a.`bp_m&i`,
            a.bp_to_tank,
            a.`w_sbe_m&i`,
            a.w_sbe_qc,
            a.remarks,
            a.flag,
            a.entry_by,
            a.entry_date,
            a.prepared_by,
            a.prepared_date,
            a.prepared_status,
            a.prepared_status_remarks,
            a.checked_by,
            a.checked_date,
            a.checked_status,
            a.checked_status_remarks,
            a.updated_by,
            a.updated_date,
            a.form_no,
            a.date_issued,
            a.revision_no,
            a.revision_date,
            $dailyProductionColumns
          FROM
            t_quality_report_qc AS a
          JOIN 
            m_product AS b
          ON 
            a.oil_type = b.id
          LEFT JOIN t_daily_production_refinery AS c ON a.daily_production_refinery_id = c.id
          WHERE
             a.plant = :plantCode AND (a.flag IS NULL OR a.flag = 'T') AND a.prepared_status IS NULL AND a.checked_status IS NULL
        """;
          params["plantCode"] = plantCode;
          break;
        case 'OPR' || 'OPR_QC':
          baseQuery = """
          SELECT
            a.id,
            a.company,
            a.plant,
            a.transaction_date,
            a.posting_date,
            a.work_center,
            a.oil_type AS oil_type_id,
            b.raw_material AS oil_type,
            a.`time`,
            a.shift,
            a.rm_flowrate,
            a.rm_tank_source,
            a.rm_temp,
            a.rm_ffa,
            a.rm_iv,
            a.rm_dobi,
            a.rm_av,
            a.`rm_m&i`,
            a.rm_pv,
            a.rm_totox,
            a.rm_color_r,
            a.rm_color_y,
            a.rm_color_b,
            a.bo_color_r,
            a.bo_color_y,
            a.bo_color_b,
            a.bo_break_test,
            a.fg_ffa,
            a.fg_iv,
            a.fg_pv,
            a.fg_moisture,
            a.fg_impurities,
            a.fg_color_r,
            a.fg_color_y,
            a.fg_color_b,
            a.fg_tank_to,
            a.fg_tank_to_others_remarks,
            a.bp_ffa,
            a.`bp_m&i`,
            a.bp_to_tank,
            a.`w_sbe_m&i`,
            a.w_sbe_qc,
            a.remarks,
            a.entry_by,
            a.entry_date,
            a.prepared_by,
            a.prepared_date,
            a.prepared_status,
            a.prepared_status_remarks,
            a.checked_by,
            a.checked_date,
            a.checked_status,
            a.checked_status_remarks,
            a.updated_by,
            a.updated_date,
            a.form_no,
            a.date_issued,
            a.revision_no,
            a.revision_date,
            $dailyProductionColumns
          FROM
            t_quality_report_qc AS a
          JOIN 
            m_product AS b
          ON 
            a.oil_type = b.id
          LEFT JOIN t_daily_production_refinery AS c ON a.daily_production_refinery_id = c.id

          WHERE
             a.plant = :plantCode AND (a.flag IS NULL OR a.flag = 'T')
        """;

          params["plantCode"] = plantCode;
          break;

        case 'MGR' || 'MGR_QC':
          baseQuery = """
          SELECT
            a.id,
            a.company,
            a.plant,
            a.transaction_date,
            a.posting_date,
            a.work_center,
            a.oil_type AS oil_type_id,
            b.raw_material AS oil_type,
            a.`time`,
            a.shift,
            a.rm_flowrate,
            a.rm_tank_source,
            a.rm_temp,
            a.rm_ffa,
            a.rm_iv,
            a.rm_dobi,
            a.rm_av,
            a.`rm_m&i`,
            a.rm_pv,
            a.rm_totox,
            a.rm_color_r,
            a.rm_color_y,
            a.rm_color_b,
            a.bo_color_r,
            a.bo_color_y,
            a.bo_color_b,
            a.bo_break_test,
            a.fg_ffa,
            a.fg_iv,
            a.fg_pv,
            a.fg_moisture,
            a.fg_impurities,
            a.fg_color_r,
            a.fg_color_y,
            a.fg_color_b,
            a.fg_tank_to,
            a.fg_tank_to_others_remarks,
            a.bp_ffa,
            a.`bp_m&i`,
            a.bp_to_tank,
            a.`w_sbe_m&i`,
            a.w_sbe_qc,
            a.remarks,
            a.flag,
            a.entry_by,
            a.entry_date,
            a.prepared_by,
            a.prepared_date,
            a.prepared_status,
            a.prepared_status_remarks,
            a.checked_by,
            a.checked_date,
            a.checked_status,
            a.checked_status_remarks,
            a.updated_by,
            a.updated_date,
            a.form_no,
            a.date_issued,
            a.revision_no,
            a.revision_date,
            $dailyProductionColumns
          FROM
            t_quality_report_qc AS a
          JOIN 
            m_product AS b
          ON 
            a.oil_type = b.id
            LEFT JOIN t_daily_production_refinery AS c ON a.daily_production_refinery_id = c.id
          WHERE
             a.plant = :plantCode AND (a.flag IS NULL OR a.flag = 'T')
        """;
          params["status"] = "Approved";
          params["plantCode"] = plantCode;
          break;
        case 'ADM':
          // Query for Admin: Can see all reports.
          baseQuery = """
          SELECT
            a.id,
            a.company,
            a.plant,
            a.transaction_date,
            a.posting_date,
            a.work_center,
            a.oil_type AS oil_type_id,
            b.raw_material AS oil_type,
            a.`time`,
            a.shift,
            a.rm_flowrate,
            a.rm_tank_source,
            a.rm_temp,
            a.rm_ffa,
            a.rm_iv,
            a.rm_dobi,
            a.rm_av,
            a.`rm_m&i`,
            a.rm_pv,
            a.rm_totox,
            a.rm_color_r,
            a.rm_color_y,
            a.rm_color_b,
            a.bo_color_r,
            a.bo_color_y,
            a.bo_color_b,
            a.bo_break_test,
            a.fg_ffa,
            a.fg_iv,
            a.fg_pv,
            a.fg_moisture,
            a.fg_impurities,
            a.fg_color_r,
            a.fg_color_y,
            a.fg_color_b,
            a.fg_tank_to,
            a.fg_tank_to_others_remarks,
            a.bp_ffa,
            a.`bp_m&i`,
            a.bp_to_tank,
            a.`w_sbe_m&i`,
            a.w_sbe_qc,
            a.remarks,
            a.entry_by,
            a.entry_date,
            a.prepared_by,
            a.prepared_date,
            a.prepared_status,
            a.prepared_status_remarks,
            a.checked_by,
            a.checked_date,
            a.checked_status,
            a.checked_status_remarks,
            a.updated_by,
            a.updated_date,
            a.form_no,
            a.date_issued,
            a.revision_no,
            a.revision_date,
            $dailyProductionColumns
          FROM
            t_quality_report_qc AS a
          JOIN 
            m_product AS b
          ON 
            a.oil_type = b.id
            LEFT JOIN t_daily_production_refinery AS c ON a.daily_production_refinery_id = c.id

          WHERE
             a.plant = :plantCode AND (a.flag IS NULL OR a.flag = 'T')
          """;
          params["plantCode"] = plantCode;
          break;

        default:
          log('User role $role is not authorized to view reports.');
          return [];
      }

      // Add date and time filters to the query for all roles
      if (dateFilter != null) {
        if (baseQuery.contains("WHERE")) {
          baseQuery += " AND report_date = :reportDate";
        } else {
          baseQuery += " WHERE report_date = :reportDate";
        }
        params["reportDate"] = dateFilter;
      }
      if (time != null) {
        if (baseQuery.contains("WHERE")) {
          baseQuery += " AND time = :time";
        } else {
          baseQuery += " WHERE time = :time";
        }
        params["time"] = time;
      }

      // Add the ORDER BY clause
      baseQuery += " ORDER BY transaction_date DESC";

      final IResultSet result = await connection!.execute(baseQuery, params);

      log(
        'Fetched ${result.rows.length} reports for user $username with role $role.',
      );
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all reports: $e');
      return [];
    } finally {
      try {
        await closeMySQLConnection(connection);
        log("Is still connected: ${connection?.connected}");
      } catch (e) {
        log('Error closing connection: $e');
      }
    }
  }

  Future<String?> getLatestTicketId(String plantCode) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get latest ticket id.');
        return null;
      }
      connection = connResult.connection;
      final result = await connection!.execute(
        // "SELECT id FROM t_quality_report_refinery WHERE plant = :plant order by id DESC LIMIT 1;",
        // {"plant": plantCode},
        "SELECT concat(prefix,plantid,accountingyear,autonumber) as ticket FROM m_controlnumber WHERE plantid = :plant AND prefix = 'QRM'",
        {"plant": plantCode},
      );

      if (result.rows.isNotEmpty) {
        final row = result.rows.first.assoc();

        final latestId = row['ticket'];
        log("ticket id from database: ${row['ticket']}");

        return latestId;
      }
      await closeMySQLConnection(connection);
      return null;
    } catch (e) {
      log('Error fetching latest ticket id: $e');
      return null;
    } finally {
      try {
        await closeMySQLConnection(connection);
        log("Is still connected: ${connection?.connected}");
      } catch (e) {
        log('Error closing connection: $e');
      }
    }
  }

  Future<bool> updateAutoNumber(String plantCode, int newAutoNumber) async {
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for updating autonumber.');
        return false;
      }

      final sql =
          "UPDATE m_controlnumber SET autonumber = :autonumber WHERE plantid = :plantid AND prefix = 'QRM'";
      final params = {"autonumber": newAutoNumber, "plantid": plantCode};

      final result = await connResult.connection!.execute(sql, params);
      log(
        'Autonumber for $plantCode updated. Affected rows: ${result.affectedRows}',
      );
      connResult.connection?.close();
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error updating autonumber: $e');
      return false;
    }
  }

  Future<bool> updateTicket(QualityReportQcEntity entity, String role) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for updating ticket.');
        return false;
      }

      connection = connResult.connection;

      final entityData = entity.toMap();
      final List<String> setClause = [];
      final Map<String, dynamic> sqlExecuteParams = {};

      entityData.forEach((keyInEntityMap, value) {
        if (keyInEntityMap != 'id') {
          String actualDbColumnName = keyInEntityMap;
          String safeParameterName = keyInEntityMap;

          // Handle specific column name mappings
          if (keyInEntityMap == 'rm_mni') {
            actualDbColumnName = 'rm_m&i';
            safeParameterName = 'rm_mni_param';
          } else if (keyInEntityMap == 'fg_mni') {
            actualDbColumnName = 'fg_m&i';
            safeParameterName = 'fg_mni_param';
          } else if (keyInEntityMap == 'bp_mni') {
            actualDbColumnName = 'bp_m&i';
            safeParameterName = 'bp_mni_param';
          } else if (keyInEntityMap == 'wsbeqc') {
            actualDbColumnName = 'w_sbe_qc';
            safeParameterName = 'w_sbe_qc_param';
          } else if (keyInEntityMap == 'w_sbe_mni') {
            actualDbColumnName = 'w_sbe_m&i';
            safeParameterName = 'w_sbe_mni_param';
          } else if (keyInEntityMap == 'w_sbe_m&i') {
            actualDbColumnName = 'w_sbe_m&i';
            safeParameterName = 'w_sbe_mni_param';
          }

          setClause.add('`$actualDbColumnName` = :$safeParameterName');

          sqlExecuteParams[safeParameterName] = value;
        }
      });
      sqlExecuteParams['id'] = entity.id;

      final sql =
          "UPDATE t_quality_report_qc SET ${setClause.join(', ')} WHERE id = :id";

      log('Generated UPDATE SQL: $sql');
      log('Params for SQL: $sqlExecuteParams');

      final result = await connection!.execute(sql, sqlExecuteParams);
      log('ticket updated: ${result.affectedRows} row(s) affected.');
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error updating report: $e');
      return false;
    } finally {
      try {
        await closeMySQLConnection(connection);
      } catch (e) {
        log('$e');
      }
    }
  }

  Future<List<Map<String, dynamic>>> getReportsForManager(
    String plantCode,
  ) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for get all reports.');
        return [];
      }
      connection = connResult.connection;
      //TODO
      final result = await connection!.execute(
        """
          SELECT
            a.id,
            a.company,
            a.plant,
            a.transaction_date,
            a.posting_date,
            a.work_center,
            a.oil_type AS oil_type_id,
            b.raw_material AS oil_type,
            a.`time`,
            a.shift,
            a.rm_flowrate,
            a.rm_tank_source,
            a.rm_temp,
            a.rm_ffa,
            a.rm_iv,
            a.rm_dobi,
            a.rm_av,
            a.`rm_m&i`,
            a.rm_pv,
            a.rm_totox,
            a.rm_color_r,
            a.rm_color_y,
            a.rm_color_b,
            a.bo_color_r,
            a.bo_color_y,
            a.bo_color_b,
            a.bo_break_test,
            a.fg_ffa,
            a.fg_iv,
            a.fg_pv,
            a.fg_moisture,
            a.fg_impurities,
            a.fg_color_r,
            a.fg_color_y,
            a.fg_color_b,
            a.fg_tank_to,
            a.fg_tank_to_others_remarks,
            a.bp_ffa,
            a.`bp_m&i`,
            a.bp_to_tank,
            a.`w_sbe_m&i`,
            a.w_sbe_qc,
            a.remarks,
            a.flag,
            a.entry_by,
            a.entry_date,
            a.prepared_by,
            a.prepared_date,
            a.prepared_status,
            a.prepared_status_remarks,
            a.checked_by,
            a.checked_date,
            a.checked_status,
            a.checked_status_remarks,
            a.updated_by,
            a.updated_date,
            a.form_no,
            a.date_issued,
            a.revision_no,
            a.revision_date,
            a.daily_production_refinery_id,
            c.be_ref_tank,
            c.be_ref_qty,
            c.be_total_bag,
            c.be_total_jenis,
            c.be_lot_batch_number,
            c.be_yield_percent,
            c.pa_ref_tank,
            c.pa_ref_qty,
            c.pa_total,
            c.pa_lot_batch_number,
            c.pa_yield_percent,
            c.uu_item,
            c.uu_budget_ref_tank,
            c.uu_budget_qty,
            c.uu_total_cpo,
            c.uu_total_steam,
            c.uu_steam_cpo,
            c.uu_yield_percent
          FROM
            t_quality_report_qc AS a
          JOIN 
            m_product AS b
          ON 
            a.oil_type = b.id
             LEFT JOIN 
          t_daily_production_refinery AS c ON a.daily_production_refinery_id = c.id
          WHERE
           a.prepared_status = 'Approved' AND a.plant = :plantCode AND (a.flag IS NULL OR a.flag = 'T')
        """,
        {"plantCode": plantCode},
      );
      log('Fetched ${result.rows.length} row.');
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching all prepared transactions: $e');
      return [];
    }
  }

  Future<bool> sendApproveRejectTicket(
    final String username,
    final String status,
    final String userRole,
    final int shift,
    final String? remark,
    final String id,
  ) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log(
          'Failed to get MySQL connection for sending approve/reject ticket.',
        );
        return false;
      }

      connection = connResult.connection;
      final date = DateTime.now();

      if (userRole == "MGR" || userRole == "MGR_QC") {
        final sql =
            "UPDATE t_quality_report_qc SET checked_by = :username, checked_status = :status, checked_date = :date, checked_status_remarks = :remark WHERE id = :id";

        final result = await connection!.execute(sql, {
          "username": username,
          "status": status,
          "date": date,
          "remark": remark,
          "id": id,
        });
        log("Query Sent: $sql");
        log("Affected Rows: ${result.affectedRows}");
        return result.affectedRows > BigInt.from(0);
      } else {
        final sql =
            "UPDATE t_quality_report_qc SET prepared_by = :username, prepared_status = :status, prepared_date = :date, prepared_status_remarks = :remark WHERE id = :id";

        final result = await connection!.execute(sql, {
          "username": username,
          "status": status,
          "date": date,
          "remark": remark,
          "id": id,
        });
        log("Query Sent: $sql");
        log("Affected Rows: ${result.affectedRows}");
        return result.affectedRows > BigInt.from(0);
      }
    } catch (e) {
      log("Error sending approve or reject ticket");
      return false;
    } finally {
      try {
        await closeMySQLConnection(connection);
      } catch (e) {
        log('$e');
      }
    }
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
    // Removed 'final String id'
  ) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log(
          'Failed to get MySQL connection for sending approve/reject ticket.',
        );
        return false;
      }

      connection = connResult.connection;
      final date = DateTime.now();

      // 1. Define the parameters map once, as it is used in both branches
      // (excluding the specific SET columns which vary by role)
      final parameters = {
        "username": username,
        "status": status,
        "date": date,
        "remark": remark,
        "plant": plant,
        "transactionDate": transactionDate,
        "workCenter": workCenter,
        "shift": shift,
      };

      if (userRole == "MGR" || userRole == "MGR_QC") {
        // 2. Updated SQL for Managers
        final sql =
            "UPDATE t_quality_report_qc SET checked_by = :username, checked_status = :status, checked_date = :date, checked_status_remarks = :remark WHERE plant = :plant AND DATE(transaction_date) = :transactionDate AND work_center = :workCenter AND shift = :shift";

        final result = await connection!.execute(sql, parameters);

        log("Query Sent: $sql");
        log("Affected Rows: ${result.affectedRows}");
        return result.affectedRows > BigInt.from(0);
      } else {
        // 3. Updated SQL for other roles
        final sql =
            "UPDATE t_quality_report_qc SET prepared_by = :username, prepared_status = :status, prepared_date = :date, prepared_status_remarks = :remark WHERE plant = :plant AND DATE(transaction_date) = :transactionDate AND work_center = :workCenter AND shift = :shift";

        final result = await connection!.execute(sql, parameters);

        log("Query Sent: $sql");
        log("Affected Rows: ${result.affectedRows}");
        return result.affectedRows > BigInt.from(0);
      }
    } catch (e) {
      log(
        "Error sending approve or reject ticket: $e",
      ); // Added $e to log the actual error
      return false;
    } finally {
      try {
        await closeMySQLConnection(connection);
      } catch (e) {
        log('$e');
      }
    }
  }

  Future<List<int>> getReportedHours(
    DateTime dateFilter,
    String plantCode,
  ) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();

      if (connResult.connection == null) {
        log('Failed to get MySQL connection for updating autonumber.');
        return [];
      }
      connection = connResult.connection!;
      final result = await connection.execute(
        "SELECT time FROM t_quality_report_qc WHERE date(posting_date) = :date AND plant = :plantCode AND (flag IS NULL OR flag = 'T');",
        {"date": dateFilter, "plantCode": plantCode},
      );

      final List<int> hours = [];
      for (final row in result.rows) {
        // row.assoc() converts the row into a Map<String, dynamic>
        // We access the 'time' column and cast it to an int.
        // It's good practice to handle potential nulls or incorrect types.
        final timeValue = row.assoc()['time'];
        if (timeValue is int && timeValue != null) {
          log(timeValue);
          hours.add(int.tryParse(timeValue) ?? 0);
        }
      }
      return hours;
    } catch (e) {
      return [];
    } finally {
      await closeMySQLConnection(connection);
    }
  }

  Future<List<Map<String, dynamic>>> getReadyForManagerApprovalReports() async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for manager alerts.');
        return [];
      }
      connection = connResult.connection!;
      log('attempting the select query.');
      // TODO
      /// SELECT
      //   DATE(a.posting_date) AS report_date,
      //   a.work_center,
      //   b.raw_material AS oil_type

      // FROM
      //   t_quality_report_qc AS a

      // JOIN
      //   m_product AS b
      // ON
      //   a.oil_type = b.id

      // WHERE
      //   (flag IS NULL OR flag = 'T') AND
      //   posting_date >= CURDATE() - INTERVAL 7 DAY
      // GROUP BY
      //   DATE(a.posting_date),
      //   a.work_center,
      //   b.raw_material AS oil_type
      // HAVING
      //   SUM(shift in (1,2,3,4,5) AND prepared_status = 'Approved') = 24
      // AND
      //   COUNT(checked_status) < 24;
      final result = await connection.execute("""
          SELECT
            DATE(posting_date) as report_date,
            work_center,
            oil_type
          FROM
            t_quality_report_qc
          WHERE
            (flag IS NULL OR flag = 'T') AND
            posting_date >= CURDATE() - INTERVAL 7 DAY
          GROUP BY
            DATE(posting_date),
            work_center,
            oil_type
          HAVING
           SUM(shift in (1,2,3,4,5) AND prepared_status = 'Approved') = 24
          AND
            COUNT(checked_status) < 24;
          """);
      log('done selecting.');
      log("Affected Rows: ${result.affectedRows}");

      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching reports ready for manager approval: $e');
      return [];
    } finally {
      await closeMySQLConnection(connection);
    }
  }

  Future<bool> deleteTicket(String id, String username) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();

      if (connResult.connection == null) {
        log('Failed to get MySQL connection for deleting ticket.');
        return false;
      }

      connection = connResult.connection!;

      final result = await connection.execute(
        // "DELETE FROM t_quality_report_refinery WHERE id = :id", // Delete query
        "UPDATE t_quality_report_qc SET flag = 'D', prepared_by = :username, prepared_status = :prepared_status, prepared_date = :prepared_date WHERE id = :id", // Delete with Flag
        {
          "username": username,
          "prepared_status": "Deleted",
          "prepared_date": "${DateTime.now()}",
          "id": id,
        },
      );
      log('Ticket $id terhapus: ${result.affectedRows} row(s) affected.');
      // connResult.connection?.close();
      return result.affectedRows > BigInt.from(0);
    } catch (e) {
      log('Error deleting ticket: $e');
      return false;
    } finally {
      try {
        await closeMySQLConnection(connection);
        log("Is still connected: ${connection?.connected}");
      } catch (e) {
        log("Error closing connection: $e");
      }
    }
  }

  Future<List<Map<String, dynamic>>> getTickets(
    DateTime? dateFilter,
    String plantCode, {
    String? shift = "All",
  }) async {
    MySQLConnection? connection;
    try {
      final connResult = await getMySQLConnection();
      if (connResult.connection == null) {
        log('Failed to get MySQL connection for getTickets.');
        return [];
      }
      connection = connResult.connection;
      String query = """
          SELECT
            a.id,
            a.company,
            a.plant,
            a.transaction_date,
            a.posting_date,
            a.work_center,
            a.oil_type AS oil_type_id,
            b.raw_material AS oil_type,
            a.`time`,
            a.shift,
            a.rm_flowrate,
            a.rm_tank_source,
            a.rm_temp,
            a.rm_ffa,
            a.rm_iv,
            a.rm_dobi,
            a.rm_av,
            a.`rm_m&i`,
            a.rm_pv,
            a.rm_totox,
            a.rm_color_r,
            a.rm_color_y,
            a.rm_color_b,
            a.bo_color_r,
            a.bo_color_y,
            a.bo_color_b,
            a.bo_break_test,
            a.fg_ffa,
            a.fg_iv,
            a.fg_pv,
            a.fg_moisture,
            a.fg_impurities,
            a.fg_color_r,
            a.fg_color_y,
            a.fg_color_b,
            a.fg_tank_to,
            a.fg_tank_to_others_remarks,
            a.bp_ffa,
            a.`bp_m&i`,
            a.bp_to_tank,
            a.`w_sbe_m&i`,
            a.w_sbe_qc,
            a.remarks,
            a.flag,
            a.entry_by,
            a.entry_date,
            a.prepared_by,
            a.prepared_date,
            a.prepared_status,
            a.prepared_status_remarks,
            a.checked_by,
            a.checked_date,
            a.checked_status,
            a.checked_status_remarks,
            a.updated_by,
            a.updated_date,
            a.form_no,
            a.date_issued,
            a.revision_no,
            a.revision_date,
            a.daily_production_refinery_id,
            c.be_ref_tank,
            c.be_ref_qty,
            c.be_total_bag,
            c.be_total_jenis,
            c.be_lot_batch_number,
            c.be_yield_percent,
            c.pa_ref_tank,
            c.pa_ref_qty,
            c.pa_total,
            c.pa_lot_batch_number,
            c.pa_yield_percent,
            c.uu_item,
            c.uu_budget_ref_tank,
            c.uu_budget_qty,
            c.uu_total_cpo,
            c.uu_total_steam,
            c.uu_steam_cpo,
            c.uu_yield_percent
          
        FROM
          t_quality_report_qc AS a
        JOIN 
          m_product AS b ON a.oil_type = b.id
        LEFT JOIN 
          t_daily_production_refinery AS c ON a.daily_production_refinery_id = c.id
          
        WHERE 
          DATE(a.posting_date) = :dateFilter 
          AND a.plant = :plantCode 
          AND (a.flag IS NULL OR a.flag = 'T')
         """;

      dateFilter ??= DateTime.now();

      final Map<String, dynamic> params = {
        "dateFilter": DateFormat('yyyy-MM-dd').format(dateFilter),
        "plantCode": plantCode,
      };
      log("Params: $params");

      if (shift != "All") {
        query += " AND shift = :shift";
        params['shift'] = shift;
      }
      log("Query: $query");
      log("Params: $params");

      final IResultSet result = await connection!.execute(query, params);
      log("QR Tickets fetched: ${result.rows.length}");
      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log("(QR MySQL) Error getting all Quality Report tickets: $e");
      return [];
    } finally {
      if (connection != null) {
        await connection.close();
        log('(QR MySQL) MySQL connection closed for getTickets.');
      }
    }
  }

  Future<List<Map<String, dynamic>>> getDailyProductionRefineryByFilter({
    required String plantCode,
    DateTime? transactionDate,
    String? workCenter,
    int? shift,
  }) async {
    MySQLConnection? connection;

    try {
      final connResult = await getMySQLConnection();
      connection = connResult.connection;

      if (connection == null) {
        log('Failed to get MySQL connection.');
        return [];
      }

      String query = """
      SELECT
        a.id,
        a.transaction_date,
        a.work_center,
        a.shift,
        a.cpo_tank,
        a.form_no,
        a.flag,
        a.be_ref_tank,
        a.be_ref_qty,
        a.be_total_bag,
        a.be_total_jenis,
        a.be_lot_batch_number,
        a.be_yield_percent,
        a.pa_ref_tank,
        a.pa_ref_qty,
        a.pa_total,
        a.pa_lot_batch_number,
        a.pa_yield_percent,
        a.uu_item,
        a.uu_budget_ref_tank,
        a.uu_budget_qty,
        a.uu_total_cpo,
        a.uu_total_steam,
        a.uu_steam_cpo,
        a.uu_yield_percent
      FROM t_daily_production_refinery a
      WHERE a.plant = :plantCode
        AND (a.flag IS NULL OR a.flag = 'T')
    """;

      final params = <String, dynamic>{"plantCode": plantCode};

      if (transactionDate != null) {
        query += " AND DATE (a.transaction_date) = :transactionDate";
        params["transactionDate"] = transactionDate;
      }

      if (workCenter != null && workCenter.isNotEmpty) {
        query += " AND a.work_center = :workCenter";
        params["workCenter"] = workCenter;
      }

      if (shift != null) {
        query += " AND a.shift = :shift";
        params["shift"] = shift;
      }

      query += " ORDER BY a.transaction_date DESC";

      final result = await connection.execute(query, params);

      log('Fetched ${result.rows.length} production records.');

      return result.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      log('Error fetching production data: $e');
      return [];
    } finally {
      await closeMySQLConnection(connection);
    }
  }

  // Di dalam class QualityReportQCMySQLService

  Future<String?> checkExistingInterlockDailyProductionRefineryData({
    required String plant,
    required String workCenter,
    required String date, // Format: YYYY-MM-DD
  }) async {
    MySQLConnection? connection;
    try {
      // 1. Buka Koneksi (mengikuti pola yang ada di file anda)
      var connResult = await getMySQLConnection();
      if (connResult.connection == null) return null;
      connection = connResult.connection;

      // 2. Query untuk mencari kakak tertua (data pertama) hari ini
      // Asumsi nama kolom foreign key adalah 'production_refinery_id'
      // Sesuaikan nama tabel dan kolom jika berbeda
      const String sql = """
      SELECT daily_production_refinery_id 
      FROM t_quality_report_qc 
      WHERE plant = :plant
        AND work_center = :workCenter
        AND DATE(transaction_date) = :date
        AND daily_production_refinery_id IS NOT NULL
        AND flag = 'T'
      LIMIT 1
    """;

      final params = {"plant": plant, "workCenter": workCenter, "date": date};

      var result = await connection!.execute(sql, params);

      // 3. Jika ketemu, kembalikan ID-nya
      if (result.rows.isNotEmpty) {
        // Mengambil nilai kolom pertama
        final id = result.rows.first.colAt(0);
        log('Found interlock daily production refinery id: $id');
        return id;
      }

      return null; // Tidak ditemukan, berarti user harus pilih manual
    } catch (e) {
      log("Error checking interlock: $e");
      return null;
    } finally {
      // 4. Tutup koneksi
      await closeMySQLConnection(connection);
    }
  }

  Future<bool> updateInterlockDailyProductionRefineryData({
    required String plant,
    required String workCenter,
    required String date,
    required String newId,
    // parameter oldId kita hapus atau abaikan saja
  }) async {
    MySQLConnection? connection;
    try {
      var connResult = await getMySQLConnection();
      if (connResult.connection == null) return false;
      connection = connResult.connection;

      // PERUBAHAN DI SINI:
      // Saya menghapus "AND daily_production_refinery_id = :oldId"
      // Logikanya: "Apapun isinya dulu (Null/Isi), timpa dengan yang baru untuk hari & mesin ini"
      const String sql = """ 
      UPDATE t_quality_report_qc 
      SET daily_production_refinery_id = :newId
      WHERE plant = :plant
        AND work_center = :workCenter
        AND DATE(transaction_date) = :date
        AND (flag IS NULL OR flag = 'T') 
    """;

      final params = {
        "newId": newId,
        "plant": plant,
        "workCenter": workCenter,
        "date": date,
        // "oldId": oldId, // Tidak perlu lagi
      };

      var result = await connection!.execute(sql, params);

      // Kita cek affected rows.
      // Walaupun 0 (karena belum ada data QC sama sekali), return true tidak masalah
      // karena tujuannya adalah memastikan "kalau ada data, update".
      return true;
    } catch (e) {
      log("Error updating interlock: $e");
      return false;
    } finally {
      await closeMySQLConnection(connection);
    }
  }

  // Di dalam class QualityReportQCMySQLService

  Future<bool> checkAnyDataExists({
    required String plant,
    required String workCenter,
    required String date, // Format: YYYY-MM-DD
  }) async {
    MySQLConnection? connection;
    try {
      var connResult = await getMySQLConnection();
      if (connResult.connection == null) return false;
      connection = connResult.connection;

      // Query ringan: Cukup cari 1 baris saja
      const String sql = """
      SELECT 1 
      FROM t_quality_report_qc 
      WHERE plant = :plant
        AND work_center = :workCenter
        AND DATE(transaction_date) = :date
        AND (flag IS NULL OR flag = 'T')
      LIMIT 1
    """;

      final params = {"plant": plant, "workCenter": workCenter, "date": date};

      var result = await connection!.execute(sql, params);

      // Jika ada row, berarti data sudah ada (return true)
      return result.rows.isNotEmpty;
    } catch (e) {
      log("Error checking data existence: $e");
      return false;
    } finally {
      await closeMySQLConnection(connection);
    }
  }
}
